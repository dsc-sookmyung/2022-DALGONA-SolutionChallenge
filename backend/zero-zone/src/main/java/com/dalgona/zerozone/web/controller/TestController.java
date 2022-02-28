package com.dalgona.zerozone.web.controller;

import com.dalgona.zerozone.domain.customAnnotation.QueryStringArgResolver;
import com.dalgona.zerozone.service.test.TestService;
import com.dalgona.zerozone.web.dto.test.TestCreateRequestDto;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RequiredArgsConstructor
@RestController
@RequestMapping("/reading/test")
public class TestController {

    private final TestService testService;

    /*
    * 시험 설정 정보 조회
    * */

    // 단어 시험
    @GetMapping("/word")
    public ResponseEntity<?> getWordTestSettingInfo(@RequestParam String email){
        return testService.getWordTestSettingInfo(email);
    }

    // 문장 시험
    @GetMapping("/sentence")
    public ResponseEntity<?> getSentenceTestSettingInfo(@RequestParam String email){
        return testService.getSentenceTestSettingInfo(email);
    }

    // 단어+문장 시험
    @GetMapping("/random")
    public ResponseEntity<?> getRandomTestSettingInfo(@RequestParam String email){
        return testService.getRandomTestSettingInfo(email);
    }

    // 북마크된 문항 시험


    /*
    * 시험 문제 생성
    * */

    // 단어 시험
    // 매개변수 : 이메일, (테스트이름, 총 문제 개수)
    /*
    @PostMapping("/word")
    public ResponseEntity<?> createWordTest(
            @RequestParam String email,
            @QueryStringArgResolver TestCreateRequestDto testCreateRequestDto){
        return testService.createWordTest(email, testCreateRequestDto);
    }

     */
    
    // 문장 시험

    
    // 단어+문장 시험
    
    // 북마크된 문항 시험
    


    /*
    * 시험 문항 조회
    *  */

}
