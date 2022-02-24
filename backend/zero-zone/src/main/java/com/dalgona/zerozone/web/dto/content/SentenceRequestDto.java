package com.dalgona.zerozone.web.dto.content;

import com.dalgona.zerozone.domain.content.sentence.Situation;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class SentenceRequestDto {

    Long situationId;
    String situation;

    @Builder
    public SentenceRequestDto(Long situationId, String situation){
        this.situationId=situationId;
        this.situation=situation;
    }

    public Situation toEntity(){
        return Situation.builder()
                .id(situationId)
                .situation(situation)
                .build();
    }

}
