package com.dalgona.zerozone.service.recent;

import com.dalgona.zerozone.domain.recent.*;
import com.dalgona.zerozone.domain.speaking.SpeakingProb;
import com.dalgona.zerozone.domain.speaking.SpeakingProbRepository;
import com.dalgona.zerozone.domain.user.User;
import com.dalgona.zerozone.domain.user.UserRepository;
import com.dalgona.zerozone.jwt.SecurityUtil;
import com.dalgona.zerozone.web.dto.Response;
import com.dalgona.zerozone.web.dto.recent.RecentRequestDto;
import com.dalgona.zerozone.web.dto.recent.RecentSpeakingProbResponseDto;
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
public class RecentSpeakingService {

    private final UserRepository userRepository;
    private final RecentSpeakingRepository recentSpeakingRepository;
    private final RecentSpeakingProbRepository recentSpeakingProbRepository;
    private final SpeakingProbRepository speakingProbRepository;
    private final Response response;

    // 토큰으로부터 이메일 읽어오기
    private User getCurrentUser(){
        return SecurityUtil.getCurrentUsername().flatMap(userRepository::findByEmail).orElse(null);
    }

    // 발음 연습 최근 학습에 추가
    @Transactional
    public ResponseEntity<?> addSpeakingRecent(RecentRequestDto requestDto){
        Optional<RecentSpeaking> recentSpeaking;
        Optional<SpeakingProb> speakingProb;
        RecentSpeakingProb totalSpeakingProb;
        List<RecentSpeakingProb> recentSpeakingProbList;

        // 1. 유저 조회
        User user = getCurrentUser();
        // 2. 유저의 발음 최근학습 조회
        recentSpeaking = recentSpeakingRepository.findByUser(user);

        // 여기부터 반복  
        List<Long> recentProbIdRequestList = requestDto.getRecentProbIdRequestList();
        if(recentProbIdRequestList == null)
            return response.fail("요청 데이터가 잘못되었습니다.", HttpStatus.BAD_REQUEST);
        for(Long recentProbRequestId:recentProbIdRequestList) {
            // 3. 요청한 발음 연습 문제 조회
            speakingProb = speakingProbRepository.findById(recentProbRequestId);
            if(!speakingProb.isPresent())
                return response.fail("해당 문제가 발음 연습 문제로 등록되지 않았습니다.", HttpStatus.BAD_REQUEST);

            // 4. 찾은 문항을 중간 엔티티로 변경
            totalSpeakingProb = new RecentSpeakingProb(recentSpeaking.get(), speakingProb.get());

            // 5. 해당 유저의 최근학습 담긴 문제 리스트 가져오기
            recentSpeakingProbList = recentSpeaking.get().getRecentSpeakigProbList();

            // 6. 중복이라면 해당 문항을 삭제
            if(recentSpeakingProbList.contains(totalSpeakingProb)) {
                // 중간 엔티티 테이블에서 찾기
                Optional<RecentSpeakingProb> findTotalSpeakingProb
                         = recentSpeakingProbRepository.findByRecentSpeakingAndSpeakingProb(
                        recentSpeaking.get(), speakingProb.get()
                );
                recentSpeaking.get().deleteSpeakingProb(findTotalSpeakingProb.get());    // 최근학습의 문제 리스트에서 삭제
                speakingProb.get().getRecentSpeakingList().remove(findTotalSpeakingProb.get());  // 문제의 최근학습 리스트에서 삭제
                recentSpeakingProbRepository.delete(findTotalSpeakingProb.get());   // 중간테이블에서 삭제
            }

            // 7. 가장 끝에 추가
            recentSpeakingProbRepository.save(totalSpeakingProb);   // 중간테이블에 추가
            recentSpeaking.get().addSpeakingProb(totalSpeakingProb); // 최근학습의 문제 리스트에 추가
            speakingProb.get().getRecentSpeakingList().add(totalSpeakingProb); // 문제의 최근학습 리스트에 추가
        }
        return response.success("발음 최근학습 리스트에 추가했습니다.");
    }

    // 발음 연습 최근 학습 리스트 조회
    @Transactional
    public ResponseEntity<?> getSpeakingRecent(int page){
        // 0. 요청 페이지 유효성 검사
        if(page<1)
            return response.fail("잘못된 페이지 요청입니다. 1 이상의 페이지를 조회해주세요.", HttpStatus.BAD_REQUEST);
        // 변수 선언
        Optional<RecentSpeaking> recentSpeaking;
        // 1. 유저 조회
        User user = getCurrentUser();
        // 2. 유저의 발음 최근학습 조회
        recentSpeaking = recentSpeakingRepository.findByUser(user);
        if(!recentSpeaking.isPresent())
            return response.fail("해당 회원의 발음 최근학습이 존재하지 않습니다.", HttpStatus.BAD_REQUEST);
        // 3. 해당 북마크에 저장된 문제 리스트 조회
        Pageable paging = PageRequest.of(page-1,10, Sort.by(Sort.Direction.DESC, "id"));
        Page<RecentSpeakingProb> recentSpeakingProbList =
                recentSpeakingProbRepository.findAllByRecentSpeaking(recentSpeaking.get(), paging);
        // 4. Dto로 변환
        Page <RecentSpeakingProbResponseDto> recentSpeakingProbResponseDtoPage
                = recentSpeakingProbList.map(RecentSpeakingProbResponseDto::of);

        return response.success(recentSpeakingProbResponseDtoPage, "발음 최근학습 리스트 조회에 성공했습니다.", HttpStatus.OK);

    }
}
