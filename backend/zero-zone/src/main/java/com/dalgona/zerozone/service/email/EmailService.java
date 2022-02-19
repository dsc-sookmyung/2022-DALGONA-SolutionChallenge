package com.dalgona.zerozone.service.email;

import com.dalgona.zerozone.domain.user.UserEmailAuth;
import com.dalgona.zerozone.domain.user.UserEmailAuthRepository;
import com.dalgona.zerozone.domain.user.UserRepository;
import com.dalgona.zerozone.service.user.UserService;
import com.dalgona.zerozone.web.dto.user.UserCodeValidateRequestDTO;
import com.dalgona.zerozone.web.dto.user.UserEmailAuthSaveDTO;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.mail.MailException;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.util.Random;

@RequiredArgsConstructor
@Service
public class EmailService {

    private final JavaMailSender emailSender;
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    private final UserEmailAuthRepository userEmailAuthRepository;

    // 인증코드 이메일 보내기
    public void sendSimpleMessage(String email) throws Exception {
        // 코드 생성하고 저장
        String code = saveCode(email);
        // 이메일 메시지 생성
        MimeMessage message = createMessage(email, code);
        try{
            // 이메일 보내기
            emailSender.send(message);
        }catch(MailException es){
            es.printStackTrace();
            throw new IllegalArgumentException();
        }
    }

    // 인증코드 db에 저장
    private String saveCode(String email){
        String code = createCode();
        UserEmailAuthSaveDTO userEmailAuthSaveDTO = new UserEmailAuthSaveDTO(email, code);
        return userEmailAuthRepository.save(userEmailAuthSaveDTO.toEntity()).getAuthCode();
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
        msg += "<a href=\"https://slack.com\" style=\"text-decoration: none; color: #434245;\" rel=\"noreferrer noopener\" target=\"_blank\">Slack Clone Technologies, Inc</a>";

        message.setText(msg, "utf-8", "html"); //내용
        message.setFrom(new InternetAddress(to,"zero-zone")); //보내는 사람

        return message;
    }

    // 인증코드 만들기
    public String createCode() {
        StringBuffer key = new StringBuffer();
        Random rnd = new Random();

        for (int i = 0; i < 6; i++) { // 인증코드 6자리
            key.append((rnd.nextInt(10)));
        }
        return key.toString();
    }

    // 인증코드 검증
    @Transactional
    public boolean validateCode(UserCodeValidateRequestDTO codeValidDTO){
        // 이메일로 코드 객체 가져오기
        UserEmailAuth findUser = userEmailAuthRepository.findByEmail(codeValidDTO.getEmail())
                .orElseThrow(() -> new IllegalArgumentException("해당 회원이 없습니다. email" + codeValidDTO.getEmail()));
        // 코드 비교
        String findCode = findUser.getAuthCode();
        if(findCode.compareTo(codeValidDTO.getAuthCode())==0){
            // 인증 상태 업데이트
            findUser.updateAuthstatus(true);
            return true;
        }
        return false;

    }



}