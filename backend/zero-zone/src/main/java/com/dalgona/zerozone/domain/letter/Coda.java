package com.dalgona.zerozone.domain.letter;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class Coda {

    @Id
    @Column(name = "CODA_ID")
    private Long id;

    @Column(length = 5, nullable = false, unique = true)
    private String coda;
}
