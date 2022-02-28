package com.dalgona.zerozone.service.bookmark;

import com.dalgona.zerozone.domain.bookmark.*;
import com.dalgona.zerozone.domain.content.letter.Letter;
import com.dalgona.zerozone.domain.content.letter.LetterRepository;
import com.dalgona.zerozone.domain.content.sentence.Sentence;
import com.dalgona.zerozone.domain.content.sentence.SentenceRepository;
import com.dalgona.zerozone.domain.content.word.Word;
import com.dalgona.zerozone.domain.content.word.WordRepository;
import com.dalgona.zerozone.domain.speaking.SpeakingProb;
import com.dalgona.zerozone.domain.speaking.SpeakingProbRepository;
import com.dalgona.zerozone.domain.user.User;
import com.dalgona.zerozone.domain.user.UserRepository;
import com.dalgona.zerozone.web.dto.Response;
import com.dalgona.zerozone.web.dto.bookmark.BookmarkRequestDto;
import com.dalgona.zerozone.web.dto.bookmark.BookmarkSpeakingProbResponseDto;
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
public class BookmarkSpeakingService {

    private final BookmarkSpeakingRepository bookmarkSpeakingRepository;
    private final SpeakingProbRepository speakingProbRepository;
    private final BookmarkSpeakingProbRepository bookmarkSpeakingProbRepository;
    private final LetterRepository letterRepository;
    private final WordRepository wordRepository;
    private final SentenceRepository sentenceRepository;
    private final UserRepository userRepository;
    private final Response response;

    // 발음 북마크에 추가
    @Transactional
    public ResponseEntity<?> addSpeakingBookmark(String email, BookmarkRequestDto requestDto){
        // 필요한 변수 : 회원, 회원의 북마크, 북마크 요청한 발음 연습 문제, 연습 문제를 담을 중간 엔티티
        Optional<User> user = userRepository.findByEmail(email);
        Optional<BookmarkSpeaking> bookmarkSpeaking;
        Optional<SpeakingProb> speakingProb;
        BookmarkSpeakingProb totalSpeakingProb;
        List<BookmarkSpeakingProb> bookmarkSpeakingProbList;

        // 1. 유저 조회
        if(!user.isPresent())
            return response.fail("해당 회원이 존재하지 않습니다.", HttpStatus.BAD_REQUEST);
        // 2. 유저의 발음 북마크 조회
        bookmarkSpeaking = bookmarkSpeakingRepository.findByUser(user.get());
        if(!bookmarkSpeaking.isPresent())
            return response.fail("해당 회원의 발음 북마크가 존재하지 않습니다.", HttpStatus.BAD_REQUEST);

        // 3. 요청한 발음 연습 문제 조회
        if(requestDto.getType().compareTo("letter")==0){
            Optional<Letter> letter = letterRepository.findById(requestDto.getId());
            if(!letter.isPresent())
                return response.fail("요청한 글자가 존재하지 않습니다.", HttpStatus.BAD_REQUEST);
            speakingProb = speakingProbRepository.findByTypeAndLetter("letter", letter.get());
        }
        else if(requestDto.getType().compareTo("word")==0){
            Optional<Word> word = wordRepository.findById(requestDto.getId());
            if(!word.isPresent())
                return response.fail("요청한 단어가 존재하지 않습니다.", HttpStatus.BAD_REQUEST);
            speakingProb = speakingProbRepository.findByTypeAndWord("word", word.get());
        }
        else if(requestDto.getType().compareTo("sentence")==0){
            Optional<Sentence> sentence = sentenceRepository.findById(requestDto.getId());
            if(!sentence.isPresent())
                return response.fail("요청한 문장이 존재하지 않습니다.", HttpStatus.BAD_REQUEST);
            speakingProb = speakingProbRepository.findByTypeAndSentence("sentence", sentence.get());
        }
        else {
            return response.fail("잘못된 요청입니다.", HttpStatus.BAD_REQUEST);
        }
        
        // 발음 연습 문제로 등록되지 않은 경우 처리
        if(!speakingProb.isPresent())
            return response.fail("해당 문제가 발음 연습 문제로 등록되지 않았습니다.", HttpStatus.BAD_REQUEST);

        // 4. 찾은 문항을 중간 엔티티로 변경
        totalSpeakingProb = new BookmarkSpeakingProb(bookmarkSpeaking.get(), speakingProb.get());
        // 5. 해당 유저의 북마크에 담긴 문제 리스트 가져오기
        bookmarkSpeakingProbList = bookmarkSpeaking.get().getBookmarkSpeakingList();

        // 6. 중복 조회
        if(bookmarkSpeakingProbList.contains(totalSpeakingProb))
            return response.fail("이미 북마크되었습니다.", HttpStatus.BAD_REQUEST);

        // 7. 중복이 아니라면 추가
        bookmarkSpeakingProbRepository.save(totalSpeakingProb);   // 중간테이블에 추가
        bookmarkSpeaking.get().addSpeakingProb(totalSpeakingProb); // 북마크의 문제 리스트에 추가
        speakingProb.get().getBookmarkSpeakingProbList().add(totalSpeakingProb); // 문제의 북마크 리스트에 추가
        return response.success("발음 북마크에 추가했습니다.");
    }

    // 발음 북마크 조회
    // 페이징 처리 해야함
    @Transactional
    public ResponseEntity<?> getSpeakingBookmark(String email, int page){
        // 0. 요청 페이지 유효성 검사
        if(page<1)
            return response.fail("잘못된 페이지 요청입니다. 1 이상의 페이지를 조회해주세요.", HttpStatus.BAD_REQUEST);
        // 1. 유저 조회
        Optional<User> user = userRepository.findByEmail(email);
        if(!user.isPresent()) return response.fail("해당 회원이 존재하지 않습니다.", HttpStatus.BAD_REQUEST);
        // 2. 유저의 발음 북마크 조회
        Optional<BookmarkSpeaking> bookmarkSpeaking = bookmarkSpeakingRepository.findByUser(user.get());
        if(!bookmarkSpeaking.isPresent()) return response.fail("해당 회원의 발음 북마크가 존재하지 않습니다.", HttpStatus.BAD_REQUEST);
        // 3. 해당 북마크에 저장된 문제 리스트 조회
        Pageable paging = PageRequest.of(page-1,10, Sort.by(Sort.Direction.DESC, "id"));
        Page<BookmarkSpeakingProb> bookmarkSpeakingProbList =
                bookmarkSpeakingProbRepository.findAllByBookmarkSpeaking(bookmarkSpeaking.get(), paging);
        // 4. Dto로 변환
        Page <BookmarkSpeakingProbResponseDto> bookmarkSpeakingProbResponseDtoPage
                = bookmarkSpeakingProbList.map(BookmarkSpeakingProbResponseDto::of);

        return response.success(bookmarkSpeakingProbResponseDtoPage, "발음 북마크 리스트 조회에 성공했습니다.", HttpStatus.OK);
    }

    // 발음 북마크 해제
    @Transactional
    public ResponseEntity<?> deleteSpeakingBookmarkProb(String email, BookmarkRequestDto requestDto){

        // 필요한 변수 : 회원, 회원의 북마크, 북마크 요청한 발음 연습 문제, 연습 문제를 담을 중간 엔티티
        Optional<User> user = userRepository.findByEmail(email);
        Optional<BookmarkSpeaking> bookmarkSpeaking;
        Optional<SpeakingProb> speakingProb;
        Optional<BookmarkSpeakingProb> totalSpeakingProb;
        List<BookmarkSpeakingProb> bookmarkSpeakingProbList;

        // 1. 유저 조회
        if(!user.isPresent())
            return response.fail("해당 회원이 존재하지 않습니다.", HttpStatus.BAD_REQUEST);
        // 2. 유저의 발음 북마크 조회
        bookmarkSpeaking = bookmarkSpeakingRepository.findByUser(user.get());
        if(!bookmarkSpeaking.isPresent())
            return response.fail("해당 회원의 발음 북마크가 존재하지 않습니다.", HttpStatus.BAD_REQUEST);

        // 3. 요청한 발음 연습 문제 조회
        if(requestDto.getType().compareTo("letter")==0){
            Optional<Letter> letter = letterRepository.findById(requestDto.getId());
            if(!letter.isPresent())
                return response.fail("요청한 글자가 존재하지 않습니다.", HttpStatus.BAD_REQUEST);
            speakingProb = speakingProbRepository.findByTypeAndLetter("letter", letter.get());
        }
        else if(requestDto.getType().compareTo("word")==0){
            Optional<Word> word = wordRepository.findById(requestDto.getId());
            if(!word.isPresent())
                return response.fail("요청한 단어가 존재하지 않습니다.", HttpStatus.BAD_REQUEST);
            speakingProb = speakingProbRepository.findByTypeAndWord("word", word.get());
        }
        else if(requestDto.getType().compareTo("sentence")==0){
            Optional<Sentence> sentence = sentenceRepository.findById(requestDto.getId());
            if(!sentence.isPresent())
                return response.fail("요청한 문장이 존재하지 않습니다.", HttpStatus.BAD_REQUEST);
            speakingProb = speakingProbRepository.findByTypeAndSentence("sentence", sentence.get());
        }
        else {
            return response.fail("잘못된 요청입니다.", HttpStatus.BAD_REQUEST);
        }

        // 발음 연습 문제로 등록되지 않은 경우 처리
        if(!speakingProb.isPresent())
            return response.fail("해당 문제가 발음 연습 문제로 등록되지 않았습니다.", HttpStatus.BAD_REQUEST);

        // 4. 찾은 문항을 중간 엔티티에서 조회 : 북마크+발음연습
        totalSpeakingProb = bookmarkSpeakingProbRepository.findByBookmarkSpeakingAndSpeakingProb(
                bookmarkSpeaking.get(), speakingProb.get()
        );
        // 5. 중복 조회
        if(!totalSpeakingProb.isPresent()){
            return response.fail("북마크되지 않은 문제를 삭제하려고 합니다.", HttpStatus.BAD_REQUEST);
        }
        // 6. 중복이라면 삭제
        bookmarkSpeaking.get().deleteSpeakingProb(totalSpeakingProb.get()); // 북마크의 문제 리스트에서 삭제
        speakingProb.get().getBookmarkSpeakingProbList().remove(totalSpeakingProb.get()); // 문제의 북마크 리스트에서 삭제
        bookmarkSpeakingProbRepository.delete(totalSpeakingProb.get());   // 중간테이블에서 삭제

        return response.success("발음 북마크 리스트에서 해당 문항을 삭제했습니다.");
    }

}
