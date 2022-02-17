package com.dalgona.zerozone.web;

import com.dalgona.zerozone.service.user.UserService;
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
        // 회원가입 로직 실행하고 201 응답
        userService.join(userSaveRequestDTO);
        return new ResponseEntity(HttpStatus.CREATED);
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


}
