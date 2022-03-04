package com.dalgona.zerozone.domain.recent;

import com.dalgona.zerozone.domain.reading.ReadingProb;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface RecentReadingProbRepository extends JpaRepository<RecentReadingProb, Long> {
    Optional<RecentReadingProb> findByRecentReadingAndReadingProb(RecentReading recentReading, ReadingProb readingProb);
    Page<RecentReadingProb> findAllByRecentReading(RecentReading recentReading, Pageable paging);
}
