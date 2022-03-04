package com.dalgona.zerozone.web.dto.recent;

import com.dalgona.zerozone.domain.recent.RecentReadingProb;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Builder
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class RecentReadingProbResponseDto {

    String type;
    String content;
    Long id;

    public static RecentReadingProbResponseDto of(RecentReadingProb recentReadingProb){
        // 단어
        if(recentReadingProb.getReadingProb().getType().compareTo("word")==0){
            return new RecentReadingProbResponseDto(
                    "Word",
                    recentReadingProb.getReadingProb().getWord().getWord(),
                    recentReadingProb.getReadingProb().getWord().getId()
            );
        }
        // 문장
        else if(recentReadingProb.getReadingProb().getType().compareTo("sentence")==0){
            return new RecentReadingProbResponseDto(
                    "Sentence",
                    recentReadingProb.getReadingProb().getSentence().getSentence(),
                    recentReadingProb.getReadingProb().getSentence().getId()
            );
        }
        else return null;
    }

}
