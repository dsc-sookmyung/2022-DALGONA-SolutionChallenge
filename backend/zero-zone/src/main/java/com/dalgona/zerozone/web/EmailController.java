package com.dalgona.zerozone.web;

import com.dalgona.zerozone.service.email.EmailService;
import com.dalgona.zerozone.web.dto.Response;
import com.dalgona.zerozone.web.dto.user.UserCodeValidateRequestDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RequiredArgsConstructor
@RestController
public class EmailController {

    private final EmailService emailService;

    // 이메일 인증 코드 보내기
    @PostMapping("/email/code/send")
    public ResponseEntity<?> emailAuth(@RequestBody Map<String, String> email) {
        try {
            return emailService.sendSimpleMessage(email.get("email"));
        }catch (Exception i){
            Response response = new Response();
            return response.fail("사용자 이메일 인증 코드 전송에 실패했습니다.", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // 이메일 인증 코드 검증
    @PostMapping("/email/code/verify")
    public ResponseEntity<?> verifyCode(@RequestBody UserCodeValidateRequestDTO codeValidDTO) {
        return emailService.validateCode(codeValidDTO);
    }
}