package com.dalgona.zerozone.domain.recent;

import com.dalgona.zerozone.domain.speaking.SpeakingProb;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class RecentSpeakingProb {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "RECENTSPEAKINGPROB_ID")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "recentSpeaking_id")
    private RecentSpeaking recentSpeaking;

    @ManyToOne
    @JoinColumn(name = "speakingProb_id")
    private SpeakingProb speakingProb;

    @Builder
    public RecentSpeakingProb(RecentSpeaking recentSpeaking, SpeakingProb speakingProb){
        this.recentSpeaking = recentSpeaking;
        this.speakingProb = speakingProb;
    }

    // 객체 비교 함수
    @Override
    public boolean equals(Object object) {
        RecentSpeakingProb findRecentSpeakingProb = (RecentSpeakingProb) object;
        SpeakingProb findSpeakingProb = findRecentSpeakingProb.getSpeakingProb();
        // 타입과 일련번호가 동일하면 동일한 객체
        if (findSpeakingProb.getId() == this.speakingProb.getId() &&
                (findSpeakingProb.getType().compareTo(this.speakingProb.getType())==0)) {
            return true;
        }
        return false;
    }

}
