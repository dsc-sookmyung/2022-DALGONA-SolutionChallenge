package com.dalgona.zerozone.web.dto.test;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
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
