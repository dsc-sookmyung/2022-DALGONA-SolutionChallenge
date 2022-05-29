package com.dalgona.zerozone.domain.content.sentence;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface SentenceRepository extends JpaRepository<Sentence, Long> {

    List<Sentence> findAllBySituation(Situation situation);

    Optional<Sentence> findBySentence(String token);
}
