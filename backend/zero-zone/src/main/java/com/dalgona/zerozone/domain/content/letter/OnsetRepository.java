package com.dalgona.zerozone.domain.content.letter;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;


public interface OnsetRepository extends JpaRepository<Onset, Long> {
    Optional<Onset> findByOnset(String s);
}
