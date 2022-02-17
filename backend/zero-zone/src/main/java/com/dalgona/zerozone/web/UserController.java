package com.dalgona.zerozone.web;

import com.dalgona.zerozone.service.user.UserService;
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
        // 이메일 중복이면 208 응답
        boolean isExist = userService.isExist(userSaveRequestDTO.getEmail());
        if (isExist)
            return new ResponseEntity<>(HttpStatus.ALREADY_REPORTED);
        // 회원가입 로직 실행하고 201 응답
        else{
            userService.join(userSaveRequestDTO);
            return new ResponseEntity<>(HttpStatus.CREATED);
        }

    }

    // 이메일 중복 확인
    @GetMapping("/user/email")
    public ResponseEntity<Boolean> isExist(@RequestParam("email") String email){
        // 아이디 중복 확인
        boolean isExist = userService.isExist(email);
        return ResponseEntity.ok()
                .body(isExist);
    }

    // 로그인
    @PostMapping("/user/login")
    public String login(@RequestBody UserLoginRequestDTO user) {
        return userService.login(user);
    }

}
