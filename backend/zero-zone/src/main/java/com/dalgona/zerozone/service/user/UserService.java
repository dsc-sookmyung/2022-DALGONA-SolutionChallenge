package com.dalgona.zerozone.service.user;

import com.dalgona.zerozone.config.security.JwtTokenProvider;
import com.dalgona.zerozone.domain.user.User;
import com.dalgona.zerozone.domain.user.UserRepository;
import com.dalgona.zerozone.domain.user.UserSecurity;
import com.dalgona.zerozone.web.dto.user.UserLoginRequestDTO;
import com.dalgona.zerozone.web.dto.user.UserSaveRequestDTO;
import lombok.RequiredArgsConstructor;
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

    // 회원가입
    @Transactional
    public Long join(UserSaveRequestDTO userSaveRequestDTO){
        // 비밀번호 암호화
        String encodedPwd = pwdEncorder.encode(userSaveRequestDTO.getPassword());
        userSaveRequestDTO.encodePwd(encodedPwd);
        // DB 저장
        return userRepository.save(userSaveRequestDTO.toEntity()).getId();
    }

    // 이메일 중복체크
    public boolean isExist(String email) {
        Optional<User> findUser = userRepository.findByEmail(email);
        return findUser.isPresent();
    }

    // 로그인
    public String login(UserLoginRequestDTO userLoginRequestDTO){
        UserSecurity member = new UserSecurity(userRepository.findByEmail(userLoginRequestDTO.getEmail())
                .orElseThrow(() -> new IllegalArgumentException("가입되지 않은 E-MAIL 입니다.")));
        if (!pwdEncorder.matches(userLoginRequestDTO.getPassword(), member.getPassword())) {
            throw new IllegalArgumentException("잘못된 비밀번호입니다.");
        }
        return jwtTokenProvider.createToken(member.getUsername());
    }

}
