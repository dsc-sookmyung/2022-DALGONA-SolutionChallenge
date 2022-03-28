package com.dalgona.zerozone.web.dto.test;

import com.dalgona.zerozone.domain.test.Test;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Getter
@NoArgsConstructor
public class TestListByUserResponseDto {

    Long testId;
    String testName;
    int correctCount;
    int probCount;
    LocalDateTime date;

    public TestListByUserResponseDto(Test test){
        this.testId = test.getId();
        this.testName = test.getTestName();
        this.correctCount = test.getCorrectCount();
        this.probCount = test.getProbsCount();
        this.date = test.getModifiedDate();
    }

    public static TestListByUserResponseDto of(Test test){
        return new TestListByUserResponseDto(test);
    }

}
