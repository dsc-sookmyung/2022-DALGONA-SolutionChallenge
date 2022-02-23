package com.dalgona.zerozone.domain.content.word;

import com.dalgona.zerozone.domain.content.letter.Onset;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface WordRepository extends JpaRepository<Word, Long> {
    List<Word> findAllByOnset(Onset onset);
}