package com.dalgona.zerozone.web.dto.test;

import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.List;

@Getter
@NoArgsConstructor
public class TestResultUpdateDto {
    Long testId;
    List<TestResult> testResultList;
    int correctCount;
}
