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

    // 글자 랜덤 조회
    @GetMapping("/letter/random")
    public ResponseEntity<?> getRandomLetter(){
        return speakingPracticeService.getRandomSpeakingPracticeLetterProb();
    }

    // 단어 랜덤 조회
    @GetMapping("/word/random")
    public ResponseEntity<?> getRandomWord(){
        return speakingPracticeService.getRandomSpeakingPracticeWordProb();
    }

    // 문장 랜덤 조회
    @GetMapping("/sentence/random")
    public ResponseEntity<?> getRandomSentence(){
        return speakingPracticeService.getRandomSpeakingPracticeSentenceProb();
    }

}
