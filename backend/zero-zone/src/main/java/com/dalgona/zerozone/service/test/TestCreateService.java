package com.dalgona.zerozone.service.test;

import com.dalgona.zerozone.domain.bookmark.BookmarkReading;
import com.dalgona.zerozone.domain.bookmark.BookmarkReadingProb;
import com.dalgona.zerozone.domain.bookmark.BookmarkReadingRepository;
import com.dalgona.zerozone.domain.reading.ReadingProb;
import com.dalgona.zerozone.domain.reading.ReadingProbRepository;
import com.dalgona.zerozone.domain.test.Test;
import com.dalgona.zerozone.domain.test.TestProbs;
import com.dalgona.zerozone.domain.test.TestProbsRepository;
import com.dalgona.zerozone.domain.test.TestRepository;
import com.dalgona.zerozone.domain.user.User;
import com.dalgona.zerozone.domain.user.UserRepository;
import com.dalgona.zerozone.jwt.SecurityUtil;
import com.dalgona.zerozone.web.dto.Response;
import com.dalgona.zerozone.web.dto.readingPractice.ReadingProbResponseDto;
import com.dalgona.zerozone.web.dto.test.TestCreateRequestDto;
import com.dalgona.zerozone.web.dto.test.TestCreateResponseDto;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@RequiredArgsConstructor
@Service
public class TestCreateService {

    private final TestRepository testRepository;
    private final TestProbsRepository testProbsRepository;
    private final UserRepository userRepository;
    private final ReadingProbRepository readingProbRepository;
    private final BookmarkReadingRepository bookmarkReadingRepository;
    private final Response response;

    // 토큰으로부터 이메일 읽어오기
    private User getCurrentUser(){
        return SecurityUtil.getCurrentUsername().flatMap(userRepository::findByEmail).orElse(null);
    }

    // 단어 시험 생성
    // 필요한 정보 : 유저, 테스트이름, 문제개수
    @Transactional
    public ResponseEntity<?> createWordTest(TestCreateRequestDto testCreateRequestDto){
        List<ReadingProb> readingProbList = readingProbRepository.findAllByType("word");
        String testName = testCreateRequestDto.getTestName();
        int probsCount = testCreateRequestDto.getProbsCount();

        // 문제 개수 유효성 검사
        if(probsCount < 1)
            return response.fail("요청 문제 개수는 1개 이상이어야 합니다.", HttpStatus.BAD_REQUEST);
        if(readingProbList.size() < probsCount)
            return response.fail("요청한 문제 개수가 연습에 등록된 문제 개수보다 많습니다.", HttpStatus.BAD_REQUEST);

        // 유저 조회
        User user = getCurrentUser();

        // 시험 데이터 생성
        Test test = new Test(testName, probsCount, 0, user);
        Test newTest = testRepository.save(test);

        // 구화 단어 연습 문제 가져와서 특정 개수만큼 랜덤으로 추출
        Collections.shuffle(readingProbList);
        List<ReadingProb> newReadingProbList = new ArrayList<>();
        for(int i=0;i<probsCount;i++){
            newReadingProbList.add(readingProbList.get(i));
        }

        // 현재 회원의 북마크 리스트 가져오기
        User currentUser = getCurrentUser();
        Optional<BookmarkReading> bookmarkReadingByUser = bookmarkReadingRepository.findByUser(currentUser);
        if(!bookmarkReadingByUser.isPresent()) return response.fail("회원의 북마크가 존재하지 않습니다.", HttpStatus.BAD_REQUEST);
        List<BookmarkReadingProb> bookmarkReadingProbList = bookmarkReadingByUser.get().getBookmarkReadingList();

        // 하나씩 저장
        List<TestProbs> newTestProbsList = newTest.getTestProbs();
        List<ReadingProbResponseDto> readingProbResponseDtoList = new ArrayList<>();
        for(int i=0;i<newReadingProbList.size();i++){
            boolean isBookmarked = false;   // 북마크 여부 표시용
            TestProbs newTestProb = new TestProbs(i+1, false, false, newTest, newReadingProbList.get(i));
            testProbsRepository.save(newTestProb);  // 시험 문제로 등록
            newTestProbsList.add(newTestProb);      // 시험의 소속 문제 리스트에 추가
            // 북마크 여부 조회하기
            for(BookmarkReadingProb bookmarkReadingProb:bookmarkReadingProbList){
                if(bookmarkReadingProb.getReadingProb().equals(newReadingProbList.get(i))){
                    isBookmarked = true;
                    break;
                }
            }
            // 반환 데이터 리스트는 Dto로 변경
            readingProbResponseDtoList.add(new ReadingProbResponseDto(newReadingProbList.get(i), isBookmarked));
        }

        // 시험 Dto로 변경
        TestCreateResponseDto testCreateResponseDto = new TestCreateResponseDto(newTest.getId(), newTest.getTestName(), readingProbResponseDtoList);
        // 생성된 시험 정보와 시험 문항 리스트 반환
        return response.success(testCreateResponseDto, "단어 시험 생성에 성공했습니다.", HttpStatus.OK);
    }

    // 문장 시험 생성
    @Transactional
    public ResponseEntity<?> createSentenceTest(TestCreateRequestDto testCreateRequestDto){
        List<ReadingProb> readingProbList = readingProbRepository.findAllByType("sentence");
        String testName = testCreateRequestDto.getTestName();
        int probsCount = testCreateRequestDto.getProbsCount();

        // 문제 개수 유효성 검사
        if(probsCount < 1)
            return response.fail("요청 문제 개수는 1개 이상이어야 합니다.", HttpStatus.BAD_REQUEST);
        if(readingProbList.size() < probsCount)
            return response.fail("요청한 문제 개수가 연습에 등록된 문제 개수보다 많습니다.", HttpStatus.BAD_REQUEST);

        // 유저 조회
        User user = getCurrentUser();

        // 시험 데이터 생성
        Test test = new Test(testName, probsCount, 0, user);
        Test newTest = testRepository.save(test);

        // 구화 단어 연습 문제 가져와서 특정 개수만큼 랜덤으로 추출
        Collections.shuffle(readingProbList);
        List<ReadingProb> newReadingProbList = new ArrayList<>();
        for(int i=0;i<probsCount;i++){
            newReadingProbList.add(readingProbList.get(i));
        }

        // 현재 회원의 북마크 리스트 가져오기
        User currentUser = getCurrentUser();
        Optional<BookmarkReading> bookmarkReadingByUser = bookmarkReadingRepository.findByUser(currentUser);
        if(!bookmarkReadingByUser.isPresent()) return response.fail("회원의 북마크가 존재하지 않습니다.", HttpStatus.BAD_REQUEST);
        List<BookmarkReadingProb> bookmarkReadingProbList = bookmarkReadingByUser.get().getBookmarkReadingList();

        // 하나씩 저장
        List<TestProbs> newTestProbsList = newTest.getTestProbs();
        List<ReadingProbResponseDto> readingProbResponseDtoList = new ArrayList<>();
        for(int i=0;i<newReadingProbList.size();i++){
            boolean isBookmarked = false;   // 북마크 여부 표시용
            TestProbs newTestProb = new TestProbs(i+1, false, false, newTest, newReadingProbList.get(i));
            testProbsRepository.save(newTestProb);  // 시험 문제로 등록
            newTestProbsList.add(newTestProb);      // 시험의 소속 문제 리스트에 추가
            // 북마크 여부 조회하기
            for(BookmarkReadingProb bookmarkReadingProb:bookmarkReadingProbList){
                if(bookmarkReadingProb.getReadingProb().equals(newReadingProbList.get(i))){
                    isBookmarked = true;
                    break;
                }
            }
            // 반환 데이터 리스트는 Dto로 변경
            readingProbResponseDtoList.add(new ReadingProbResponseDto(newReadingProbList.get(i), isBookmarked));
        }

        // 시험 Dto로 변경
        TestCreateResponseDto testCreateResponseDto = new TestCreateResponseDto(newTest.getId(), newTest.getTestName(), readingProbResponseDtoList);
        // 생성된 시험 정보와 시험 문항 리스트 반환
        return response.success(testCreateResponseDto, "문장 시험 생성에 성공했습니다.", HttpStatus.OK);
    }

    // 단어+문장 시험 생성
    @Transactional
    public ResponseEntity<?> createWordAndSentenceTest(TestCreateRequestDto testCreateRequestDto){
        List<ReadingProb> readingWordProbList =
                readingProbRepository.findAllByType("word");
        List<ReadingProb> readingSentenceProbList =
                readingProbRepository.findAllByType("sentence");

        String testName = testCreateRequestDto.getTestName();
        int probsCount = testCreateRequestDto.getProbsCount();
        int wordsCount = readingWordProbList.size();
        int sentencesCount = readingSentenceProbList.size();
        int totalCount = wordsCount+sentencesCount;

        // 문제 개수 유효성 검사
        if(probsCount < 1)
            return response.fail("요청 문제 개수는 1개 이상이어야 합니다.", HttpStatus.BAD_REQUEST);
        if(totalCount < probsCount)
            return response.fail("요청한 문제 개수가 연습에 등록된 문제 개수보다 많습니다.", HttpStatus.BAD_REQUEST);

        // 유저 조회
        User user = getCurrentUser();

        // 시험 데이터 생성
        Test test = new Test(testName, probsCount, 0, user);
        Test newTest = testRepository.save(test);

        // 구화 연습 문제 가져와서 특정 개수만큼 랜덤으로 추출
        Collections.shuffle(readingWordProbList);
        Collections.shuffle(readingSentenceProbList);
        List<ReadingProb> newReadingProbList = new ArrayList<>();

        // 단어와 문장의 숫자가 최대한 비슷하게 추출
        int halfCount = probsCount/2;
        // 단어가 요구 문제 개수의 절반보다 적은 경우
        if(halfCount>=wordsCount){
            // 단어 전부 추출
            for(ReadingProb word:readingWordProbList){
                newReadingProbList.add(word);
            }
            // 남은 만큼 문장 추출
            for(int i=0; i<probsCount-wordsCount;i++){
                newReadingProbList.add(readingSentenceProbList.get(i));
            }
        }
        // 문장이 요구 문제 개수의 절반보다 적은 경우
        else if(halfCount>=sentencesCount){
            // 문장 전부 추출
            for(ReadingProb sentence:readingSentenceProbList){
                newReadingProbList.add(sentence);
            }
            // 남은 만큼 단어 추출
            for(int i=0; i<probsCount-sentencesCount;i++){
                newReadingProbList.add(readingWordProbList.get(i));
            }
        }
        // 둘다 요구 문제 개수의 절반보다 많은 경우
        else{
            // 단어 절반 추출
            for(int i=0;i<halfCount;i++){
                newReadingProbList.add(readingWordProbList.get(i));
            }
            // 문장 절반 추출
            for(int i=0;i<probsCount-halfCount;i++){
                newReadingProbList.add(readingSentenceProbList.get(i));
            }
        }
        // 한번 더 섞음
        Collections.shuffle(newReadingProbList);
        Collections.shuffle(newReadingProbList);

        // 현재 회원의 북마크 리스트 가져오기
        User currentUser = getCurrentUser();
        Optional<BookmarkReading> bookmarkReadingByUser = bookmarkReadingRepository.findByUser(currentUser);
        if(!bookmarkReadingByUser.isPresent()) return response.fail("회원의 북마크가 존재하지 않습니다.", HttpStatus.BAD_REQUEST);
        List<BookmarkReadingProb> bookmarkReadingProbList = bookmarkReadingByUser.get().getBookmarkReadingList();

        // 하나씩 저장
        List<TestProbs> newTestProbsList = newTest.getTestProbs();
        List<ReadingProbResponseDto> readingProbResponseDtoList = new ArrayList<>();
        for(int i=0;i<newReadingProbList.size();i++){
            boolean isBookmarked = false;   // 북마크 여부 표시용
            TestProbs newTestProb = new TestProbs(i+1, false, false, newTest, newReadingProbList.get(i));
            testProbsRepository.save(newTestProb);  // 시험 문제로 등록
            newTestProbsList.add(newTestProb);      // 시험의 소속 문제 리스트에 추가
            // 북마크 여부 조회하기
            for(BookmarkReadingProb bookmarkReadingProb:bookmarkReadingProbList){
                if(bookmarkReadingProb.getReadingProb().equals(newReadingProbList.get(i))){
                    isBookmarked = true;
                    break;
                }
            }
            // 반환 데이터 리스트는 Dto로 변경
            readingProbResponseDtoList.add(new ReadingProbResponseDto(newReadingProbList.get(i),isBookmarked));
        }

        // 시험 Dto로 변경
        TestCreateResponseDto testCreateResponseDto = new TestCreateResponseDto(newTest.getId(), newTest.getTestName(), readingProbResponseDtoList);
        // 생성된 시험 정보와 시험 문항 리스트 반환
        return response.success(testCreateResponseDto, "문장 시험 생성에 성공했습니다.", HttpStatus.OK);
    }

    // 북마크 시험 생성
    @Transactional
    public ResponseEntity<?> createBookmarkTest(TestCreateRequestDto testCreateRequestDto){
        String testName = testCreateRequestDto.getTestName();
        int probsCount = testCreateRequestDto.getProbsCount();

        // 유저 조회
        User user = getCurrentUser();
        Optional<BookmarkReading> bookmarkReading = bookmarkReadingRepository.findByUser(user);
        if(!bookmarkReading.isPresent())
            return response.fail("해당 회원의 북마크가 존재하지 않습니다.", HttpStatus.BAD_REQUEST);

        // 북마크된 문제 조회
        List<BookmarkReadingProb> bookmarkReadingList = bookmarkReading.get().getBookmarkReadingList();
        // 문제 개수 유효성 검사
        if(probsCount < 1)
            return response.fail("요청 문제 개수는 1개 이상이어야 합니다.", HttpStatus.BAD_REQUEST);
        if(bookmarkReadingList.size() < probsCount)
            return response.fail("요청한 문제 개수가 북마크에 등록된 문제 개수보다 많습니다.", HttpStatus.BAD_REQUEST);

        // ReadingProb 추출
        List<ReadingProb> readingProbList = new ArrayList<>();
        for(BookmarkReadingProb bookmarkReadingProb:bookmarkReadingList){
            readingProbList.add(bookmarkReadingProb.getReadingProb());
        }

        // 시험 데이터 생성
        Test test = new Test(testName, probsCount, 0, user);
        Test newTest = testRepository.save(test);

        // 구화 단어 연습 문제 가져와서 특정 개수만큼 랜덤으로 추출
        Collections.shuffle(readingProbList);
        List<ReadingProb> newReadingProbList = new ArrayList<>();
        for(int i=0;i<probsCount;i++){
            newReadingProbList.add(readingProbList.get(i));
        }

        // 현재 회원의 북마크 리스트 가져오기
        User currentUser = getCurrentUser();
        Optional<BookmarkReading> bookmarkReadingByUser = bookmarkReadingRepository.findByUser(currentUser);
        if(!bookmarkReadingByUser.isPresent()) return response.fail("회원의 북마크가 존재하지 않습니다.", HttpStatus.BAD_REQUEST);
        List<BookmarkReadingProb> bookmarkReadingProbList = bookmarkReadingByUser.get().getBookmarkReadingList();

        // 하나씩 저장
        List<TestProbs> newTestProbsList = newTest.getTestProbs();
        List<ReadingProbResponseDto> readingProbResponseDtoList = new ArrayList<>();
        for(int i=0;i<newReadingProbList.size();i++){
            boolean isBookmarked = false;   // 북마크 여부 표시용
            TestProbs newTestProb = new TestProbs(i+1, false, false, newTest, newReadingProbList.get(i));
            testProbsRepository.save(newTestProb);  // 시험 문제로 등록
            newTestProbsList.add(newTestProb);      // 시험의 소속 문제 리스트에 추가
            // 북마크 여부 조회하기
            for(BookmarkReadingProb bookmarkReadingProb:bookmarkReadingProbList){
                if(bookmarkReadingProb.getReadingProb().equals(newReadingProbList.get(i))){
                    isBookmarked = true;
                    break;
                }
            }
            // 반환 데이터 리스트는 Dto로 변경
            readingProbResponseDtoList.add(new ReadingProbResponseDto(newReadingProbList.get(i), isBookmarked));
        }

        // 시험 Dto로 변경
        TestCreateResponseDto testCreateResponseDto = new TestCreateResponseDto(newTest.getId(), newTest.getTestName(), readingProbResponseDtoList);
        // 생성된 시험 정보와 시험 문항 리스트 반환
        return response.success(testCreateResponseDto, "북마크 시험 생성에 성공했습니다.", HttpStatus.OK);
    }

}
