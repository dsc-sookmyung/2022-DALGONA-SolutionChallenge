package com.dalgona.zerozone.web.dto.speakingPractice;

import com.dalgona.zerozone.domain.speaking.SpeakingProb;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class SentenceSpeakingProbResponseDto {

    Long probId;
    String type;
    Long sentenceId;
    String sentence;
    String url;
    boolean isBookmarked;

    @Builder
    public SentenceSpeakingProbResponseDto(SpeakingProb speakingProb, boolean isBookmarked){
        this.probId = speakingProb.getId();
        this.type = "sentence";
        this.sentenceId = speakingProb.getSentence().getId();
        this.sentence = speakingProb.getSentence().getSentence();
        this.url = speakingProb.getUrl();
        this.isBookmarked = isBookmarked();
    }
}
