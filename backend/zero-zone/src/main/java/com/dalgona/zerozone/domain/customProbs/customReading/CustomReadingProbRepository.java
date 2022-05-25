package com.dalgona.zerozone.domain.customProbs.customReading;

import com.dalgona.zerozone.domain.user.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CustomReadingProbRepository extends JpaRepository<CustomReadingProb, Long> {
    Page<CustomReadingProb> findAllByUser(User user, Pageable paging);
}
