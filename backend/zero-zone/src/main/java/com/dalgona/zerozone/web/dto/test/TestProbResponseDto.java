package com.dalgona.zerozone.web.dto.test;

import com.dalgona.zerozone.domain.test.TestProbs;
import com.dalgona.zerozone.web.dto.readingPractice.ReadingProbResponseDto;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class TestProbResponseDto {

    private Long probId;
    private int idx;
    private boolean useHint;
    private boolean isCorrect;
    private ReadingProbResponseDto readingProb;
    private Long nextProbId;

    public TestProbResponseDto(TestProbs testProb, Long nextProbId, boolean isBookmarked){
        this.probId = testProb.getId();
        this.idx = testProb.getIdx();
        this.useHint = testProb.isUseHint();
        this.isCorrect = testProb.isCorrect();
        this.readingProb = new ReadingProbResponseDto(testProb.getReadingProb(), isBookmarked);
        this.nextProbId = nextProbId;
    }

}
