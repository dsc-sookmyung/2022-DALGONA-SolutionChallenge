package com.dalgona.zerozone.service.speakingAndReadingPractice;

import com.dalgona.zerozone.domain.content.letter.Letter;
import com.dalgona.zerozone.domain.content.letter.LetterRepository;
import com.dalgona.zerozone.domain.content.sentence.Sentence;
import com.dalgona.zerozone.domain.content.sentence.SentenceRepository;
import com.dalgona.zerozone.domain.content.word.Word;
import com.dalgona.zerozone.domain.content.word.WordRepository;
import com.dalgona.zerozone.domain.speaking.SpeakingProb;
import com.dalgona.zerozone.domain.speaking.SpeakingProbRepository;
import com.dalgona.zerozone.web.dto.Response;
import com.dalgona.zerozone.web.dto.content.LetterResponseDto;
import com.dalgona.zerozone.web.dto.content.SentenceResponseDto;
import com.dalgona.zerozone.web.dto.content.WordResponseDto;
import com.dalgona.zerozone.web.dto.speakingPractice.LetterSpeakingProbResponseDto;
import com.dalgona.zerozone.web.dto.speakingPractice.SentenceSpeakingProbResponseDto;
import com.dalgona.zerozone.web.dto.speakingPractice.WordSpeakingProbResponseProbDto;
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
public class SpeakingPracticeService {

    private final SpeakingProbRepository speakingProbRepository;
    private final LetterRepository letterRepository;
    private final WordRepository wordRepository;
    private final SentenceRepository sentenceRepository;
    private final Response response;

    // 글자 조회
    @Transactional
    public ResponseEntity<?> getSpeakingPracticeLetterProb(Long id){
        Optional<Letter> letter = letterRepository.findById(id);
        if(!letter.isPresent()) return response.fail("글자가 존재하지 않습니다.", HttpStatus.BAD_REQUEST);
        Optional<SpeakingProb> speakingProb = speakingProbRepository.findByTypeAndLetter("letter", letter.get());
        if(!speakingProb.isPresent()) return response.fail("글자가 문제로 등록되지 않았습니다.", HttpStatus.BAD_REQUEST);
        LetterSpeakingProbResponseDto letterResponseDto = new LetterSpeakingProbResponseDto(speakingProb.get());
        return response.success(letterResponseDto, "발음 글자 연습 조회에 성공했습니다.", HttpStatus.OK);
    }
    
    
    // 단어 조회
    @Transactional
    public ResponseEntity<?> getSpeakingPracticeWordProb(Long id){
        Optional<Word> word = wordRepository.findById(id);
        if(!word.isPresent()) return response.fail("단어가 존재하지 않습니다.", HttpStatus.BAD_REQUEST);
        Optional<SpeakingProb> speakingProb = speakingProbRepository.findByTypeAndWord("word", word.get());
        if(!speakingProb.isPresent()) return response.fail("단어가 문제로 등록되지 않았습니다.", HttpStatus.BAD_REQUEST);
        WordSpeakingProbResponseProbDto wordResponseDto = new WordSpeakingProbResponseProbDto(speakingProb.get());
        return response.success(wordResponseDto, "발음 단어 연습 조회에 성공했습니다.", HttpStatus.OK);
    }

    // 문장 조회
    @Transactional
    public ResponseEntity<?> getSpeakingPracticeSentenceProb(Long id){
        Optional<Sentence> sentence = sentenceRepository.findById(id);
        if(!sentence.isPresent()) return response.fail("문장이 존재하지 않습니다.", HttpStatus.BAD_REQUEST);
        Optional<SpeakingProb> speakingProb = speakingProbRepository.findByTypeAndSentence("sentence", sentence.get());
        if(!speakingProb.isPresent()) return response.fail("문장이 문제로 등록되지 않았습니다.", HttpStatus.BAD_REQUEST);
        SentenceSpeakingProbResponseDto sentenceSpeakingProbResponseDto = new SentenceSpeakingProbResponseDto(speakingProb.get());
        return response.success(sentenceSpeakingProbResponseDto, "발음 문장 연습 조회에 성공했습니다.", HttpStatus.OK);
    }

    // 글자 랜덤 조회
    public ResponseEntity<?> getRandomSpeakingPracticeLetterProb() {
        List<Letter> letters = letterRepository.findAll();
        int len = letters.size();
        if(len==0) return response.fail("글자가 존재하지 않습니다.", HttpStatus.BAD_REQUEST);
        Random random = new Random();
        Letter randomLetter = letters.get(random.nextInt(len));
        Optional<SpeakingProb> letter = speakingProbRepository.findByTypeAndLetter("letter", randomLetter);
        if(!letter.isPresent()) return response.fail("글자가 문제로 등록되지 않았습니다.", HttpStatus.BAD_REQUEST);
        LetterSpeakingProbResponseDto letterResponseDto = new LetterSpeakingProbResponseDto(letter.get());
        return response.success(letterResponseDto, "글자 랜덤 조회에 성공했습니다.", HttpStatus.OK);
    }

    // 단어 랜덤 조회
    public ResponseEntity<?> getRandomSpeakingPracticeWordProb() {
        List<Word> words = wordRepository.findAll();
        int len = words.size();
        if(len==0) return response.fail("단어가 존재하지 않습니다.", HttpStatus.BAD_REQUEST);
        Random random = new Random();
        Word randomWord = words.get(random.nextInt(len));
        Optional<SpeakingProb> word = speakingProbRepository.findByTypeAndWord("word", randomWord);
        if(!word.isPresent()) response.fail("단어가 문제로 등록되지 않았습니다.", HttpStatus.BAD_REQUEST);
        WordSpeakingProbResponseProbDto wordResponseDto = new WordSpeakingProbResponseProbDto(word.get());
        return response.success(wordResponseDto, "단어 랜덤 조회에 성공했습니다.", HttpStatus.OK);
    }

    // 문장 랜덤 조회
    public ResponseEntity<?> getRandomSpeakingPracticeSentenceProb() {
        List<Sentence> sentences = sentenceRepository.findAll();
        int len = sentences.size();
        if(len==0) return response.fail("문장이 존재하지 않습니다.", HttpStatus.BAD_REQUEST);
        Random random = new Random();
        Sentence randomSentence = sentences.get(random.nextInt(len));
        Optional<SpeakingProb> sentence = speakingProbRepository.findByTypeAndSentence("sentence", randomSentence);
        if(!sentence.isPresent()) response.fail("문장이 문제로 등록되지 않았습니다.", HttpStatus.BAD_REQUEST);
        SentenceSpeakingProbResponseDto sentenceResponseDto = new SentenceSpeakingProbResponseDto(sentence.get());
        return response.success(sentenceResponseDto, "문장 랜덤 조회에 성공했습니다.", HttpStatus.OK);
    }
}
