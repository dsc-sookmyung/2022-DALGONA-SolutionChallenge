package com.dalgona.zerozone.web.dto.test;

import com.dalgona.zerozone.web.dto.readingPractice.ReadingProbResponseDto;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.List;

@Getter
@NoArgsConstructor
public class TestCreateResponseDto {

    Long id;
    String testName;
    List<ReadingProbResponseDto> readingProbResponseDtoList;

    public TestCreateResponseDto(Long id, String testName, List<ReadingProbResponseDto> readingProbResponseDtoList){
        this.id = id;
        this.testName = testName;
        this.readingProbResponseDtoList = readingProbResponseDtoList;
    }

}
