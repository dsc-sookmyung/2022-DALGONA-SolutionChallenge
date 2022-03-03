package com.dalgona.zerozone.web.dto.test;

import com.dalgona.zerozone.domain.test.TestProbs;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class TestProbsByTestResponseDto {

    Long testProbId;
    String type;
    String content;
    boolean isCorrect;

    public TestProbsByTestResponseDto(TestProbs testProbs){
        this.testProbId = testProbs.getId();
        String findType = testProbs.getReadingProb().getType();
        if(findType.compareTo("word")==0) {
            this.type = "Word";
            this.content = testProbs.getReadingProb().getWord().getWord();
        }
        else if(findType.compareTo("sentence")==0) {
            this.type = "Sentence";
            this.content = testProbs.getReadingProb().getSentence().getSentence();
        }
        else
            return;
        this.isCorrect = testProbs.isCorrect();
    }

    public static TestProbsByTestResponseDto of(TestProbs testProbs){
        return new TestProbsByTestResponseDto(testProbs);
    }

}
