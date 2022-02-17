package com.dalgona.zerozone.service.user;

import com.dalgona.zerozone.domain.User;
import com.dalgona.zerozone.domain.UserRepository;
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



}
