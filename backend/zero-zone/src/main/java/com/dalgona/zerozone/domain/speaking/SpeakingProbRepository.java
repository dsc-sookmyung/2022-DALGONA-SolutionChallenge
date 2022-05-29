package com.dalgona.zerozone.domain.speaking;

import com.dalgona.zerozone.domain.content.letter.Letter;
import com.dalgona.zerozone.domain.content.sentence.Sentence;
import com.dalgona.zerozone.domain.content.word.Word;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface SpeakingProbRepository extends JpaRepository<SpeakingProb, Long> {
    Optional<SpeakingProb> findByTypeAndLetter(String type, Letter letter);
    Optional<SpeakingProb> findByTypeAndWord(String type, Word word);
    Optional<SpeakingProb> findByTypeAndSentence(String type, Sentence sentence);

    Optional<SpeakingProb> findByLetter(Letter letter);
    Optional<SpeakingProb> findByWord(Word word);
    Optional<SpeakingProb> findBySentence(Sentence sentence);
}
