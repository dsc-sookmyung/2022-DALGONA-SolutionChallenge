package com.dalgona.zerozone.web.dto.content;

import com.dalgona.zerozone.domain.content.Content;
import com.dalgona.zerozone.domain.content.word.Word;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class WordResponseDto extends Content {

    Long id;
    String word;

    @Builder
    public WordResponseDto(Word word){
        this.id = word.getId();
        this.word = word.getWord();
    }

}
