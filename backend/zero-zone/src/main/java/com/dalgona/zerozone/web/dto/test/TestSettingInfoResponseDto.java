package com.dalgona.zerozone.web.dto.test;

import lombok.Builder;
import lombok.NoArgsConstructor;

@NoArgsConstructor
public class TestSettingInfoResponseDto {

    int totalTestCount;
    int totalProbCount;

    @Builder
    public TestSettingInfoResponseDto(int totalTestCount, int totalProbCount){
        this.totalTestCount = totalTestCount;
        this.totalProbCount = totalProbCount;
    }

}
