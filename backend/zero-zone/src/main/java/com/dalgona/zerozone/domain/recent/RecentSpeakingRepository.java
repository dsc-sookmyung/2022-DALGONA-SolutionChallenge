package com.dalgona.zerozone.domain.recent;

import com.dalgona.zerozone.domain.user.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface RecentSpeakingRepository extends JpaRepository<RecentSpeaking, Long> {
    Optional<RecentSpeaking> findByUser(User user);
}
