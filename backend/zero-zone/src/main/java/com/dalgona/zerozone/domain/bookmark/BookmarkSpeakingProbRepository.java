package com.dalgona.zerozone.domain.bookmark;

import com.dalgona.zerozone.domain.speaking.SpeakingProb;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface BookmarkSpeakingProbRepository extends JpaRepository<BookmarkSpeakingProb, Long> {
    Optional<BookmarkSpeakingProb> findByBookmarkSpeakingAndSpeakingProb(BookmarkSpeaking bookmarkSpeaking, SpeakingProb speakingProb);
    Page<BookmarkSpeakingProb> findAllByBookmarkSpeaking(BookmarkSpeaking bookmarkSpeaking, Pageable paging);
    List<BookmarkSpeakingProb> findAllByBookmarkSpeaking(Optional<BookmarkSpeaking> bookmarkSpeaking);
}
