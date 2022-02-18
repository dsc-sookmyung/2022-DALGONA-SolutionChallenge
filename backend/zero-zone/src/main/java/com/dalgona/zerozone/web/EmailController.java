package com.dalgona.zerozone.web;

import com.dalgona.zerozone.service.email.EmailService;
import com.dalgona.zerozone.web.dto.user.UserCodeValidateRequestDTO;
import lombok.RequiredArgsConstructor;
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
    public ResponseEntity<String> emailAuth(@RequestBody Map<String, String> email) throws Exception {
        emailService.sendSimpleMessage(email.get("email"));
        return ResponseEntity.ok().body("sended");
    }

    // 이메일 인증 코드 검증
    @PostMapping("/email/code/verify")
    public ResponseEntity<?> verifyCode(@RequestBody UserCodeValidateRequestDTO codeValidDTO) {
        System.out.println("codeValidDTO.getEmail() = " + codeValidDTO.getEmail());
        emailService.validateCode(codeValidDTO);
        return ResponseEntity.ok().body("validated");
    }
}