package com.dalgona.zerozone.web;

import com.dalgona.zerozone.domain.customAnnotation.QueryStringArgResolver;
import com.dalgona.zerozone.service.speakingPractice.SpeakLetterService;
import com.dalgona.zerozone.web.dto.speakingPractice.CodaRequestDto;
import com.dalgona.zerozone.web.dto.speakingPractice.NucleusRequestDto;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RequiredArgsConstructor
@RestController
@RequestMapping("/speakingPractice/letter")
public class LetterController {

    private final SpeakLetterService speakLetterService;

    // 초성 조회
    @GetMapping("/onset")
    public ResponseEntity<?> getOnsets(){
        return speakLetterService.getOnset();
    }

    // 중성 조회
    @GetMapping("/nucleus")
    public ResponseEntity<?> getNucleuses(@QueryStringArgResolver NucleusRequestDto onsetData){
        return speakLetterService.getNucleus(onsetData);
    }
    
    // 종성 조회
    @GetMapping("/coda")
    public ResponseEntity<?> getCodas(@QueryStringArgResolver CodaRequestDto onsetAndNucleusData){
        return speakLetterService.getCodas(onsetAndNucleusData);
    }
    


}
