package com.dalgona.zerozone.domain.test;

import com.dalgona.zerozone.domain.reading.ReadingProb;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class TestProbs {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column
    private int index;

    @Column
    private boolean useHint;

    @Column
    private boolean isCorrect;

    @ManyToOne
    @JoinColumn(name = "TEST_ID")
    private Test test;

    @OneToOne
    @JoinColumn(name = "READPROB_ID")
    private ReadingProb readingProb;

    @Builder
    public TestProbs(int index, boolean useHint, boolean isCorrect, Test test, ReadingProb readingProb){
        this.index = index;
        this.useHint = useHint;
        this.isCorrect = isCorrect;
        this.test = test;
        this.readingProb = readingProb;
    }

}
