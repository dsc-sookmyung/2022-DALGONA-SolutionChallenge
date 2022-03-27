package com.dalgona.zerozone.domain.bookmark;

import com.dalgona.zerozone.domain.reading.ReadingProb;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface BookmarkReadingProbRepository extends JpaRepository<BookmarkReadingProb, Long> {

    Optional<BookmarkReadingProb> findByBookmarkReadingAndReadingProb(BookmarkReading bookmarkReading, ReadingProb readingProb);
    Page<BookmarkReadingProb> findAllByBookmarkReading(BookmarkReading bookmarkReading, Pageable paging);
    List<BookmarkReadingProb> findAllByBookmarkReading(Optional<BookmarkReading> bookmark);

}
