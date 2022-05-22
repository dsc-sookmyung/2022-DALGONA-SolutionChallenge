package com.dalgona.zerozone.domain.speaking;

import com.dalgona.zerozone.domain.staticContent.letter.Letter;
import com.dalgona.zerozone.domain.staticContent.sentence.Sentence;
import com.dalgona.zerozone.domain.staticContent.word.Word;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface SpeakingProbRepository extends JpaRepository<SpeakingProb, Long> {
    Optional<SpeakingProb> findByTypeAndLetter(String type, Letter letter);
    Optional<SpeakingProb> findByTypeAndWord(String type, Word word);
    Optional<SpeakingProb> findByTypeAndSentence(String type, Sentence sentence);
}
