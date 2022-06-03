package com.dalgona.zerozone.domain.customProbs.customReading;

import com.dalgona.zerozone.domain.user.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CustomReadingProbRepository extends JpaRepository<CustomReadingProb, Long> {
    List<CustomReadingProb> findAllByUser(User user);
}
