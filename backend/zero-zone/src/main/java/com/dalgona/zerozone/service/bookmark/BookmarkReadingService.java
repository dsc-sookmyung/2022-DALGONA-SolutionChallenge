package com.dalgona.zerozone.service.bookmark;

import com.dalgona.zerozone.domain.bookmark.BookmarkReading;
import com.dalgona.zerozone.domain.bookmark.BookmarkReadingProbRepository;
import com.dalgona.zerozone.domain.bookmark.BookmarkReadingRepository;
import com.dalgona.zerozone.domain.bookmark.BookmarkReadingProb;
import com.dalgona.zerozone.domain.content.sentence.SentenceRepository;
import com.dalgona.zerozone.domain.content.word.WordRepository;
import com.dalgona.zerozone.domain.reading.ReadingProb;
import com.dalgona.zerozone.domain.reading.ReadingProbRepository;
import com.dalgona.zerozone.domain.user.User;
import com.dalgona.zerozone.domain.user.UserRepository;
import com.dalgona.zerozone.jwt.SecurityUtil;
import com.dalgona.zerozone.web.dto.Response;
import com.dalgona.zerozone.web.dto.bookmark.BookmarkReadingProbResponseDto;
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
public class BookmarkReadingService {

    private final BookmarkReadingRepository bookmarkReadingRepository;
    private final ReadingProbRepository readingProbRepository;
    private final BookmarkReadingProbRepository bookmarkReadingProbRepository;
    private final UserRepository userRepository;
    private final Response response;

    // 토큰으로부터 이메일 읽어오기
    private User getCurrentUser(){
        return SecurityUtil.getCurrentUsername().flatMap(userRepository::findByEmail).orElse(null);
    }

    // 구화 북마크에 추가
    @Transactional
    public ResponseEntity<?> addReadingBookmark(Long readingProbId){
        // 필요한 변수 : 회원의 북마크, 북마크 요청한 구화 연습 문제, 연습 문제를 담을 중간 엔티티
        Optional<BookmarkReading> bookmarkReading;
        Optional<ReadingProb> readingProb;
        BookmarkReadingProb totalReadingProb;
        List<BookmarkReadingProb> bookmarkReadingProbList;

        // 1. 유저 조회
        User user = getCurrentUser();
        // 2. 유저의 구화 북마크 조회
        bookmarkReading = bookmarkReadingRepository.findByUser(user);

        // 3. 발음 연습 문제 조회
        readingProb = readingProbRepository.findById(readingProbId);
        if(!readingProb.isPresent())
            return response.fail("해당 문제가 구화 연습 문제로 등록되지 않았습니다.", HttpStatus.BAD_REQUEST);

        // 4. 찾은 문항을 중간 엔티티로 변경
        totalReadingProb = new BookmarkReadingProb(bookmarkReading.get(), readingProb.get());
        // 5. 해당 유저의 북마크에 담긴 문제 리스트 가져오기
        bookmarkReadingProbList = bookmarkReading.get().getBookmarkReadingList();

        // 6. 중복 조회
        if(bookmarkReadingProbList.contains(totalReadingProb))
            return response.fail("이미 북마크되었습니다.", HttpStatus.BAD_REQUEST);

        // 7. 중복이 아니라면 추가
        bookmarkReadingProbRepository.save(totalReadingProb);   // 중간테이블에 추가
        bookmarkReading.get().addReadingProb(totalReadingProb); // 북마크의 문제 리스트에 추가
        readingProb.get().getBookmarkReadingList().add(totalReadingProb); // 문제의 북마크 리스트에 추가
        return response.success("구화 북마크에 추가했습니다.");
    }

    // 구화 북마크 조회
    // 페이징 처리 해야함
    @Transactional
    public ResponseEntity<?> getReadingBookmark(int page){
        // 0. 요청 페이지 유효성 검사
        if(page<1)
            return response.fail("잘못된 페이지 요청입니다. 1 이상의 페이지를 조회해주세요.", HttpStatus.BAD_REQUEST);
        // 1. 유저 조회
        User user = getCurrentUser();
        // 2. 유저의 구화 북마크 조회
        Optional<BookmarkReading> bookmarkReading = bookmarkReadingRepository.findByUser(user);
        if(!bookmarkReading.isPresent()) return response.fail("해당 회원의 구화 북마크가 존재하지 않습니다.", HttpStatus.BAD_REQUEST);
        // 3. 해당 북마크에 저장된 문제 리스트 조회
        Pageable paging = PageRequest.of(page-1,50, Sort.by(Sort.Direction.DESC, "id"));
        Page<BookmarkReadingProb> bookmarkReadingProbList =
                bookmarkReadingProbRepository.findAllByBookmarkReading(bookmarkReading.get(), paging);
        // 4. Dto로 변환
        Page <BookmarkReadingProbResponseDto> bookmarkReadingProbResponseDtoPage
        = bookmarkReadingProbList.map(BookmarkReadingProbResponseDto::of);

        return response.success(bookmarkReadingProbResponseDtoPage, "구화 북마크 리스트 조회에 성공했습니다.", HttpStatus.OK);
    }

    // 구화 북마크 해제
    @Transactional
    public ResponseEntity<?> deleteReadingBookmarkProb(Long readingProbId){

        // 필요한 변수 : 회원, 회원의 북마크, 북마크 요청한 구화 연습 문제, 연습 문제를 담을 중간 엔티티
        Optional<BookmarkReading> bookmarkReading;
        Optional<ReadingProb> readingProb;
        Optional<BookmarkReadingProb> totalReadingProb;
        List<BookmarkReadingProb> bookmarkReadingProbList;

        // 1. 유저 조회
        User user = getCurrentUser();
        // 2. 유저의 구화 북마크 조회
        bookmarkReading = bookmarkReadingRepository.findByUser(user);
        if(!bookmarkReading.isPresent())
            return response.fail("해당 회원의 구화 북마크가 존재하지 않습니다.", HttpStatus.BAD_REQUEST);
        // 3. 발음 연습 문제 조회
        readingProb = readingProbRepository.findById(readingProbId);
        if(!readingProb.isPresent())
            return response.fail("해당 문제가 구화 연습 문제로 등록되지 않았습니다.", HttpStatus.BAD_REQUEST);

        // 4. 찾은 문항을 중간 엔티티에서 조회 : 북마크+구화연습
        totalReadingProb = bookmarkReadingProbRepository.findByBookmarkReadingAndReadingProb(
                bookmarkReading.get(), readingProb.get()
        );
        // 5. 중복 조회
        if(!totalReadingProb.isPresent()){
            return response.fail("북마크되지 않은 문제를 삭제하려고 합니다.", HttpStatus.BAD_REQUEST);
        }
        // 6. 중복이라면 삭제
        bookmarkReading.get().deleteReadingProb(totalReadingProb.get()); // 북마크의 문제 리스트에서 삭제
        readingProb.get().getBookmarkReadingList().remove(totalReadingProb.get()); // 문제의 북마크 리스트에서 삭제
        bookmarkReadingProbRepository.delete(totalReadingProb.get());   // 중간테이블에서 삭제

        return response.success("구화 북마크 리스트에서 해당 문항을 삭제했습니다.");
    }

}
