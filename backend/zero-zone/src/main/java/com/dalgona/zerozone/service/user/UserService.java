package com.dalgona.zerozone.service.user;

import com.dalgona.zerozone.config.security.JwtTokenProvider;
import com.dalgona.zerozone.domain.bookmark.BookmarkReading;
import com.dalgona.zerozone.domain.bookmark.BookmarkReadingRepository;
import com.dalgona.zerozone.domain.bookmark.BookmarkSpeaking;
import com.dalgona.zerozone.domain.bookmark.BookmarkSpeakingRepository;
import com.dalgona.zerozone.domain.recent.RecentReading;
import com.dalgona.zerozone.domain.recent.RecentReadingRepository;
import com.dalgona.zerozone.domain.recent.RecentSpeaking;
import com.dalgona.zerozone.domain.recent.RecentSpeakingRepository;
import com.dalgona.zerozone.domain.user.*;
import com.dalgona.zerozone.web.dto.Response;
import com.dalgona.zerozone.web.dto.user.UserInfoResponseDto;
import com.dalgona.zerozone.web.dto.user.UserLoginRequestDto;
import com.dalgona.zerozone.web.dto.user.UserSaveRequestDto;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletRequest;
import java.util.Optional;

@RequiredArgsConstructor
@Service
public class UserService {

    private final UserRepository userRepository;
    private final UserEmailAuthRepository userEmailAuthRepository;
    private final BookmarkReadingRepository bookmarkReadingRepository;
    private final BookmarkSpeakingRepository bookmarkSpeakingRepository;
    private final RecentReadingRepository recentReadingRepository;
    private final RecentSpeakingRepository recentSpeakingRepository;

    private final PasswordEncoder pwdEncorder;
    private final JwtTokenProvider jwtTokenProvider;
    private final Response response;

    // 회원가입
    @Transactional
    public ResponseEntity<?> join(UserSaveRequestDto userSaveRequestDTO){
        if (isExistMethod(userSaveRequestDTO.getEmail())) {
            return response.fail("이미 회원가입된 이메일입니다.", HttpStatus.BAD_REQUEST);
        }
        // 이메일 인증을 마친 사용자인지 확인
        if (!isAuthed(userSaveRequestDTO.getEmail())){
            return response.fail("이메일이 인증되지 않은 이메일입니다.", HttpStatus.BAD_REQUEST);
        }
        // 비밀번호 암호화
        String encodedPwd = pwdEncorder.encode(userSaveRequestDTO.getPassword());
        userSaveRequestDTO.encodePwd(encodedPwd);
        // DB 저장
        User user = userRepository.save(userSaveRequestDTO.toEntity());

        // 북마크 생성
        BookmarkReading bookmarkReading = new BookmarkReading(user);
        bookmarkReadingRepository.save(bookmarkReading);
        BookmarkSpeaking bookmarkSpeaking = new BookmarkSpeaking(user);
        bookmarkSpeakingRepository.save(bookmarkSpeaking);

        // 최근학습 생성
        RecentReading recentReading = new RecentReading(user);
        recentReadingRepository.save(recentReading);
        RecentSpeaking recentSpeaking = new RecentSpeaking(user);
        recentSpeakingRepository.save(recentSpeaking);

        return response.success("회원가입에 성공했습니다.");
    }

    // 이메일 중복체크 내부 메소드
    public boolean isExistMethod(String email) {
        Optional<User> findUser = userRepository.findByEmail(email);
        return findUser.isPresent();
    }

    // 이메일 중복체크
    @Transactional
    public ResponseEntity<?> isExist(String email){
        return response.success(isExistMethod(email), "이메일 중복체크에 성공했습니다.", HttpStatus.OK);
    }

    // 로그인
    @Transactional
    public ResponseEntity<?> login(UserLoginRequestDto userLoginRequestDTO){
        if (!isExistMethod(userLoginRequestDTO.getEmail())) {
            return response.fail("가입되지 않은 E-MAIL 입니다.", HttpStatus.BAD_REQUEST);
        }
        UserSecurity member = new UserSecurity(userRepository.findByEmail(userLoginRequestDTO.getEmail()).get());
        if (!pwdEncorder.matches(userLoginRequestDTO.getPassword(), member.getPassword())) {
            return response.fail("잘못된 비밀번호입니다.", HttpStatus.BAD_REQUEST);
        }
//        String name = userRepository.findByEmail(member.getUsername()).get().getName();
        String token = jwtTokenProvider.createToken(member.getUsername());
        return response.success(token, "로그인에 성공했습니다.", HttpStatus.OK);
    }

    // 토큰 가져오기
    public String getToken(HttpServletRequest request){
        return jwtTokenProvider.resolveToken(request);
    }

    // 토큰 유효성 검사
    public boolean isValidToken(String token){
        return jwtTokenProvider.validateToken(token);
    }

    // 토큰이 유효하지 않은 경우의 응답 반환
    public ResponseEntity<?> getResponseOfUnvalidateToken(){
        return response.fail("유효하지 않은 토큰입니다.", HttpStatus.BAD_REQUEST);
    }

    // 인증된 이메일인지 확인
    public boolean isAuthed(String email){
        Optional<UserEmailAuth> findUser = userEmailAuthRepository.findByEmail(email);
        if(!findUser.isPresent())
            return false;
        else if(findUser.get().isAuthStatus())
            return true;
        else
            return false;
    }

    // 내 정보 조회
    @Transactional
    public ResponseEntity<?> getMyInfo(String token){
        System.out.println("UserService - getMyInfo");
        String email = jwtTokenProvider.getUserPk(token);
        if (!isExistMethod(email)) {
            return response.fail("가입되지 않은 E-MAIL 입니다.", HttpStatus.BAD_REQUEST);
        }
        String name = userRepository.findByEmail(email).get().getName();
        UserInfoResponseDto info = new UserInfoResponseDto(email, name);
        return response.success(info, "내 정보 조회에 성공했습니다.", HttpStatus.OK);
    }

    // 이름 수정
    @Transactional
    public ResponseEntity<?> updateMyName(String token, String name){
        String email = jwtTokenProvider.getUserPk(token);
        if (!isExistMethod(email)) {
            return response.fail("가입되지 않은 E-MAIL 입니다.", HttpStatus.BAD_REQUEST);
        }
        User findUser = userRepository.findByEmail(email).get();
        findUser.updateName(name);
        return response.success("회원 이름 수정에 성공했습니다.");
    }

    // 비밀번호 수정
    @Transactional
    public ResponseEntity<?> updateMyPassword(String token, String password){
        String email = jwtTokenProvider.getUserPk(token);
        if (!isExistMethod(email)) {
            return response.fail("가입되지 않은 E-MAIL 입니다.", HttpStatus.BAD_REQUEST);
        }
        String encodedPwd = pwdEncorder.encode(password);
        User findUser = userRepository.findByEmail(email).get();
        findUser.updatePassword(encodedPwd);
        return response.success("회원 비밀번호 수정에 성공했습니다.");
    }

    // 비번 분실시 비밀번호 수정
    @Transactional
    public ResponseEntity<?> updateMyPasswordIfLost(String email, String password){
        if (!isExistMethod(email)) {
            return response.fail("가입되지 않은 E-MAIL 입니다.", HttpStatus.BAD_REQUEST);
        }
        Optional<UserEmailAuth> user = userEmailAuthRepository.findByEmail(email);
        // 인증된 이메일인지 확인
        if(user.isPresent()){
            // 인증되었다면 비밀번호 수정
            if(user.get().isAuthPwdStatus()){
                String encodedPwd = pwdEncorder.encode(password);
                User findUser = userRepository.findByEmail(email).get();
                findUser.updatePassword(encodedPwd);
                return response.success("회원 비밀번호 수정에 성공했습니다.");
            }
        }
        return response.fail("인증되지 않은 이메일입니다.", HttpStatus.BAD_REQUEST);
    }

}
