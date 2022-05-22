package com.dalgona.zerozone.web.dto.content;

import com.dalgona.zerozone.domain.content.Content;
import com.dalgona.zerozone.domain.content.letter.Letter;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class LetterResponseDto extends Content {

    Long id;
    String coda;
    Long letterId;
    String letter;

    @Builder
    public LetterResponseDto(Letter letter){
        this.id = letter.getCoda().getId();
        this.coda = letter.getCoda().getCoda();
        this.letterId = letter.getId();
        this.letter = letter.getLetter();
    }

}
