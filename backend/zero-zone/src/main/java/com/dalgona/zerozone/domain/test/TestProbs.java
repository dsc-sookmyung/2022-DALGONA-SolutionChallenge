package com.dalgona.zerozone.domain.test;

import com.dalgona.zerozone.domain.reading.ReadingProb;
import com.dalgona.zerozone.web.dto.test.TestResult;
import com.fasterxml.jackson.annotation.JsonBackReference;
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
    private int idx;

    @Column
    private boolean useHint;

    @Column
    private boolean isCorrect;

    @JsonBackReference
    @ManyToOne
    @JoinColumn(name = "TEST_ID")
    private Test test;

    @OneToOne
    @JoinColumn(name = "READPROB_ID")
    private ReadingProb readingProb;

    @Builder
    public TestProbs(int idx, boolean useHint, boolean isCorrect, Test test, ReadingProb readingProb){
        this.idx = idx;
        this.useHint = useHint;
        this.isCorrect = isCorrect;
        this.test = test;
        this.readingProb = readingProb;
    }

    public TestProbs updateResult(TestResult testResult){
        this.useHint = testResult.isUsedHint();
        this.isCorrect = testResult.isCorrect();
        return this;
    }

}
