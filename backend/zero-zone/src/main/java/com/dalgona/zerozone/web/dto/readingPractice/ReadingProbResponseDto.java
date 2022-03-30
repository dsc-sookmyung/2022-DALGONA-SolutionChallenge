package com.dalgona.zerozone.web.dto.readingPractice;

import com.dalgona.zerozone.domain.reading.ReadingProb;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class ReadingProbResponseDto {

    Long probId;
    String type;
    Long contentId;
    String content;
    String url;
    String hint;
    String spacingInfo;
    boolean isBookmarked;

    @Builder
    public ReadingProbResponseDto(ReadingProb readingProb, boolean isBookmarked){
        this.probId = readingProb.getId();
        this.type = readingProb.getType();
        if(type.compareTo("word")==0) {
            this.contentId = readingProb.getWord().getId();
            this.content = readingProb.getWord().getWord();
        }
        else if(type.compareTo("sentence")==0) {
            this.contentId = readingProb.getSentence().getId();
            this.content = readingProb.getSentence().getSentence();
        }
        else
            return;
        this.url = readingProb.getUrl();
        this.hint = readingProb.getHint();
        this.spacingInfo = readingProb.getSpacing_info();
        this.isBookmarked = isBookmarked;
    }

}
