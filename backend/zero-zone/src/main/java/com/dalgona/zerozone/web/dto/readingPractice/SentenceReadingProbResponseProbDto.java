package com.dalgona.zerozone.web.dto.readingPractice;

import com.dalgona.zerozone.domain.reading.ReadingProb;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class SentenceReadingProbResponseProbDto {

    Long probId;
    String type;
    Long sentenceId;
    String sentence;
    String url;
    String hint;
    String spacingInfo;
    boolean isBookmarked;

    @Builder
    public SentenceReadingProbResponseProbDto(ReadingProb readingProb, boolean isBookmarked){
        this.probId = readingProb.getId();
        this.type = "sentence";
        this.sentenceId = readingProb.getSentence().getId();
        this.sentence = readingProb.getSentence().getSentence();
        this.url = readingProb.getUrl();
        this.hint = readingProb.getHint();
        this.spacingInfo = readingProb.getSpacing_info();
        this.isBookmarked = isBookmarked;
    }

}
