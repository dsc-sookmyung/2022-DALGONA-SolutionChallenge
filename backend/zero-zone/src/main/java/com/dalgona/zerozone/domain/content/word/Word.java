package com.dalgona.zerozone.domain.content.word;

import com.dalgona.zerozone.domain.content.Content;
import com.dalgona.zerozone.domain.content.letter.Onset;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class Word {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "WORD_ID")
    private Long id;

    @OneToOne
    @JoinColumn(name = "ONSET_ID")
    private Onset onset;

    @Column(length = 100, nullable = false, unique = true)
    private String word;

    @Builder
    public Word(String word, Onset onset){
        this.word = word;
        this.onset = onset;
    }

}
