package com.dalgona.zerozone.web.dto.customProb;

import com.dalgona.zerozone.domain.customProbs.customSpeaking.CustomSpeakingProb;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class CustomSpeakingProbResponseDto {

    private Long probId;
    private String type;
    private String content;
    private String url;

    @Builder
    public CustomSpeakingProbResponseDto(CustomSpeakingProb customSpeakingProb){
        this.probId = customSpeakingProb.getId();
        this.type = customSpeakingProb.getType();
        this.content = customSpeakingProb.getContent();
        this.url = customSpeakingProb.getUrl();
    }

    public static CustomSpeakingProbResponseDto of(CustomSpeakingProb customSpeakingProb){
        // 단어
        if(customSpeakingProb.getType().compareTo("word")==0){
            return new CustomSpeakingProbResponseDto(
                    customSpeakingProb.getId(),
                    "Word",
                    customSpeakingProb.getContent(),
                    customSpeakingProb.getUrl()
            );
        }
        // 문장
        else if(customSpeakingProb.getType().compareTo("sentence")==0){
            return new CustomSpeakingProbResponseDto(
                    customSpeakingProb.getId(),
                    "Sentence",
                    customSpeakingProb.getContent(),
                    customSpeakingProb.getUrl()
            );
        }
        else return null;
    }

}
