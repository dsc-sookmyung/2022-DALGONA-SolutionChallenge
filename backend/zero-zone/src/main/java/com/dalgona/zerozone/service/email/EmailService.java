package com.dalgona.zerozone.service.email;

import com.dalgona.zerozone.domain.user.UserEmailAuth;
import com.dalgona.zerozone.domain.user.UserEmailAuthRepository;
import com.dalgona.zerozone.web.dto.Response;
import com.dalgona.zerozone.web.dto.user.UserCodeValidateRequestDto;
import com.dalgona.zerozone.web.dto.user.UserEmailAuthRequestDto;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.mail.MailException;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.time.LocalDateTime;
import java.util.Optional;
import java.util.Random;

@RequiredArgsConstructor
@Service
public class EmailService {

    private final JavaMailSender emailSender;
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    private final UserEmailAuthRepository userEmailAuthRepository;
    private final Response response;

    // 인증코드 이메일 보내기
    public ResponseEntity<?> sendSimpleMessage(String email, String code) throws Exception {
        // 이메일 메시지 생성
        MimeMessage message = createMessage(email, code);
        try{
            // 이메일 보내기
            emailSender.send(message);
            return response.success("사용자 이메일 인증 코드 전송에 성공했습니다.");
        }catch(MailException es){
            es.printStackTrace();
            throw new IllegalArgumentException();
        }
    }

    // 인증코드 db에 저장
    @Transactional
    public String saveCode(String email){
        String code = createCode();
        // 유효 시간도 저장
        LocalDateTime validTime = LocalDateTime.now().plusMinutes(5);
        UserEmailAuthRequestDto userEmailAuthSaveDTO = new UserEmailAuthRequestDto(email, code, validTime);
        return userEmailAuthRepository.save(userEmailAuthSaveDTO.toEntity()).getAuthCode();
    }

    // 인증코드 수정
    @Transactional
    public String updateCode(String email){
        String code = createCode();
        // 유효 시간도 저장
        UserEmailAuth findUser = userEmailAuthRepository.findByEmail(email).get();
        LocalDateTime validTime = LocalDateTime.now().plusMinutes(5);
        findUser.updateCode(code);
        findUser.updateAuthValidTime(validTime);
        return code;
    }

    // 비밀번호 변경시 인증코드 수정
    @Transactional
    public String updatePwdCode(String email){
        String code = createCode();
        UserEmailAuth findUser = userEmailAuthRepository.findByEmail(email).get();
        // 유효 시간도 저장
        LocalDateTime validTime = LocalDateTime.now().plusMinutes(5);
        findUser.updatePwdCode(code);
        findUser.updateAuthPwdValidTime(validTime);
        return code;
    }
    
    // 메시지 생성
    private MimeMessage createMessage(String to, String code) throws Exception{
        logger.info("보내는 대상 : "+ to);
        logger.info("인증 번호 : " + code);
        MimeMessage message = emailSender.createMimeMessage();

        message.addRecipients(MimeMessage.RecipientType.TO, to); //보내는 대상
        message.setSubject("zero-zone 확인 코드: " + code); //제목

        String msg="";
        msg += "<h1 style=\"font-size: 30px; padding-right: 30px; padding-left: 30px;\">이메일 주소 확인</h1>";
        msg += "<p style=\"font-size: 17px; padding-right: 30px; padding-left: 30px;\">아래 확인 코드를 zero-zone 가입 창이 있는 칸에 입력하세요.</p>";
        msg += "<div style=\"padding-right: 30px; padding-left: 30px; margin: 32px 0 40px;\"><table style=\"border-collapse: collapse; border: 0; background-color: #F4F4F4; height: 70px; table-layout: fixed; word-wrap: break-word; border-radius: 6px;\"><tbody><tr><td style=\"text-align: center; vertical-align: middle; font-size: 30px;\">";
        msg += code;
        msg += "</td></tr></tbody></table></div>";

        message.setText(msg, "utf-8", "html"); //내용
        message.setFrom(new InternetAddress(to,"zero-zone")); //보내는 사람

        return message;
    }

    // 인증코드 만들기
    private String createCode() {
        StringBuffer key = new StringBuffer();
        Random rnd = new Random();

        for (int i = 0; i < 6; i++) { // 인증코드 6자리
            key.append((rnd.nextInt(10)));
        }
        return key.toString();
    }

    // 인증코드 검증
    @Transactional
    public ResponseEntity<?> validateCode(UserCodeValidateRequestDto codeValidDTO){
        // 이메일로 코드 객체 가져오기
        if(!isExistInUserEmailAuth(codeValidDTO.getEmail())){
            return response.fail("인증 코드가 등록되지 않은 E-MAIL 입니다.", HttpStatus.BAD_REQUEST);
        }
        // 코드 비교
        UserEmailAuth findUser = userEmailAuthRepository.findByEmail(codeValidDTO.getEmail()).get();
        String findCode = findUser.getAuthCode();
        if(findCode.compareTo(codeValidDTO.getAuthCode())==0){
            // 유효 시간이 지나지 않았다면
            if(isAuthed(findUser.getEmail())){
                return response.success("이메일 인증에 성공했습니다.");
            }
            // 유효 시간이 지났다면
            else{
                return response.fail("인증 시간이 지났습니다. 다시 시도해주세요", HttpStatus.BAD_REQUEST);
            }
        }
        return response.fail("인증 코드가 틀립니다.", HttpStatus.BAD_REQUEST);

    }

    // 비밀번호 변경시 인증코드 검증
    // 유효시간 검증
    @Transactional
    public ResponseEntity<?> validatePwdCode(UserCodeValidateRequestDto codeValidDTO){
        // 이메일로 코드 객체 가져오기
        if(!isExistInUserEmailAuth(codeValidDTO.getEmail())){
            return response.fail("인증 코드가 등록되지 않은 E-MAIL 입니다.", HttpStatus.BAD_REQUEST);
        }
        // 코드 비교
        UserEmailAuth findUser = userEmailAuthRepository.findByEmail(codeValidDTO.getEmail()).get();
        String findCode = findUser.getAuthPwdCode();
        if(findCode.compareTo(codeValidDTO.getAuthCode())==0){
            // 유효 시간이 지나지 않았다면
            if(isAuthedPwd(findUser.getEmail())){
                return response.success("이메일 인증에 성공했습니다.");
            }
            // 유효 시간이 지났다면
            else{
                return response.fail("인증 시간이 지났습니다. 다시 시도해주세요", HttpStatus.BAD_REQUEST);
            }
        }
        return response.fail("인증 코드가 틀립니다.", HttpStatus.BAD_REQUEST);
    }

    // 인증된 이메일인지 확인
    public boolean isAuthed(String email){
        Optional<UserEmailAuth> findUser = userEmailAuthRepository.findByEmail(email);
        if(!findUser.isPresent())
            return false;
        LocalDateTime validTime = findUser.get().getAuthValidTime();
        if(validTime.isAfter(LocalDateTime.now()))
            return true;
        else
            return false;
    }

    // 비밀번호 인증된 이메일인지 확인
    public boolean isAuthedPwd(String email){
        Optional<UserEmailAuth> findUser = userEmailAuthRepository.findByEmail(email);
        if(!findUser.isPresent())
            return false;
        LocalDateTime validTime = findUser.get().getAuthPwdValidTime();
        if(validTime.isAfter(LocalDateTime.now()))
            return true;
        else
            return false;
    }


    @Transactional
    public boolean isExistInUserEmailAuth(String email){
        Optional<UserEmailAuth> findUser = userEmailAuthRepository.findByEmail(email);
        return findUser.isPresent();
    }

}