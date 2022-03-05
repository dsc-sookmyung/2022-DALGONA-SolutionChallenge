package com.dalgona.zerozone.service.speakingAndReadingPractice;

import com.dalgona.zerozone.domain.content.letter.Onset;
import com.dalgona.zerozone.domain.content.sentence.Sentence;
import com.dalgona.zerozone.domain.content.sentence.SentenceRepository;
import com.dalgona.zerozone.domain.content.sentence.Situation;
import com.dalgona.zerozone.domain.content.word.Word;
import com.dalgona.zerozone.domain.content.word.WordRepository;
import com.dalgona.zerozone.domain.reading.ReadingProb;
import com.dalgona.zerozone.domain.reading.ReadingProbRepository;
import com.dalgona.zerozone.web.dto.Response;
import com.dalgona.zerozone.web.dto.content.SentenceRequestDto;
import com.dalgona.zerozone.web.dto.content.WordRequestDto;
import com.dalgona.zerozone.web.dto.readingPractice.SentenceReadingProbResponseProbDto;
import com.dalgona.zerozone.web.dto.readingPractice.WordReadingProbResponseProbDto;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.Random;

@RequiredArgsConstructor
@Service
public class ReadingPracticeService {

    private final ReadingProbRepository readingProbRepository;
    private final WordRepository wordRepository;
    private final SentenceRepository sentenceRepository;
    private final Response response;
    Random random = new Random(System.currentTimeMillis());

    // 단어 랜덤 조회
    @Transactional
    public ResponseEntity<?> getReadingPracticeRandomWordProb(WordRequestDto wordRequestDto){
        // 초성에 맞는 모든 단어 조회
        Onset onset = wordRequestDto.toEntity();
        List<Word> wordList = wordRepository.findAllByOnset(onset);
        // 등록된 단어가 하나도 없다면
        if(wordList.size()==0){
            return response.fail("등록된 단어가 없습니다", HttpStatus.BAD_REQUEST);
        }
        // 단어 리스트에서 랜덤으로 아이디 조회하여 구화 연습 테이블에 등록된 단어 찾기
        // 무한 루프에 빠질 위험 : 만약 단어는 여러개 선택됬는데 하나도 등록이 안됬다면
        // 조회된 단어의 세배수만큼만 탐색하고 없다면 실패 반환
        Optional<ReadingProb> readingProb = null;
        for (int i = 3 * (wordList.size()); i>0; i--){
            // 랜덤으로 하나 선택 : 0을 포함하므로, 선택 범위는 0 이상 리스트의 길이 미만
            int index = random.nextInt(wordList.size());
            Word word = wordList.get(index);
            // 선택한 단어로 구화 연습 문제 조회
            readingProb = readingProbRepository.findByTypeAndWord("word", word);
            // 선택한 단어가 구화 연습 테이블에 존재하지 않는다면 다시 뽑기
            if (!readingProb.isPresent()) continue;
            break;
        }
        // 랜덤으로 조회하지 못했다면
        if (!readingProb.isPresent())
            return response.fail("구화 연습에 등록된 단어를 찾지 못했습니다.", HttpStatus.BAD_REQUEST);
        // 조회 성공
        WordReadingProbResponseProbDto wordResponseDto = new WordReadingProbResponseProbDto(readingProb.get());
        return response.success(wordResponseDto, "구화 단어 연습 조회에 성공했습니다.", HttpStatus.OK);
    }

    // 문장 랜덤 조회
    @Transactional
    public ResponseEntity<?> getReadingPracticeRandomSentenceProb(SentenceRequestDto sentenceRequestDto){
        // 상황에 맞는 모든 문장 조회
        Situation situation = sentenceRequestDto.toEntity();
        List<Sentence> sentenceList = sentenceRepository.findAllBySituation(situation);
        // 등록된 문장이 하나도 없다면
        if(sentenceList.size()==0){
            return response.fail("등록된 문장이 없습니다", HttpStatus.BAD_REQUEST);
        }
        // 문장 리스트에서 랜덤으로 아이디 조회하여 구화 연습 테이블에 등록된 문장 찾기
        // 무한 루프에 빠질 위험 : 만약 문장이 여러개 선택됬는데 하나도 등록이 안됬다면
        // 조회된 문장의 세배수만큼만 탐색하고 없다면 실패 반환
        Optional<ReadingProb> readingProb = null;
        for (int i = 3 * (sentenceList.size()); i>0; i--){
            // 랜덤으로 하나 선택 : 0을 포함하므로, 선택 범위는 0 이상 리스트의 길이 미만
            int index = random.nextInt(sentenceList.size());
            Sentence sentence = sentenceList.get(index);
            // 선택한 문장으로 구화 연습 문제 조회
            readingProb = readingProbRepository.findByTypeAndSentence("sentence", sentence);
            // 선택한 문장이 구화 연습 테이블에 존재하지 않는다면 다시 뽑기
            if (!readingProb.isPresent()) continue;
            break;
        }
        // 랜덤으로 조회하지 못했다면
        if (!readingProb.isPresent())
            return response.fail("구화 연습에 등록된 문장을 찾지 못했습니다.", HttpStatus.BAD_REQUEST);
        // 조회 성공
        SentenceReadingProbResponseProbDto sentenceResponseDto = new SentenceReadingProbResponseProbDto(readingProb.get());
        return response.success(sentenceResponseDto, "구화 문장 연습 조회에 성공했습니다.", HttpStatus.OK);
    }
    
}
