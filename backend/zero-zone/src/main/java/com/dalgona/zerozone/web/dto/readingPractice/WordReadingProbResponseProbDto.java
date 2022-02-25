package com.dalgona.zerozone.web.dto.readingPractice;

import com.dalgona.zerozone.domain.reading.ReadingProb;
import com.dalgona.zerozone.domain.speaking.SpeakingProb;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class WordReadingProbResponseProbDto {

    Long probId;
    String type;
    Long wordId;
    String word;
    String url;
    String hint;

    @Builder
    public WordReadingProbResponseProbDto(ReadingProb readingProb){
        this.probId = readingProb.getId();
        this.type = "word";
        this.wordId = readingProb.getWord().getId();
        this.word = readingProb.getWord().getWord();
        this.url = readingProb.getUrl();
        this.hint = readingProb.getHint();
    }

}
