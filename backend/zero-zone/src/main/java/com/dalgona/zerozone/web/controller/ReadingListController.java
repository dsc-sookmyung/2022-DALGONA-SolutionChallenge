package com.dalgona.zerozone.web.controller;

import com.dalgona.zerozone.service.speakingAndReadingPractice.listService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RequiredArgsConstructor
@RestController
@RequestMapping("/reading/list")
public class ReadingListController {

    private final listService readingService;

    // 초성 조회
    @GetMapping("/letter/onset")
    public ResponseEntity<?> getOnsets(){
        return readingService.getOnset();
    }

    // 상황 조회
    @GetMapping("/situation")
    public ResponseEntity<?> getSituations(){
        return readingService.getSituations();
    }

}
