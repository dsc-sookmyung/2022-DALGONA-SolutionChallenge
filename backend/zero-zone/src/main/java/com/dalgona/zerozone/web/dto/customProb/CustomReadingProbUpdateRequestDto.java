package com.dalgona.zerozone.web.dto.customProb;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class CustomReadingProbUpdateRequestDto {

    Long id;
    String type;
    String content;
    String hint;
    String spacing_info;

}
