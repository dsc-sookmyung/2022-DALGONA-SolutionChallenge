package com.dalgona.zerozone.web.dto.speakingPractice;

import com.dalgona.zerozone.domain.letter.Nucleus;
import com.dalgona.zerozone.domain.letter.Onset;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class CodaRequestDto {

    Long onsetId;
    String onset;
    Long nucleusId;
    String nucleus;

    @Builder
    public CodaRequestDto(Long onsetId, String onset, Long nucleusId, String nucleus){
        this.onsetId=onsetId;
        this.onset=onset;
        this.nucleusId=nucleusId;
        this.nucleus=nucleus;
    }

    public Onset toEntityOnset(){
        return Onset.builder()
                .id(onsetId)
                .onset(onset)
                .build();
    }

    public Nucleus toEntityNucleus(){
        return Nucleus.builder()
                .id(nucleusId)
                .nucleus(nucleus)
                .build();
    }

}
