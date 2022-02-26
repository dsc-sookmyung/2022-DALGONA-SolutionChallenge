package com.dalgona.zerozone.web.controller;

import com.dalgona.zerozone.domain.customAnnotation.QueryStringArgResolver;
import com.dalgona.zerozone.service.bookmark.BookmarkReadingService;
import com.dalgona.zerozone.web.dto.bookmark.BookmarkRequestDto;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RequiredArgsConstructor
@RestController
@RequestMapping("/bookmark")
public class BookmarkController {

    private final BookmarkReadingService bookmarkReadingService;

    // 구화 연습 북마크에 추가
    // 매개변수 : 타입(단어, 문장), 일련번호
    @PostMapping("/reading")
    public ResponseEntity<?> addReadingBookmark(@RequestParam String email, @QueryStringArgResolver BookmarkRequestDto requestDto){
        return bookmarkReadingService.addReadingBookmark(email, requestDto);
    }

    // 구화 연습 북마크 조회
    @GetMapping("/reading")
    public ResponseEntity<?> getReadingBookmark(@RequestParam String email, @RequestParam(required = false, defaultValue = "1", value = "page") int page){
        return bookmarkReadingService.getReadingBookmark(email, page);
    }

    // 구화 연습 북마크 해제
    @DeleteMapping("/reading")
    public ResponseEntity<?> deleteReadingBookmarkProb(@RequestParam String email, @QueryStringArgResolver BookmarkRequestDto requestDto){
        return bookmarkReadingService.deleteReadingBookmarkProb(email, requestDto);
    }


    // 발음 연습 북마크에 추가


    // 발음 연습 북마크 조회



}
