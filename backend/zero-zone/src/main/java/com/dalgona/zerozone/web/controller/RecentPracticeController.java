package com.dalgona.zerozone.web.controller;

import com.dalgona.zerozone.service.recent.RecentReadingService;
import com.dalgona.zerozone.service.recent.RecentSpeakingService;
import com.dalgona.zerozone.web.dto.recent.RecentRequestDto;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RequiredArgsConstructor
@RestController
@RequestMapping("/recent")
public class RecentPracticeController {

    private final RecentReadingService recentReadingService;
    private final RecentSpeakingService recentSpeakingService;

    // 구화 연습 최근 학습에 추가
    @PostMapping("/reading")
    public ResponseEntity<?> addReadingRecent(@RequestBody RecentRequestDto requestDto){
        return recentReadingService.addReadingRecent(requestDto);
    }

    // 구화 연습 최근 학습 리스트 조회
    @GetMapping("/reading")
    public ResponseEntity<?> getReadingRecent(@RequestParam int page){
        return recentReadingService.getReadingRecent(page);
    }

    // 발음 연습 최근 학습에 추가
    @PostMapping("/speaking")
    public ResponseEntity<?> addSpeakingRecent(@RequestBody RecentRequestDto requestDto){
        return recentSpeakingService.addSpeakingRecent(requestDto);
    }

    // 발음 연습 최근 학습 리스트 조회
    @GetMapping("/speaking")
    public ResponseEntity<?> getSpeakingRecent(@RequestParam int page){
        return recentSpeakingService.getSpeakingRecent(page);
    }

}
