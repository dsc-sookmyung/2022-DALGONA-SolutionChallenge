package com.dalgona.zerozone.domain.bookmark;

import com.dalgona.zerozone.domain.user.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface BookmarkSpeakingRepository extends JpaRepository<BookmarkSpeaking, Long> {
    Optional<BookmarkSpeaking> findByUser(User user);
}
