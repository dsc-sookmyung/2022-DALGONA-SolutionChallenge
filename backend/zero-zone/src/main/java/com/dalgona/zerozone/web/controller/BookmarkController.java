package com.dalgona.zerozone.web.controller;

import com.dalgona.zerozone.service.bookmark.BookmarkReadingService;
import com.dalgona.zerozone.service.bookmark.BookmarkSpeakingService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RequiredArgsConstructor
@RestController
@RequestMapping("/bookmark")
public class BookmarkController {

    private final BookmarkReadingService bookmarkReadingService;
    private final BookmarkSpeakingService bookmarkSpeakingService;

    // 구화 연습 북마크에 추가
    // 매개변수 : 타입(단어, 문장), 일련번호
    @PostMapping("/reading")
    public ResponseEntity<?> addReadingBookmark(@RequestParam String email, @RequestParam Long readingProbId){
        return bookmarkReadingService.addReadingBookmark(email, readingProbId);
    }

    // 구화 연습 북마크 조회
    @GetMapping("/reading")
    public ResponseEntity<?> getReadingBookmark(@RequestParam String email, @RequestParam(required = false, defaultValue = "1", value = "page") int page){
        return bookmarkReadingService.getReadingBookmark(email, page);
    }

    // 구화 연습 북마크 해제
    @DeleteMapping("/reading")
    public ResponseEntity<?> deleteReadingBookmarkProb(@RequestParam String email, @RequestParam Long readingProbId){
        return bookmarkReadingService.deleteReadingBookmarkProb(email, readingProbId);
    }

    // 발음 연습 북마크에 추가
    // 매개변수 : 타입(단어, 문장), 일련번호
    @PostMapping("/speaking")
    public ResponseEntity<?> addSpeakingBookmark(@RequestParam String email, @RequestParam Long speakingProbId){
        return bookmarkSpeakingService.addSpeakingBookmark(email, speakingProbId);
    }

    // 발음 연습 북마크 조회
    @GetMapping("/speaking")
    public ResponseEntity<?> getSpeakingBookmark(@RequestParam String email, @RequestParam(required = false, defaultValue = "1", value = "page") int page){
        return bookmarkSpeakingService.getSpeakingBookmark(email, page);
    }

    // 발음 연습 북마크 해제
    @DeleteMapping("/speaking")
    public ResponseEntity<?> deleteSpeakingBookmarkProb(@RequestParam String email, @RequestParam Long speakingProbId){
        return bookmarkSpeakingService.deleteSpeakingBookmarkProb(email, speakingProbId);
    }


}
