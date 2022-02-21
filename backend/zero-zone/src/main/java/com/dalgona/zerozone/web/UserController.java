package com.dalgona.zerozone.web;

import com.dalgona.zerozone.config.security.JwtTokenProvider;
import com.dalgona.zerozone.service.user.UserService;
import com.dalgona.zerozone.web.dto.user.UserLoginRequestDto;
import com.dalgona.zerozone.web.dto.user.UserSaveRequestDto;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

@RequiredArgsConstructor
@RestController
public class UserController {

    private final UserService userService;
    private final JwtTokenProvider jwtTokenProvider;

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
        String token = userService.getToken(request);
        // 토큰이 유효하지 않으면 실패 응답
        if (!userService.isValidToken(token)) {
            return userService.getResponseOfUnvalidateToken();
        }
        // 토큰이 유효하면 내 정보 조회 요청
        return userService.getMyInfo(token);
    }

    // 이름 수정
    @PostMapping("/user/name")
    public ResponseEntity<?> name(HttpServletRequest request, @RequestBody Map<String, String> name) {
        String token = userService.getToken(request);
        // 토큰이 유효하지 않으면 실패 응답
        if (!userService.isValidToken(token)) {
            return userService.getResponseOfUnvalidateToken();
        }
        // 토큰이 유효하면 내 정보 수정 요청
        return userService.updateMyName(token, name.get("name"));
    }

    // 비밀번호 수정
    @PostMapping("/user/password")
    public ResponseEntity<?> password(HttpServletRequest request, @RequestBody Map<String, String> password) {
        String token = userService.getToken(request);
        // 토큰이 유효하지 않으면 실패 응답
        if (!userService.isValidToken(token)) {
            return userService.getResponseOfUnvalidateToken();
        }
        // 토큰이 유효하면 내 정보 수정 요청
        return userService.updateMyPassword(token, password.get("password"));
    }

    // 비밀번호 분실시 수정
    @PostMapping("/user/password/lost")
    public ResponseEntity<?> lostPassword(HttpServletRequest request, @RequestBody Map<String, String> passwordChangeRequestDto) {
        return userService.updateMyPasswordIfLost(
                passwordChangeRequestDto.get("email"),
                passwordChangeRequestDto.get("password"));
    }



}
