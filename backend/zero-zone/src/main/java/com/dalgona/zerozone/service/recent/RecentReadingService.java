package com.dalgona.zerozone.service.recent;

import com.dalgona.zerozone.domain.content.sentence.SentenceRepository;
import com.dalgona.zerozone.domain.content.word.WordRepository;
import com.dalgona.zerozone.domain.reading.ReadingProb;
import com.dalgona.zerozone.domain.reading.ReadingProbRepository;
import com.dalgona.zerozone.domain.recent.*;
import com.dalgona.zerozone.domain.user.User;
import com.dalgona.zerozone.domain.user.UserRepository;
import com.dalgona.zerozone.web.dto.Response;
import com.dalgona.zerozone.web.dto.recent.RecentReadingProbResponseDto;
import com.dalgona.zerozone.web.dto.recent.RecentRequestDto;
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
public class RecentReadingService {

    private final UserRepository userRepository;
    private final RecentReadingRepository recentReadingRepository;
    private final RecentReadingProbRepository recentReadingProbRepository;
    private final ReadingProbRepository readingProbRepository;
    private final WordRepository wordRepository;
    private final SentenceRepository sentenceRepository;
    private final Response response;

    // 구화 연습 최근 학습에 추가
    @Transactional
    public ResponseEntity<?> addReadingRecent(String email, RecentRequestDto requestDto){
        Optional<User> user = userRepository.findByEmail(email);
        Optional<RecentReading> recentReading;
        Optional<ReadingProb> readingProb;
        RecentReadingProb totalReadingProb;
        List<RecentReadingProb> recentReadingProbList;

        // 1. 유저 조회
        if(!user.isPresent())
            return response.fail("해당 회원이 존재하지 않습니다.", HttpStatus.BAD_REQUEST);
        // 2. 유저의 구화 최근학습 조회
        recentReading = recentReadingRepository.findByUser(user.get());

        // 여기부터 반복
        List<Long> recentProbIdRequestList = requestDto.getRecentProbIdRequestList();
        if(recentProbIdRequestList == null)
            return response.fail("요청 데이터가 잘못되었습니다.", HttpStatus.BAD_REQUEST);
        for(Long recentProbRequestId:recentProbIdRequestList) {
            // 3. 요청한 구화 연습 문제 조회
            readingProb = readingProbRepository.findById(recentProbRequestId);
            if(!readingProb.isPresent())
                return response.fail("해당 문제가 구화 연습 문제로 등록되지 않았습니다.", HttpStatus.BAD_REQUEST);

            // 4. 찾은 문항을 중간 엔티티로 변경
            totalReadingProb = new RecentReadingProb(recentReading.get(), readingProb.get());
            // 5. 해당 유저의 최근학습 담긴 문제 리스트 가져오기
            recentReadingProbList = recentReading.get().getRecentReadingProbList();

            // 6. 중복이라면 해당 문항을 삭제
            if(recentReadingProbList.contains(totalReadingProb)){
                recentReadingProbRepository.delete(totalReadingProb);   // 중간테이블에서 삭제
                recentReading.get().deleteReadingProb(totalReadingProb);    // 최근학습의 문제 리스트에서 삭제
                readingProb.get().getRecentReadingList().remove(totalReadingProb);  // 문제의 최근학습 리스트에서 삭제

                // 중간 엔티티 테이블에서 찾기
                Optional<RecentReadingProb> findTotalReadingProb
                        = recentReadingProbRepository.findByRecentReadingAndReadingProb(
                        recentReading.get(), readingProb.get()
                );
                recentReading.get().deleteReadingProb(findTotalReadingProb.get());    // 최근학습의 문제 리스트에서 삭제
                readingProb.get().getRecentReadingList().remove(findTotalReadingProb.get());  // 문제의 최근학습 리스트에서 삭제
                recentReadingProbRepository.delete(findTotalReadingProb.get());   // 중간테이블에서 삭제
            }

            // 7. 가장 끝에 추가
            recentReadingProbRepository.save(totalReadingProb);   // 중간테이블에 추가
            recentReading.get().addReadingProb(totalReadingProb); // 최근학습의 문제 리스트에 추가
            readingProb.get().getRecentReadingList().add(totalReadingProb); // 문제의 최근학습 리스트에 추가
        }
        return response.success("구화 최근학습 리스트에 추가했습니다.");
    }

    // 구화 연습 최근 학습 리스트 조회
    @Transactional
    public ResponseEntity<?> getReadingRecent(String email, int page){
        // 0. 요청 페이지 유효성 검사
        if(page<1)
            return response.fail("잘못된 페이지 요청입니다. 1 이상의 페이지를 조회해주세요.", HttpStatus.BAD_REQUEST);
        // 변수 선언
        Optional<User> user = userRepository.findByEmail(email);
        Optional<RecentReading> recentReading;
        // 1. 유저 조회
        if(!user.isPresent())
            return response.fail("해당 회원이 존재하지 않습니다.", HttpStatus.BAD_REQUEST);
        // 2. 유저의 구화 최근학습 조회
        recentReading = recentReadingRepository.findByUser(user.get());
        if(!recentReading.isPresent())
            return response.fail("해당 회원의 구화 최근학습이 존재하지 않습니다.", HttpStatus.BAD_REQUEST);
        // 3. 해당 북마크에 저장된 문제 리스트 조회
        Pageable paging = PageRequest.of(page-1,10, Sort.by(Sort.Direction.DESC, "id"));
        Page<RecentReadingProb> recentReadingProbList =
                recentReadingProbRepository.findAllByRecentReading(recentReading.get(), paging);
        // 4. Dto로 변환
        Page <RecentReadingProbResponseDto> recentReadingProbResponseDtoPage
                = recentReadingProbList.map(RecentReadingProbResponseDto::of);

        return response.success(recentReadingProbResponseDtoPage, "구화 최근학습 리스트 조회에 성공했습니다.", HttpStatus.OK);
    }
}
