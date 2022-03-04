package com.dalgona.zerozone.web.dto.test;

import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class TestNameUpdateRequestDto {
    Long testId;
    String newTestName;
}
