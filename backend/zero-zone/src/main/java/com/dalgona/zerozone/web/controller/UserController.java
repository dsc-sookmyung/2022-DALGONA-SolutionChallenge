package com.dalgona.zerozone.web.controller;

import com.dalgona.zerozone.service.user.UserService;
import com.dalgona.zerozone.web.dto.user.UserLoginRequestDto;
import com.dalgona.zerozone.web.dto.user.UserSaveRequestDto;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

@RequiredArgsConstructor
@RestController
public class UserController {

    private final UserService userService;

    // 회원가입
    @PostMapping("/user")
    public ResponseEntity<?> join(@RequestBody UserSaveRequestDto userSaveRequestDTO) {
        return userService.join(userSaveRequestDTO);
    }

    // 이메일 중복 확인
    @GetMapping("/user/email")
    public ResponseEntity<?> isExist(@RequestParam String email) {
        return userService.isExist(email);
    }

    // 로그인
    @PostMapping("/user/login")
    public ResponseEntity<?> login(@RequestBody UserLoginRequestDto user) {
        return userService.login(user);
    }

    // 내 정보 조회
    @GetMapping("/user/info")
    public ResponseEntity<?> info(HttpServletRequest request) {
        return userService.getMyInfo();
    }

    // 이름 수정
    @PostMapping("/user/name")
    public ResponseEntity<?> name(HttpServletRequest request, @RequestBody Map<String, String> name) {
        return userService.updateMyName(name.get("name"));
    }

    // 비밀번호 분실시 수정
    @PostMapping("/user/password/lost")
    public ResponseEntity<?> lostPassword(HttpServletRequest request, @RequestBody Map<String, String> passwordChangeRequestDto) {
        return userService.updateMyPasswordIfLost(passwordChangeRequestDto.get("email"), passwordChangeRequestDto.get("password"));
    }

    // 인증 토큰 만료시 리프레시 토큰으로 재발급
    @PostMapping("/token/reissue/accessToken")
    public ResponseEntity<?> reissueAccessToken(@RequestBody Map<String, String> requestDto, HttpServletRequest request){
        String userEmail = requestDto.get("email");
        String refreshToken = requestDto.get("refreshToken");
        return userService.reissueAccessToken(userEmail, refreshToken, request);
    }
}
