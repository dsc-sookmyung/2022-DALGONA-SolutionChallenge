package com.dalgona.zerozone.domain.reading;

import com.dalgona.zerozone.domain.content.sentence.Sentence;
import com.dalgona.zerozone.domain.content.word.Word;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ReadingProbRepository extends JpaRepository<ReadingProb, Long> {

    Optional<ReadingProb> findByTypeAndWord(String type, Word word);
    Optional<ReadingProb> findByTypeAndSentence(String type, Sentence sentence);
    List<ReadingProb> findAllByType(String type);
    Optional<ReadingProb> findBySentence(Sentence sentence);
    Optional<ReadingProb> findByWord(Word word);
}
