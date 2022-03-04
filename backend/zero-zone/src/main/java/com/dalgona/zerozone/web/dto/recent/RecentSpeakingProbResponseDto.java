package com.dalgona.zerozone.web.dto.recent;

import com.dalgona.zerozone.domain.recent.RecentSpeakingProb;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Builder
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class RecentSpeakingProbResponseDto {

    String type;
    String content;
    Long id;

    public static RecentSpeakingProbResponseDto of(RecentSpeakingProb recentSpeakingProb){
        // 글자
        if(recentSpeakingProb.getSpeakingProb().getType().compareTo("letter")==0){
            return new RecentSpeakingProbResponseDto(
                    "Letter",
                    recentSpeakingProb.getSpeakingProb().getLetter().getLetter(),
                    recentSpeakingProb.getSpeakingProb().getLetter().getId()
            );
        }
        // 단어
        else if(recentSpeakingProb.getSpeakingProb().getType().compareTo("word")==0){
            return new RecentSpeakingProbResponseDto(
                    "Word",
                    recentSpeakingProb.getSpeakingProb().getWord().getWord(),
                    recentSpeakingProb.getSpeakingProb().getWord().getId()
            );
        }
        // 문장
        else if(recentSpeakingProb.getSpeakingProb().getType().compareTo("sentence")==0){
            return new RecentSpeakingProbResponseDto(
                    "Sentence",
                    recentSpeakingProb.getSpeakingProb().getSentence().getSentence(),
                    recentSpeakingProb.getSpeakingProb().getSentence().getId()
            );
        }
        else return null;
    }

}
