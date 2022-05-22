package com.dalgona.zerozone.domain.content.letter;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class Letter {

    @Id
    @Column(name = "LETTER_ID")
    private Long id;

    @OneToOne
    @JoinColumn(name = "ONSET_ID")
    private Onset onset;

    @OneToOne
    @JoinColumn(name = "NUCLEUS_ID")
    private Nucleus nucleus;

    @OneToOne
    @JoinColumn(name = "CODA_ID")
    private Coda coda;

    @Column(length = 15, nullable = false, unique = true)
    private String letter;

}
