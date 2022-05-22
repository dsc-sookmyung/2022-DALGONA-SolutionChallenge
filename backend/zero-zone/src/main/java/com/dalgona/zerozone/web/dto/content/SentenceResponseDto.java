package com.dalgona.zerozone.web.dto.content;

import com.dalgona.zerozone.domain.staticContent.Content;
import com.dalgona.zerozone.domain.staticContent.sentence.Sentence;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class SentenceResponseDto extends Content {

    Long id;
    String sentence;

    @Builder
    public SentenceResponseDto(Sentence sentence){
        this.id = sentence.getId();
        this.sentence = sentence.getSentence();
    }

}
