package com.dalgona.zerozone.web.controller;

import com.dalgona.zerozone.domain.customAnnotation.QueryStringArgResolver;
import com.dalgona.zerozone.service.speakingAndReadingPractice.listService;
import com.dalgona.zerozone.web.dto.content.CodaRequestDto;
import com.dalgona.zerozone.web.dto.content.NucleusRequestDto;
import com.dalgona.zerozone.web.dto.content.SentenceRequestDto;
import com.dalgona.zerozone.web.dto.content.WordRequestDto;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;

@RequiredArgsConstructor
@RestController
@RequestMapping("/speaking/list")
public class SpeakingListController {

    private final listService speakingService;

    // 초성 조회
    @GetMapping("/letter/onset")
    public ResponseEntity<?> getOnsets(){
        return speakingService.getOnset();
    }

    // 중성 조회
    @GetMapping("/letter/nucleus")
    public ResponseEntity<?> getNucleuses(@QueryStringArgResolver NucleusRequestDto onsetData){
        return speakingService.getNucleus(onsetData);
    }
    
    // 종성 조회
    @GetMapping("/letter/coda")
    public ResponseEntity<?> getCodas(@QueryStringArgResolver CodaRequestDto onsetAndNucleusData){
        return speakingService.getCodas(onsetAndNucleusData);
    }

    // 단어 조회
    @GetMapping("/word")
    public ResponseEntity<?> getWords(@QueryStringArgResolver WordRequestDto onsetData){
        return speakingService.getWords(onsetData);
    }

    // 상황 조회
    @GetMapping("/situation")
    public ResponseEntity<?> getSituations(){
        return speakingService.getSituations();
    }

    // 문장 조회
    @GetMapping("/situation/sentence")
    public ResponseEntity<?> getSituations(@QueryStringArgResolver SentenceRequestDto sentenceRequestDto){
        return speakingService.getSentences(sentenceRequestDto);
    }

}
