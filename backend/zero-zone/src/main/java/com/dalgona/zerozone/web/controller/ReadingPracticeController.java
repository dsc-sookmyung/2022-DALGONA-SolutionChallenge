package com.dalgona.zerozone.web.controller;

import com.dalgona.zerozone.domain.customAnnotation.QueryStringArgResolver;
import com.dalgona.zerozone.service.speakingAndReadingPractice.ReadingPracticeService;
import com.dalgona.zerozone.web.dto.content.SentenceRequestDto;
import com.dalgona.zerozone.web.dto.content.WordRequestDto;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RequiredArgsConstructor
@RestController
@RequestMapping("/reading/practice")
public class ReadingPracticeController {

    private final ReadingPracticeService readingPracticeService;

    // 랜덤 단어 조회
    // 매개변수 : 초성 정보
    @GetMapping("/word/random")
    public ResponseEntity<?> getRandomWord(@QueryStringArgResolver WordRequestDto wordRequestDto){
        return readingPracticeService.getReadingPracticeRandomWordProb(wordRequestDto);
    }

    // 랜덤 문장 조회
    // 매개변수 : 상황 정보
    @GetMapping("/sentence/random")
    public ResponseEntity<?> getRandomSentence(@QueryStringArgResolver SentenceRequestDto sentenceRequestDto){
        return readingPracticeService.getReadingPracticeRandomSentenceProb(sentenceRequestDto);
    }

    // 단어 조회
    @GetMapping("/word")
    public ResponseEntity<?> getWord(@RequestParam Long id){
        return readingPracticeService.getReadingPracticeWordProb(id);
    }

    // 문장 조회
    @GetMapping("/sentence")
    public ResponseEntity<?> getSentence(@RequestParam Long id){
        return readingPracticeService.getReadingPracticeSentenceProb(id);
    }
}
