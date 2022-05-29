package com.dalgona.zerozone.domain.content.word;

import com.dalgona.zerozone.domain.content.letter.Onset;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface WordRepository extends JpaRepository<Word, Long> {
    List<Word> findAllByOnset(Onset onset);

    Optional<Word> findByWord(String word);
}
