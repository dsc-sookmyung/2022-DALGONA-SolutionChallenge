package com.dalgona.zerozone.web.controller;

import com.dalgona.zerozone.service.email.EmailService;
import com.dalgona.zerozone.web.dto.Response;
import com.dalgona.zerozone.web.dto.user.UserCodeValidateRequestDto;
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
            String myEmail = email.get("email");
            // 코드 처리
            String code;
            // 이메일이 존재하지 않는다면 코드 저장
            if(!emailService.isExistInUserEmailAuth(myEmail)){
                code = emailService.saveCode(myEmail);
            }
            // 이메일이 이미 존재한다면 코드 수정
            else{
                code = emailService.updateCode(myEmail);
            }
            return emailService.sendSimpleMessage(email.get("email"), code);
        }catch (Exception i){
            Response response = new Response();
            return response.fail("사용자 이메일 인증 코드 전송에 실패했습니다.", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // 이메일 인증 코드 검증
    @PostMapping("/email/code/verify")
    public ResponseEntity<?> verifyCode(@RequestBody UserCodeValidateRequestDto codeValidDTO) {
        return emailService.validateCode(codeValidDTO);
    }


    // 비밀번호 변경시 이메일 검증을 위한 인증 코드 전송
    @PostMapping("/email/code/pwd/send")
    public ResponseEntity<?> emailPwdAuth(@RequestBody Map<String, String> email) {
        try {
            String myEmail = email.get("email");
            // 코드 처리
            String code = emailService.updatePwdCode(myEmail);
            return emailService.sendSimpleMessage(email.get("email"), code);
        }catch (Exception i){
            Response response = new Response();
            return response.fail("사용자 이메일 인증 코드 전송에 실패했습니다.", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }


    // 비밀번호 변경시 이메일 인증 코드 검증
    @PostMapping("/email/code/pwd/verify")
    public ResponseEntity<?> verifyPwdCode(@RequestBody UserCodeValidateRequestDto codePwdValidDTO) {
        return emailService.validatePwdCode(codePwdValidDTO);
    }


}