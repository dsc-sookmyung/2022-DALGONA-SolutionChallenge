package com.dalgona.zerozone.web.controller;

import com.dalgona.zerozone.service.customProb.CustomSpeakingProbService;
import com.dalgona.zerozone.web.dto.customProb.CustomSpeakingProbSaveRequestDto;
import com.dalgona.zerozone.web.dto.customProb.CustomSpeakingProbUpdateRequestDto;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RequiredArgsConstructor
@RestController
public class CustomSpeakingPracticeController {

    private final CustomSpeakingProbService customSpeakingProbService;

    // 연습 문제 생성 : 단어 혹은 문장
    @PostMapping("/custom/speaking")
    public ResponseEntity<?> createCustomSpeakingProb(@RequestBody CustomSpeakingProbSaveRequestDto requestDto){
        return customSpeakingProbService.createCustomSpeakingProb(requestDto);
    }

    // 연습 문제 전체 조회
    @GetMapping("/custom/speaking/all")
    public ResponseEntity<?> getCustomSpeakingProbs(){
        return customSpeakingProbService.getCustomSpeakingProbs();
    }

    // 연습 문제 조회
    @GetMapping("/custom/speaking")
    public ResponseEntity<?> getCustomSpeakingProb(@RequestParam Long id){
        return customSpeakingProbService.getCustomSpeakingProb(id);
    }
    
    // 연습 문제 수정
    @PostMapping("/custom/speaking/update")
    public ResponseEntity<?> updateCustomSpeakingProb(@RequestBody CustomSpeakingProbUpdateRequestDto requestDto) {
        return customSpeakingProbService.updateCustomSpeakingProb(requestDto);
    }

    // 연습 문제 삭제
    @DeleteMapping("/custom/speaking")
    public ResponseEntity<?> deleteCustomSpeakingProb(@RequestParam Long id){
        return customSpeakingProbService.deleteCustomSpeakingProb(id);
    }

}
