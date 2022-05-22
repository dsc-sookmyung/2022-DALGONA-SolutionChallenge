package com.dalgona.zerozone.web.dto.customProb;

import com.dalgona.zerozone.domain.customProbs.customReading.CustomReadingProb;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class CustomReadingProbResponseDto {

    private Long probId;
    private String type;
    private String content;
    private String url;
    private String hint;
    private String spacing_info;

    @Builder
    public CustomReadingProbResponseDto(CustomReadingProb customReadingProb){
        this.probId = customReadingProb.getId();
        this.type = customReadingProb.getType();
        this.content = customReadingProb.getContent();
        this.url = customReadingProb.getUrl();
        this.hint = customReadingProb.getHint();
        this.spacing_info = customReadingProb.getSpacing_info();
    }

    public static CustomReadingProbResponseDto of(CustomReadingProb customReadingProb){
        // 단어
        if(customReadingProb.getType().compareTo("word")==0){
            return new CustomReadingProbResponseDto(
                    customReadingProb.getId(),
                    "Word",
                    customReadingProb.getContent(),
                    customReadingProb.getUrl(),
                    customReadingProb.getHint(),
                    customReadingProb.getSpacing_info()
            );
        }
        // 문장
        else if(customReadingProb.getType().compareTo("sentence")==0){
            return new CustomReadingProbResponseDto(
                    customReadingProb.getId(),
                    "Sentence",
                    customReadingProb.getContent(),
                    customReadingProb.getUrl(),
                    customReadingProb.getHint(),
                    customReadingProb.getSpacing_info()
            );
        }
        else return null;
    }

}
