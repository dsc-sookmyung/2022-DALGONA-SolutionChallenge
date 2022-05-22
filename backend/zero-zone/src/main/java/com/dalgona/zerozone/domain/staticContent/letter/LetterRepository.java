package com.dalgona.zerozone.domain.staticContent.letter;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface LetterRepository extends JpaRepository<Letter, Long> {

    // 초성에 해당하는 글자 반환
    List<Letter> findAllByOnset(Onset onset);

    // 초성, 중성에 해당하는 글자 반환
    List <Letter> findAllByOnsetAndNucleus(Onset onset, Nucleus nucleus);

}
