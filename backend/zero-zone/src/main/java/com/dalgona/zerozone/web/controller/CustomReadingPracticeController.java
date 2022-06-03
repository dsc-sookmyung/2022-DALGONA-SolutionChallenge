package com.dalgona.zerozone.web.controller;

import com.dalgona.zerozone.service.customProb.CustomReadingProbService;
import com.dalgona.zerozone.web.dto.customProb.CustomReadingProbSaveRequestDto;
import com.dalgona.zerozone.web.dto.customProb.CustomReadingProbUpdateRequestDto;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RequiredArgsConstructor
@RestController
public class CustomReadingPracticeController {

    private final CustomReadingProbService customReadingProbService;

    // 연습 문제 생성 : 단어 혹은 문장
    @PostMapping("/custom/reading")
    public ResponseEntity<?> createCustomReadingProb(@RequestBody CustomReadingProbSaveRequestDto requestDto){
        return customReadingProbService.createCustomReadingProb(requestDto);
    }

    // 연습 문제 리스트
    @GetMapping("/custom/reading/all")
    public ResponseEntity<?> getCustomReadingProbs(){
        return customReadingProbService.getCustomReadingProbs();
    }

    // 연습 문제 조회
    @GetMapping("/custom/reading")
    public ResponseEntity<?> getCustomReadingProb(@RequestParam Long id){
        return customReadingProbService.getCustomReadingProb(id);
    }

    // 연습 문제 수정
    // reading : 힌트, 띄어쓰기 정보, 타입 | 내용, url
    @PostMapping("/custom/reading/update")
    public ResponseEntity<?> updateCustomReadingProb(@RequestBody CustomReadingProbUpdateRequestDto requestDto) {
        return customReadingProbService.updateCustomReadingProb(requestDto);
    }

    // 연습 문제 삭제
    @DeleteMapping("/custom/reading")
    public ResponseEntity<?> deleteCustomReadingProb(@RequestParam Long id){
        return customReadingProbService.deleteCustomReadingProb(id);
    }

    // 랜덤이 필요하다면..



}
