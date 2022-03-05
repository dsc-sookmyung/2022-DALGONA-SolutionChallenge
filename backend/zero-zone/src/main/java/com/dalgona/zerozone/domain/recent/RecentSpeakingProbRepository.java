package com.dalgona.zerozone.domain.recent;

import com.dalgona.zerozone.domain.speaking.SpeakingProb;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface RecentSpeakingProbRepository extends JpaRepository<RecentSpeakingProb, Long> {
    Optional<RecentSpeakingProb> findByRecentSpeakingAndSpeakingProb(RecentSpeaking recentSpeaking, SpeakingProb speakingProb);
    Page<RecentSpeakingProb> findAllByRecentSpeaking(RecentSpeaking recentSpeaking, Pageable paging);
}
