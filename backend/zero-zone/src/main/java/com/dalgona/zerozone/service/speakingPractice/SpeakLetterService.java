package com.dalgona.zerozone.service.speakingPractice;

import com.dalgona.zerozone.domain.letter.*;
import com.dalgona.zerozone.web.dto.Response;
import com.dalgona.zerozone.web.dto.speakingPractice.CodaRequestDto;
import com.dalgona.zerozone.web.dto.speakingPractice.CodasComparator;
import com.dalgona.zerozone.web.dto.speakingPractice.NucleusComparator;
import com.dalgona.zerozone.web.dto.speakingPractice.NucleusRequestDto;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

@RequiredArgsConstructor
@Service
public class SpeakLetterService {

    private final OnsetRepository onsetRepository;
    private final NucleusRepository nucleusRepository;
    private final CodaRepository codaRepository;
    private final LetterRepository letterRepository;
    private final Response response;

    // 초성 조회
    @Transactional
    public ResponseEntity<?> getOnset(){
        List<Onset> onsets = onsetRepository.findAll();
        // 첫번째 null은 제거
        onsets.remove(0);
        return response.success(onsets, "초성 조회에 성공했습니다.", HttpStatus.OK);
    }

    // 중성 조회 : 앞에 선택한 초성에 따라 달라짐
    @Transactional
    public ResponseEntity<?> getNucleus(NucleusRequestDto onsetData){
        // 글자 테이블에서 해당 초성을 가진 글자와 조인해서 가져오기
        List<Letter> letters = letterRepository.findAllByOnset(onsetData.toEntity());
        // 중성만 추출
        List<Nucleus> nucleusList = new ArrayList<>();
        for(Letter letter:letters){
            nucleusList.add(letter.getNucleus());
        }
        // 중복 제거
        //Set<Nucleus> set = new HashSet<Nucleus>(nucleusList);
        nucleusList = nucleusList.stream().distinct().collect(Collectors.toList());

        // 중성의 ID 오름차순으로 정렬
        Collections.sort(nucleusList, new NucleusComparator());

        return response.success(nucleusList, "중성 조회에 성공했습니다.", HttpStatus.OK);
    }

    // 종성 조회 : 앞에 선택한 초성과 중성에 따라 달라짐
    @Transactional
    public ResponseEntity<?> getCodas(CodaRequestDto onsetAndNucleusData) {
        // 글자 테이블에서 해당 초성과 중성을 가진 글자와 조인해서 가져오기
        List<Letter> letters = letterRepository.findAllByOnsetAndNucleus(
                onsetAndNucleusData.toEntityOnset(), onsetAndNucleusData.toEntityNucleus());
        // 종성만 추출
        List<Coda> codasList = new ArrayList<>();
        for(Letter letter:letters){
            codasList.add(letter.getCoda());
        }
        // 중복 제거
        codasList = codasList.stream().distinct().collect(Collectors.toList());
        // 종성의 ID 오름차순으로 정렬
        Collections.sort(codasList, new CodasComparator());

        return response.success(codasList, "종성 조회에 성공했습니다.", HttpStatus.OK);
    }

    // 연습용 글자 조회


}
