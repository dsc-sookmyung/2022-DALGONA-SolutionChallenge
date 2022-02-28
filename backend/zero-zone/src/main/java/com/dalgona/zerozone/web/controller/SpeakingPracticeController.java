package com.dalgona.zerozone.web.controller;

import com.dalgona.zerozone.service.speakingAndReadingPractice.SpeakingPracticeService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RequiredArgsConstructor
@RestController
@RequestMapping("/speaking/practice")
public class SpeakingPracticeController {

    private final SpeakingPracticeService speakingPracticeService;

    // 글자 조회
    @GetMapping("/letter")
    public ResponseEntity<?> getLetter(@RequestParam Long id){
        return speakingPracticeService.getSpeakingPracticeLetterProb(id);
    }

    // 단어 조회
    @GetMapping("/word")
    public ResponseEntity<?> getWord(@RequestParam Long id){
        return speakingPracticeService.getSpeakingPracticeWordProb(id);
    }

    // 문장 조회
    @GetMapping("/sentence")
    public ResponseEntity<?> getSentence(@RequestParam Long id){
        return speakingPracticeService.getSpeakingPracticeSentenceProb(id);
    }

}
