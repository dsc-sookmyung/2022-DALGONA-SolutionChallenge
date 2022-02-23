package com.dalgona.zerozone.domain.sentence;

import com.dalgona.zerozone.domain.letter.Onset;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class Sentence {

    @Id
    @Column(name = "SENTENCE_ID")
    private Long id;

    @OneToOne
    @JoinColumn(name = "SITUATION_ID")
    private Situation situation;

    @Column(length = 200, nullable = false, unique = true)
    private String sentence;

}
