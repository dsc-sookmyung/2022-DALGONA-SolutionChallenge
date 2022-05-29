package com.dalgona.zerozone.domain.content.letter;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface NucleusRepository extends JpaRepository<Nucleus, Long> {
    Optional<Nucleus> findByNucleus(String s);
}
