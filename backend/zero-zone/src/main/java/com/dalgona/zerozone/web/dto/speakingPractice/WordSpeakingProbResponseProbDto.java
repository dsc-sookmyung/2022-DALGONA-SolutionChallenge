package com.dalgona.zerozone.web.dto.speakingPractice;

import com.dalgona.zerozone.domain.speaking.SpeakingProb;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class WordSpeakingProbResponseProbDto {

    Long probId;
    String type;
    Long wordId;
    String word;
    String url;
    boolean isBookmarked;

    @Builder
    public WordSpeakingProbResponseProbDto(SpeakingProb speakingProb, boolean isBookmarked){
        this.probId = speakingProb.getId();
        this.type = "word";
        this.wordId = speakingProb.getWord().getId();
        this.word = speakingProb.getWord().getWord();
        this.url = speakingProb.getUrl();
        this.isBookmarked = isBookmarked;
    }
}
