package com.dalgona.zerozone.web.dto.speakingPractice;

import com.dalgona.zerozone.domain.letter.Onset;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class WordRequestDto {

    Long onsetId;
    String onset;

    @Builder
    public WordRequestDto(Long onsetId, String onset){
        this.onsetId=onsetId;
        this.onset=onset;
    }

    public Onset toEntity(){
        return Onset.builder()
                .id(onsetId)
                .onset(onset)
                .build();
    }

}
