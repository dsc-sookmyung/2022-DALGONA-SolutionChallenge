package com.dalgona.zerozone.service.test;

import com.dalgona.zerozone.domain.content.sentence.SentenceRepository;
import com.dalgona.zerozone.domain.reading.ReadingProbRepository;
import com.dalgona.zerozone.domain.test.TestRepository;
import com.dalgona.zerozone.domain.user.User;
import com.dalgona.zerozone.domain.user.UserRepository;
import com.dalgona.zerozone.web.dto.Response;
import com.dalgona.zerozone.web.dto.test.TestCreateRequestDto;
import com.dalgona.zerozone.web.dto.test.TestSettingInfoResponseDto;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@RequiredArgsConstructor
@Service
public class TestService {

    private final TestRepository testRepository;
    private final UserRepository userRepository;
    private final ReadingProbRepository readingProbRepository;
    private final SentenceRepository sentenceRepository;
    private final Response response;

    // 단어 시험 정보 조회
    @Transactional
    public ResponseEntity<?> getWordTestSettingInfo(String email){
        // 반환 데이터 : 해당 유저의 총 테스트 개수, 연습 가능한 단어의 개수
        Optional<User> user = userRepository.findByEmail(email);
        if(!user.isPresent()) return response.fail("존재하지 않는 회원입니다.", HttpStatus.BAD_REQUEST);
        int totalTestCount = user.get().getTests().size();
        int wordCount = readingProbRepository.findAllByType("word").size();
        TestSettingInfoResponseDto responseDto = new TestSettingInfoResponseDto(totalTestCount, wordCount);
        return response.success(responseDto,"단어 시험 설정 정보 조회에 성공했습니다.", HttpStatus.OK);
    }
    
    // 문장 시험 정보 조회
    @Transactional
    public ResponseEntity<?> getSentenceTestSettingInfo(String email){
        // 반환 데이터 : 해당 유저의 총 테스트 개수, 연습 가능한 문장의 개수
        Optional<User> user = userRepository.findByEmail(email);
        if(!user.isPresent()) return response.fail("존재하지 않는 회원입니다.", HttpStatus.BAD_REQUEST);
        int totalTestCount = user.get().getTests().size();
        int sentenceCount = readingProbRepository.findAllByType("sentence").size();
        TestSettingInfoResponseDto responseDto = new TestSettingInfoResponseDto(totalTestCount, sentenceCount);
        return response.success(responseDto,"문장 시험 설정 정보 조회에 성공했습니다.", HttpStatus.OK);
    }

    // 단어_문장 시험 정보 조회
    @Transactional
    public ResponseEntity<?> getRandomTestSettingInfo(String email){
        // 반환 데이터 : 해당 유저의 총 테스트 개수, 연습 가능한 단어+문장의 개수
        Optional<User> user = userRepository.findByEmail(email);
        if(!user.isPresent()) return response.fail("존재하지 않는 회원입니다.", HttpStatus.BAD_REQUEST);
        int totalTestCount = user.get().getTests().size();
        int wordCount = readingProbRepository.findAllByType("word").size();
        int sentenceCount = readingProbRepository.findAllByType("sentence").size();
        TestSettingInfoResponseDto responseDto = new TestSettingInfoResponseDto(totalTestCount, wordCount+sentenceCount);
        return response.success(responseDto,"랜덤 시험 설정 정보 조회에 성공했습니다.", HttpStatus.OK);
    }

    // 북마크 시험 정보 조회

    // 단어 시험 생성





}
