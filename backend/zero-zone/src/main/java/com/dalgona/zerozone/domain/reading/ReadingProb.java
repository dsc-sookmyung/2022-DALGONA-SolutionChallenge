package com.dalgona.zerozone.domain.reading;

import com.dalgona.zerozone.domain.content.sentence.Sentence;
import com.dalgona.zerozone.domain.content.word.Word;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class ReadingProb {

    @Id
//    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "READINGPROBS_ID")
    private Long id;

    @Column(length = 20, nullable = false)
    private String type;

    @Column
    private String url;

    @Column(length = 100, nullable = false)
    private String hint;

    @OneToOne
    @JoinColumn(name = "WORD_ID")
    private Word word;

    @OneToOne
    @JoinColumn(name = "SENTENCE_ID")
    private Sentence sentence;

}
