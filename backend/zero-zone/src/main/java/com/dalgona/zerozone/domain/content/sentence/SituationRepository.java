package com.dalgona.zerozone.domain.content.sentence;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface SituationRepository extends JpaRepository<Situation, Long> {
    Optional<Situation> findBySituation(String s);
}
