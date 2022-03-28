package com.dalgona.zerozone.service.speakingAndReadingPractice;

import com.dalgona.zerozone.domain.bookmark.BookmarkReading;
import com.dalgona.zerozone.domain.bookmark.BookmarkReadingProb;
import com.dalgona.zerozone.domain.bookmark.BookmarkReadingProbRepository;
import com.dalgona.zerozone.domain.bookmark.BookmarkReadingRepository;
import com.dalgona.zerozone.domain.content.letter.Onset;
import com.dalgona.zerozone.domain.content.sentence.Sentence;
import com.dalgona.zerozone.domain.content.sentence.SentenceRepository;
import com.dalgona.zerozone.domain.content.sentence.Situation;
import com.dalgona.zerozone.domain.content.word.Word;
import com.dalgona.zerozone.domain.content.word.WordRepository;
import com.dalgona.zerozone.domain.reading.ReadingProb;
import com.dalgona.zerozone.domain.reading.ReadingProbRepository;
import com.dalgona.zerozone.domain.speaking.SpeakingProb;
import com.dalgona.zerozone.domain.user.User;
import com.dalgona.zerozone.domain.user.UserRepository;
import com.dalgona.zerozone.jwt.SecurityUtil;
import com.dalgona.zerozone.web.dto.Response;
import com.dalgona.zerozone.web.dto.content.SentenceRequestDto;
import com.dalgona.zerozone.web.dto.content.WordRequestDto;
import com.dalgona.zerozone.web.dto.readingPractice.SentenceReadingProbResponseProbDto;
import com.dalgona.zerozone.web.dto.readingPractice.WordReadingProbResponseProbDto;
import com.dalgona.zerozone.web.dto.speakingPractice.SentenceSpeakingProbResponseDto;
import com.dalgona.zerozone.web.dto.speakingPractice.WordSpeakingProbResponseProbDto;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@RequiredArgsConstructor
@Service
public class ReadingPracticeService {

    private final UserRepository userRepository;
    private final ReadingProbRepository readingProbRepository;
    private final WordRepository wordRepository;
    private final SentenceRepository sentenceRepository;
    private final BookmarkReadingRepository bookmarkReadingRepository;
    private final BookmarkReadingProbRepository bookmarkReadingProbRepository;
    private final Response response;
    Random random = new Random(System.currentTimeMillis());

    // 토큰으로부터 이메일 읽어오기
    private User getCurrentUser(){
        return SecurityUtil.getCurrentUsername().flatMap(userRepository::findByEmail).orElse(null);
    }

    // 단어 랜덤 조회
    @Transactional
    public ResponseEntity<?> getReadingPracticeRandomWordProb(WordRequestDto wordRequestDto){
        // 초성에 맞는 모든 단어 조회
        Onset onset = wordRequestDto.toEntity();
        List<Word> wordList = wordRepository.findAllByOnset(onset);
        // 등록된 단어가 하나도 없다면
        if(wordList.size()==0){
            return response.fail("초성에 맞는 단어가 없습니다", HttpStatus.BAD_REQUEST);
        }
        // 단어 리스트에서 랜덤으로 아이디 조회하여 구화 연습 테이블에 등록된 단어 찾기
        List<ReadingProb> readingProbList = new ArrayList<>();
        for(Word word : wordList) {
            Optional<ReadingProb> findProb = readingProbRepository.findByWord(word);
            if(!findProb.isPresent()) continue;
            readingProbList.add(findProb.get());
        }
        if(readingProbList.size()==0){
            return response.fail("단어가 문제로 등록되지 않았습니다.", HttpStatus.BAD_REQUEST);
        }
        // 랜덤으로 하나 뽑기
        Collections.shuffle(readingProbList);
        ReadingProb readingProb = readingProbList.get(0);

        // 북마크 여부 확인하기
        boolean isBookmarked = false;
        Optional<BookmarkReading> bookmark = bookmarkReadingRepository.findByUser(getCurrentUser());
        if(!bookmark.isPresent()) return response.fail("해당 회원의 북마크가 없습니다.", HttpStatus.BAD_REQUEST);
        List<BookmarkReadingProb> bookmarkReadingProbList = bookmarkReadingProbRepository.findAllByBookmarkReading(bookmark);
        for(BookmarkReadingProb bookmarkReadingProb:bookmarkReadingProbList){
            if(bookmarkReadingProb.getReadingProb().equals(readingProb)){
                isBookmarked = true;
                break;
            }
        }

        // 조회 성공
        WordReadingProbResponseProbDto wordResponseDto = new WordReadingProbResponseProbDto(readingProb, isBookmarked);
        return response.success(wordResponseDto, "랜덤 구화 단어 연습 조회에 성공했습니다.", HttpStatus.OK);
    }

    // 문장 랜덤 조회
    @Transactional
    public ResponseEntity<?> getReadingPracticeRandomSentenceProb(SentenceRequestDto sentenceRequestDto){
        // 상황에 맞는 모든 문장 조회
        Situation situation = sentenceRequestDto.toEntity();
        List<Sentence> sentenceList = sentenceRepository.findAllBySituation(situation);
        // 등록된 문장이 하나도 없다면
        if(sentenceList.size()==0){
            return response.fail("상황에 맞는 문장이 없습니다", HttpStatus.BAD_REQUEST);
        }
        // 문장 리스트에서 랜덤으로 아이디 조회하여 구화 연습 테이블에 등록된 문장 찾기
        List<ReadingProb> readingProbList = new ArrayList<>();
        for(Sentence sentence : sentenceList) {
            Optional<ReadingProb> findProb = readingProbRepository.findBySentence(sentence);
            if(!findProb.isPresent()) continue;
            readingProbList.add(findProb.get());
        }
        if(readingProbList.size()==0){
            return response.fail("구화 연습으로 등록된 문장이 없습니다", HttpStatus.BAD_REQUEST);
        }
        // 랜덤으로 하나 뽑기
        Collections.shuffle(readingProbList);
        ReadingProb readingProb = readingProbList.get(0);

        // 북마크 여부 확인하기
        boolean isBookmarked = false;
        Optional<BookmarkReading> bookmark = bookmarkReadingRepository.findByUser(getCurrentUser());
        if(!bookmark.isPresent()) return response.fail("해당 회원의 북마크가 없습니다.", HttpStatus.BAD_REQUEST);
        List<BookmarkReadingProb> bookmarkReadingProbList = bookmarkReadingProbRepository.findAllByBookmarkReading(bookmark);
        for(BookmarkReadingProb bookmarkReadingProb:bookmarkReadingProbList){
            if(bookmarkReadingProb.getReadingProb().equals(readingProb)){
                isBookmarked = true;
                break;
            }
        }

        // 조회 성공
        SentenceReadingProbResponseProbDto sentenceResponseDto = new SentenceReadingProbResponseProbDto(readingProb, isBookmarked);
        return response.success(sentenceResponseDto, "랜덤 구화 문장 연습 조회에 성공했습니다.", HttpStatus.OK);
    }
    
    // 단어 조회
    @Transactional
    public ResponseEntity<?> getReadingPracticeWordProb(Long id){
        Optional<Word> word = wordRepository.findById(id);
        if(!word.isPresent()) return response.fail("단어가 존재하지 않습니다.", HttpStatus.BAD_REQUEST);
        Optional<ReadingProb> readingProb = readingProbRepository.findByTypeAndWord("word", word.get());
        if(!readingProb.isPresent()) return response.fail("단어가 문제로 등록되지 않았습니다.", HttpStatus.BAD_REQUEST);

        // 북마크 여부 확인하기
        boolean isBookmarked = false;
        Optional<BookmarkReading> bookmark = bookmarkReadingRepository.findByUser(getCurrentUser());
        if(!bookmark.isPresent()) return response.fail("해당 회원의 북마크가 없습니다.", HttpStatus.BAD_REQUEST);
        List<BookmarkReadingProb> bookmarkReadingProbList = bookmarkReadingProbRepository.findAllByBookmarkReading(bookmark);
        for(BookmarkReadingProb bookmarkReadingProb:bookmarkReadingProbList){
            if(bookmarkReadingProb.getReadingProb().equals(readingProb.get())){
                isBookmarked = true;
                break;
            }
        }

        WordReadingProbResponseProbDto wordResponseDto = new WordReadingProbResponseProbDto(readingProb.get(), isBookmarked);
        return response.success(wordResponseDto, "구화 단어 연습 조회에 성공했습니다.", HttpStatus.OK);
    }
    
    // 문장 조회
    @Transactional
    public ResponseEntity<?> getReadingPracticeSentenceProb(Long id){
        Optional<Sentence> sentence = sentenceRepository.findById(id);
        if(!sentence.isPresent()) return response.fail("문장이 존재하지 않습니다.", HttpStatus.BAD_REQUEST);
        Optional<ReadingProb> readingProb = readingProbRepository.findByTypeAndSentence("sentence", sentence.get());
        if(!readingProb.isPresent()) return response.fail("문장이 문제로 등록되지 않았습니다.", HttpStatus.BAD_REQUEST);

        // 북마크 여부 확인하기
        boolean isBookmarked = false;
        Optional<BookmarkReading> bookmark = bookmarkReadingRepository.findByUser(getCurrentUser());
        if(!bookmark.isPresent()) return response.fail("해당 회원의 북마크가 없습니다.", HttpStatus.BAD_REQUEST);
        List<BookmarkReadingProb> bookmarkReadingProbList = bookmarkReadingProbRepository.findAllByBookmarkReading(bookmark);
        for(BookmarkReadingProb bookmarkReadingProb:bookmarkReadingProbList){
            if(bookmarkReadingProb.getReadingProb().equals(readingProb.get())){
                isBookmarked = true;
                break;
            }
        }

        SentenceReadingProbResponseProbDto sentenceReadingProbResponseDto = new SentenceReadingProbResponseProbDto(readingProb.get(), isBookmarked);
        return response.success(sentenceReadingProbResponseDto, "발음 문장 연습 조회에 성공했습니다.", HttpStatus.OK);
    }
    
}
