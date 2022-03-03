package com.dalgona.zerozone.web.controller;

import com.dalgona.zerozone.domain.customAnnotation.QueryStringArgResolver;
import com.dalgona.zerozone.service.test.TestCreateService;
import com.dalgona.zerozone.service.test.TestService;
import com.dalgona.zerozone.web.dto.test.TestCreateRequestDto;
import com.dalgona.zerozone.web.dto.test.TestResult;
import com.dalgona.zerozone.web.dto.test.TestResultUpdateDto;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RequiredArgsConstructor
@RestController
@RequestMapping("/reading/test")
public class TestController {

    private final TestService testService;
    private final TestCreateService testCreateService;

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
    @GetMapping("/bookmark")
    public ResponseEntity<?> getBookmarkTestSettingInfo(@RequestParam String email){
        return testService.getBookmarkTestSettingInfo(email);
    }


    /*
    * 시험 문제 생성
    * */

    // 단어 시험
    // 매개변수 : 이메일, (테스트이름, 총 문제 개수)
    @PostMapping("/word")
    public ResponseEntity<?> createWordTest(
            @QueryStringArgResolver TestCreateRequestDto testCreateRequestDto,
            @RequestParam String email
            ){
        return testCreateService.createWordTest(testCreateRequestDto, email);
    }

    // 문장 시험
    @PostMapping("/sentence")
    public ResponseEntity<?> createSentenceTest(
            @QueryStringArgResolver TestCreateRequestDto testCreateRequestDto,
            @RequestParam String email
    ){
        return testCreateService.createSentenceTest(testCreateRequestDto, email);
    }

    // 단어+문장 시험
    @PostMapping("/random")
    public ResponseEntity<?> createRandomTest(
            @QueryStringArgResolver TestCreateRequestDto testCreateRequestDto,
            @RequestParam String email
    ){
        return testCreateService.createWordAndSentenceTest(testCreateRequestDto, email);
    }
    
    // 북마크된 문항 시험
    @PostMapping("/bookmark")
    public ResponseEntity<?> createBookmarkTest(
            @QueryStringArgResolver TestCreateRequestDto testCreateRequestDto,
            @RequestParam String email
    ){
        return testCreateService.createBookmarkTest(testCreateRequestDto, email);
    }

    /*
     * 시험 채점
     *  */
    @PostMapping("/result")
    public ResponseEntity<?> updateTestResult(@RequestBody TestResultUpdateDto testResultUpdateDto){
        return testService.updateTestResult(testResultUpdateDto);
    }

    /*
    * 시험 문항 조회
    *  */

    // 회원의 시험 목록 조회
    @GetMapping("/list")
    public ResponseEntity<?> getTestListByUser(@RequestParam String email, @RequestParam(required = false, defaultValue = "1", value = "page")  int page){
        return testService.getTestListByUser(email, page);
    }

    // 시험의 문제 목록 조회
    @GetMapping("/list/probs")
    public ResponseEntity<?> getProbListByTest(@RequestParam Long testId, @RequestParam(required = false, defaultValue = "1", value = "page")  int page){
        return testService.getProbListByTest(testId, page);
    }

    // 문제의 채점 결과 조회
    @GetMapping("/list/probs/result")
    public ResponseEntity<?> getProbResult(@RequestParam Long testProbId){
        return testService.getProbResult(testProbId);
    }



}
