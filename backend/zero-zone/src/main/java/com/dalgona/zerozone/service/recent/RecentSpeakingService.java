package com.dalgona.zerozone.service.recent;

import com.dalgona.zerozone.domain.content.letter.Letter;
import com.dalgona.zerozone.domain.content.letter.LetterRepository;
import com.dalgona.zerozone.domain.content.sentence.Sentence;
import com.dalgona.zerozone.domain.content.sentence.SentenceRepository;
import com.dalgona.zerozone.domain.content.word.Word;
import com.dalgona.zerozone.domain.content.word.WordRepository;
import com.dalgona.zerozone.domain.recent.*;
import com.dalgona.zerozone.domain.speaking.SpeakingProb;
import com.dalgona.zerozone.domain.speaking.SpeakingProbRepository;
import com.dalgona.zerozone.domain.user.User;
import com.dalgona.zerozone.domain.user.UserRepository;
import com.dalgona.zerozone.web.dto.Response;
import com.dalgona.zerozone.web.dto.recent.RecentProbRequest;
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
    private final LetterRepository letterRepository;
    private final WordRepository wordRepository;
    private final SentenceRepository sentenceRepository;
    private final Response response;

    // 발음 연습 최근 학습에 추가
    @Transactional
    public ResponseEntity<?> addSpeakingRecent(String email, RecentRequestDto requestDto){
        Optional<User> user = userRepository.findByEmail(email);
        Optional<RecentSpeaking> recentSpeaking;
        Optional<SpeakingProb> speakingProb;
        RecentSpeakingProb totalSpeakingProb;
        List<RecentSpeakingProb> recentSpeakingProbList;

        // 1. 유저 조회
        if(!user.isPresent())
            return response.fail("해당 회원이 존재하지 않습니다.", HttpStatus.BAD_REQUEST);
        // 2. 유저의 발음 최근학습 조회
        recentSpeaking = recentSpeakingRepository.findByUser(user.get());

        // 여기부터 반복  
        List<RecentProbRequest> recentProbRequestList = requestDto.getRecentProbRequestList();
        // 3. 요청한 발음 연습 문제 조회
        for(RecentProbRequest recentProbRequest:recentProbRequestList) {
            if (recentProbRequest.getType().compareTo("letter") == 0) {
                Optional<Letter> letter = letterRepository.findById(recentProbRequest.getId());
                if (!letter.isPresent())
                    return response.fail("요청한 글자가 존재하지 않습니다.", HttpStatus.BAD_REQUEST);
                speakingProb = speakingProbRepository.findByTypeAndLetter("letter", letter.get());
            }
            else if (recentProbRequest.getType().compareTo("word") == 0) {
                Optional<Word> word = wordRepository.findById(recentProbRequest.getId());
                if (!word.isPresent())
                    return response.fail("요청한 단어가 존재하지 않습니다.", HttpStatus.BAD_REQUEST);
                speakingProb = speakingProbRepository.findByTypeAndWord("word", word.get());
            } else if (recentProbRequest.getType().compareTo("sentence") == 0) {
                Optional<Sentence> sentence = sentenceRepository.findById(recentProbRequest.getId());
                if (!sentence.isPresent())
                    return response.fail("요청한 문장이 존재하지 않습니다.", HttpStatus.BAD_REQUEST);
                speakingProb = speakingProbRepository.findByTypeAndSentence("sentence", sentence.get());
            } else {
                return response.fail("잘못된 요청입니다.", HttpStatus.BAD_REQUEST);
            }

            // 발음 연습 문제로 등록되지 않은 경우 처리
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
    public ResponseEntity<?> getSpeakingRecent(String email, int page){
        // 0. 요청 페이지 유효성 검사
        if(page<1)
            return response.fail("잘못된 페이지 요청입니다. 1 이상의 페이지를 조회해주세요.", HttpStatus.BAD_REQUEST);
        // 변수 선언
        Optional<User> user = userRepository.findByEmail(email);
        Optional<RecentSpeaking> recentSpeaking;
        // 1. 유저 조회
        if(!user.isPresent())
            return response.fail("해당 회원이 존재하지 않습니다.", HttpStatus.BAD_REQUEST);
        // 2. 유저의 발음 최근학습 조회
        recentSpeaking = recentSpeakingRepository.findByUser(user.get());
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
