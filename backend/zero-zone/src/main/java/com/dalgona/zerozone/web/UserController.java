package com.dalgona.zerozone.web;

import com.dalgona.zerozone.service.user.UserService;
import com.dalgona.zerozone.web.dto.Response;
import com.dalgona.zerozone.web.dto.user.UserLoginRequestDTO;
import com.dalgona.zerozone.web.dto.user.UserSaveRequestDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RequiredArgsConstructor
@RestController
public class UserController {

    private final UserService userService;

    // 회원가입
    @PostMapping("/user")
    public ResponseEntity<?> join(@RequestBody UserSaveRequestDTO userSaveRequestDTO) {
        return userService.join(userSaveRequestDTO);
    }

    // 이메일 중복 확인
    @GetMapping("/user/email")
    public ResponseEntity<?> isExist(@RequestParam("email") String email){
        return userService.isExist(email);
    }

    // 로그인
    @PostMapping("/user/login")
    public ResponseEntity<?> login(@RequestBody UserLoginRequestDTO user) {
        return userService.login(user);
    }

}
