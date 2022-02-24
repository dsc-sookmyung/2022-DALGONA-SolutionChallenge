package com.dalgona.zerozone.web.dto.speakingPractice;

import com.dalgona.zerozone.domain.speaking.SpeakingProb;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class LetterProbResponseDto {

    Long probId;
    String type;
    Long letterId;
    String letter;
    String url;
    String hint;

    @Builder
    public LetterProbResponseDto(SpeakingProb speakingProb){
        this.probId = speakingProb.getId();
        this.type = "letter";
        this.letterId = speakingProb.getLetter().getId();
        this.letter = speakingProb.getLetter().getLetter();
        this.url = speakingProb.getUrl();
        this.hint = speakingProb.getHint();
    }

}
