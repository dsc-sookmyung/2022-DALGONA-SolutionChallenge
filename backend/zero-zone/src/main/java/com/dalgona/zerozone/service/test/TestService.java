package com.dalgona.zerozone.service.test;

import com.dalgona.zerozone.domain.bookmark.BookmarkReadingRepository;
import com.dalgona.zerozone.domain.reading.ReadingProbRepository;
import com.dalgona.zerozone.domain.test.Test;
import com.dalgona.zerozone.domain.test.TestProbs;
import com.dalgona.zerozone.domain.test.TestProbsRepository;
import com.dalgona.zerozone.domain.test.TestRepository;
import com.dalgona.zerozone.domain.user.User;
import com.dalgona.zerozone.domain.user.UserRepository;
import com.dalgona.zerozone.web.dto.Response;
import com.dalgona.zerozone.web.dto.test.*;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@RequiredArgsConstructor
@Service
public class TestService {

    private final TestRepository testRepository;
    private final TestProbsRepository testProbsRepository;
    private final UserRepository userRepository;
    private final ReadingProbRepository readingProbRepository;
    private final BookmarkReadingRepository bookmarkReadingRepository;
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
    @Transactional
    public ResponseEntity<?> getBookmarkTestSettingInfo(String email){
        // 반환 데이터 : 해당 유저의 총 테스트 개수, 북마크된 단어+문장의 개수
        Optional<User> user = userRepository.findByEmail(email);
        if(!user.isPresent()) return response.fail("존재하지 않는 회원입니다.", HttpStatus.BAD_REQUEST);
        int totalTestCount = user.get().getTests().size();
        int totalCount = bookmarkReadingRepository.findByUser(user.get()).get().getBookmarkReadingList().size();
        TestSettingInfoResponseDto responseDto = new TestSettingInfoResponseDto(totalTestCount, totalCount);
        return response.success(responseDto,"북마크 시험 설정 정보 조회에 성공했습니다.", HttpStatus.OK);
    }

    // 시험 채점
    @Transactional
    public ResponseEntity<?> updateTestResult(TestResultUpdateDto testResultUpdateDto){
        // 시험 조회
        Long testId = testResultUpdateDto.getTestId();
        Optional<Test> test = testRepository.findById(testId);
        if(!test.isPresent())
            return response.fail("존재하지 않는 시험입니다.", HttpStatus.BAD_REQUEST);
        // 맞은 개수 업데이트
        test.get().updateCorrectCount(testResultUpdateDto.getCorrectCount());
        // 문제별 채점 정보 업데이트
        List<TestProbs> testProbsList = test.get().getTestProbs();  // 등록된 시험의 문제 리스트
        List<TestResult> testResultList = testResultUpdateDto.getTestResultList();  // 채점 정보
        if(testResultList.size() != test.get().getTestProbs().size())
            return response.fail("채점 문제의 숫자가 등록된 시험 문제와 일치하지 않습니다.", HttpStatus.BAD_REQUEST);
        // 시험 문제 업데이트
        for(int i=0;i<testProbsList.size();i++){
            testProbsList.get(i).updateResult(testResultList.get(i));
        }
        // 시험에 등록된 문제 리스트 업데이트
        test.get().updateTestProbs(testProbsList);
        return response.success("채점 결과를 데이터베이스에 반영하였습니다.");
    }


    // 유저별로 시험 리스트 조회 : 페이징 처리
    @Transactional
    public ResponseEntity<?> getTestListByUser(String email, int page){
        // 요청 페이지 유효성 검사
        if(page<1)
            return response.fail("잘못된 페이지 요청입니다. 1 이상의 페이지를 조회해주세요.", HttpStatus.BAD_REQUEST);
        // 회원 조회
        Optional<User> user = userRepository.findByEmail(email);
        if(!user.isPresent()) return response.fail("존재하지 않는 회원입니다.", HttpStatus.BAD_REQUEST);
        // 회원의 시험 리스트 조회
        Pageable paging = PageRequest.of(page-1,10, Sort.by(Sort.Direction.DESC, "id"));
        Page<Test> testList = testRepository.findAllByUser(user.get(), paging);
        // dto로 변환
        Page<TestListByUserResponseDto> testListByUserResponseDtos
                = testList.map(TestListByUserResponseDto::of);

        return response.success(testListByUserResponseDtos, "회원의 시험 정보입니다.", HttpStatus.OK);
    }

    // 시험마다 문제 리스트 조회 : 페이징 처리
    @Transactional
    public ResponseEntity<?> getProbListByTest(Long testId, int page){
        // 요청 페이지 유효성 검사
        if(page<1)
            return response.fail("잘못된 페이지 요청입니다. 1 이상의 페이지를 조회해주세요.", HttpStatus.BAD_REQUEST);
        // 시험 조회
        Optional<Test> test = testRepository.findById(testId);
        if(!test.isPresent()) return response.fail("존재하지 않는 시험입니다.", HttpStatus.BAD_REQUEST);
        Pageable paging = PageRequest.of(page-1,10, Sort.by(Sort.Direction.DESC, "id"));
        Page<TestProbs> testProbList = testProbsRepository.findAllByTest(test.get(), paging);
        // dto로 변환
        Page<TestProbsByTestResponseDto> responseDtoPage
                = testProbList.map(TestProbsByTestResponseDto::of);

        return response.success(responseDtoPage, "시험 채점 결과입니다.", HttpStatus.OK);
    }

    // 문제 푼 결과 조회
    @Transactional
    public ResponseEntity<?> getProbResult(Long probId){
        Optional<TestProbs> testProb = testProbsRepository.findById(probId);
        if(!testProb.isPresent()) return response.fail("존재하지 않는 채점 결과입니다.", HttpStatus.BAD_REQUEST);
        TestProbs findTestProb = testProb.get();
        Test findTest = findTestProb.getTest();
        
        // 다음 문제의 id 조회
        Long nextProbId;
        int curIndex = findTestProb.getIdx();   // 1부터 시작
        // IoB 처리 : curIndex가 테스트 리스트의 사이즈 이상이라면
        if(curIndex >= findTest.getTestProbs().size())
            nextProbId = null;
        else
            nextProbId = findTest.getTestProbs().get(curIndex).getId();    // 그 다음 요소 조회
        
        TestProbResponseDto responseDto = new TestProbResponseDto(findTestProb, nextProbId);
        return response.success(responseDto, "해당 문제의 채점 결과입니다.", HttpStatus.OK);
    }

}
