package com.dalgona.zerozone.service.speakingPractice;

import com.dalgona.zerozone.domain.content.letter.*;
import com.dalgona.zerozone.domain.content.sentence.Sentence;
import com.dalgona.zerozone.domain.content.sentence.SentenceRepository;
import com.dalgona.zerozone.domain.content.sentence.Situation;
import com.dalgona.zerozone.domain.content.sentence.SituationRepository;
import com.dalgona.zerozone.domain.content.word.Word;
import com.dalgona.zerozone.domain.content.word.WordRepository;
import com.dalgona.zerozone.web.dto.Response;
import com.dalgona.zerozone.web.dto.comparator.*;
import com.dalgona.zerozone.web.dto.speakingPractice.*;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

@RequiredArgsConstructor
@Service
public class SpeakingListService {

    private final OnsetRepository onsetRepository;
    private final LetterRepository letterRepository;
    private final WordRepository wordRepository;
    private final SituationRepository situationRepository;
    private final SentenceRepository sentenceRepository;
    private final Response response;

    // 초성 조회
    @Transactional
    public ResponseEntity<?> getOnset(){
        List<Onset> onsetList = onsetRepository.findAll();
        // 첫번째 null은 제거
        onsetList.remove(0);
        // 초성의 ID 오름차순으로 정렬
        Collections.sort(onsetList, new ContentComparator());
        return response.success(onsetList, "초성 조회에 성공했습니다.", HttpStatus.OK);
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
        nucleusList = nucleusList.stream().distinct().collect(Collectors.toList());
        // 중성의 ID 오름차순으로 정렬
        Collections.sort(nucleusList, new ContentComparator());
        return response.success(nucleusList, "중성 조회에 성공했습니다.", HttpStatus.OK);
    }

    // 종성 조회 : 앞에 선택한 초성과 중성에 따라 달라짐
    @Transactional
    public ResponseEntity<?> getCodas(CodaRequestDto onsetAndNucleusData) {
        // 글자 테이블에서 해당 초성과 중성을 가진 글자와 조인해서 가져오기
        List<Letter> letters = letterRepository.findAllByOnsetAndNucleus(
                onsetAndNucleusData.toEntityOnset(), onsetAndNucleusData.toEntityNucleus());
        // 종성만 추출하여 ID 오름차순으로 정렬
        List<Coda> codaList = new ArrayList<>();
        for(Letter letter:letters){
            codaList.add(letter.getCoda());
        }
        Collections.sort(codaList, new ContentComparator());
        return response.success(codaList, "종성 조회에 성공했습니다.", HttpStatus.OK);
    }

    // 단어 조회 : 초성에 따라 달라짐
    @Transactional
    public ResponseEntity<?> getWords(WordRequestDto onsetData){
        // 단어 테이블에서 해당 초성으로 시작하는 모든 단어 가져오기
        List<Word> wordList = wordRepository.findAllByOnset(onsetData.toEntity());
        // 단어의 ID 오름차순으로 정렬
        Collections.sort(wordList, new ContentComparator());
        return response.success(wordList, "단어 조회에 성공했습니다.", HttpStatus.OK);
    }

    // 상황 조회
    public ResponseEntity<?> getSituations() {
        List<Situation> situationList = situationRepository.findAll();
        // 첫번째 null은 제거
        situationList.remove(0);
        // 상황의 ID 오름차순으로 정렬
        Collections.sort(situationList, new ContentComparator());
        return response.success(situationList, "상황 조회에 성공했습니다.", HttpStatus.OK);
    }
    
    // 문장 조회 : 상황에 따라 달라짐
    public ResponseEntity getSentences(SentenceRequestDto sentenceRequestDto){
        List<Sentence> sentenceList = sentenceRepository.findAllBySituation(sentenceRequestDto.toEntity());
        // 문장의 ID 오름차순으로 정렬
        Collections.sort(sentenceList, new ContentComparator());
        return response.success(sentenceList, "문장 조회에 성공했습니다.", HttpStatus.OK);
    }


}
