package com.dalgona.zerozone.domain.content.sentence;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface SentenceRepository extends JpaRepository<Sentence, Long> {

    List<Sentence> findAllBySituation(Situation situation);

}
