package com.dalgona.zerozone.web.controller;

import com.dalgona.zerozone.domain.customAnnotation.QueryStringArgResolver;
import com.dalgona.zerozone.service.test.TestCreateService;
import com.dalgona.zerozone.service.test.TestService;
import com.dalgona.zerozone.web.dto.test.TestCreateRequestDto;
import com.dalgona.zerozone.web.dto.test.TestNameUpdateRequestDto;
import com.dalgona.zerozone.web.dto.test.TestResultUpdateDto;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

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
    public ResponseEntity<?> getWordTestSettingInfo(){
        return testService.getWordTestSettingInfo();
    }

    // 문장 시험
    @GetMapping("/sentence")
    public ResponseEntity<?> getSentenceTestSettingInfo(){
        return testService.getSentenceTestSettingInfo();
    }

    // 단어+문장 시험
    @GetMapping("/random")
    public ResponseEntity<?> getRandomTestSettingInfo(){
        return testService.getRandomTestSettingInfo();
    }

    // 북마크된 문항 시험
    @GetMapping("/bookmark")
    public ResponseEntity<?> getBookmarkTestSettingInfo(){
        return testService.getBookmarkTestSettingInfo();
    }


    /*
    * 시험 문제 생성
    * */

    // 단어 시험
    // 매개변수 : 이메일, (테스트이름, 총 문제 개수)
    @PostMapping("/word")
    public ResponseEntity<?> createWordTest(
            @RequestBody TestCreateRequestDto testCreateRequestDto
            ){
        return testCreateService.createWordTest(testCreateRequestDto);
    }

    // 문장 시험
    @PostMapping(value = "/sentence", produces = "application/json; charset=utf8")
    public ResponseEntity<?> createSentenceTest(
            @RequestBody TestCreateRequestDto testCreateRequestDto
    ){
        return testCreateService.createSentenceTest(testCreateRequestDto);
    }

    // 단어+문장 시험
    @PostMapping("/random")
    public ResponseEntity<?> createRandomTest(
            @RequestBody TestCreateRequestDto testCreateRequestDto
    ){
        return testCreateService.createWordAndSentenceTest(testCreateRequestDto);
    }
    
    // 북마크된 문항 시험
    @PostMapping("/bookmark")
    public ResponseEntity<?> createBookmarkTest(
            @RequestBody TestCreateRequestDto testCreateRequestDto
    ){
        return testCreateService.createBookmarkTest(testCreateRequestDto);
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
    public ResponseEntity<?> getTestListByUser(@RequestParam(required = false, defaultValue = "1", value = "page")  int page){
        return testService.getTestListByUser(page);
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

    /*
     * 시험 정보 수정
     *  */
    @PostMapping("/name")
    public ResponseEntity<?> updateTestName(@RequestBody TestNameUpdateRequestDto updateRequestDto){
        return testService.updateTestName(updateRequestDto);
    }

    @DeleteMapping
    public ResponseEntity<?> deleteTest(@RequestParam Long testId){
        return testService.deleteTest(testId);
    }

}
