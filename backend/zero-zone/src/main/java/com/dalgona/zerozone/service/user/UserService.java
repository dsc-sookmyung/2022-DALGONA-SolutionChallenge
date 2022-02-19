package com.dalgona.zerozone.service.user;

import com.dalgona.zerozone.config.security.JwtTokenProvider;
import com.dalgona.zerozone.domain.user.User;
import com.dalgona.zerozone.domain.user.UserRepository;
import com.dalgona.zerozone.domain.user.UserSecurity;
import com.dalgona.zerozone.web.dto.Response;
import com.dalgona.zerozone.web.dto.user.UserLoginRequestDTO;
import com.dalgona.zerozone.web.dto.user.UserSaveRequestDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@RequiredArgsConstructor
@Service
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder pwdEncorder;
    private final JwtTokenProvider jwtTokenProvider;
    private final Response response;

    // 회원가입
    @Transactional
    public ResponseEntity<?> join(UserSaveRequestDTO userSaveRequestDTO){
        if (isExistMethod(userSaveRequestDTO.getEmail())) {
            return response.fail("이미 회원가입된 이메일입니다.", HttpStatus.BAD_REQUEST);
        }
        // 비밀번호 암호화
        String encodedPwd = pwdEncorder.encode(userSaveRequestDTO.getPassword());
        userSaveRequestDTO.encodePwd(encodedPwd);
        // DB 저장
        userRepository.save(userSaveRequestDTO.toEntity()).getId();
        return response.success("회원가입에 성공했습니다.");
    }

    // 이메일 중복체크 내부 메소드
    public boolean isExistMethod(String email) {
        Optional<User> findUser = userRepository.findByEmail(email);
        return findUser.isPresent();
    }

    // 이메일 중복체크
    public ResponseEntity<?> isExist(String email){
        return response.success(isExistMethod(email), "이메일 중복체크에 성공했습니다.", HttpStatus.OK);
    }

    // 로그인
    public ResponseEntity<?> login(UserLoginRequestDTO userLoginRequestDTO){

        if (!isExistMethod(userLoginRequestDTO.getEmail())) {
            return response.fail("가입되지 않은 E-MAIL 입니다.", HttpStatus.BAD_REQUEST);
        }
        UserSecurity member = new UserSecurity(userRepository.findByEmail(userLoginRequestDTO.getEmail()).get());
        if (!pwdEncorder.matches(userLoginRequestDTO.getPassword(), member.getPassword())) {
            return response.fail("잘못된 비밀번호입니다.", HttpStatus.BAD_REQUEST);
        }
        String token = jwtTokenProvider.createToken(member.getUsername());
        return response.success(token, "로그인에 성공했습니다.", HttpStatus.OK);
    }

}
