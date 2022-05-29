package com.dalgona.zerozone.domain.content.letter;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface CodaRepository extends JpaRepository<Coda, Long> {
    Optional<Coda> findByCoda(String s);
}
