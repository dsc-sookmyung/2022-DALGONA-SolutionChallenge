package com.dalgona.zerozone.domain.customProbs.customSpeaking;

import com.dalgona.zerozone.domain.user.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CustomSpeakingProbRepository extends JpaRepository<CustomSpeakingProb, Long> {
    Page<CustomSpeakingProb> findAllByUser(User user, Pageable paging);
}
