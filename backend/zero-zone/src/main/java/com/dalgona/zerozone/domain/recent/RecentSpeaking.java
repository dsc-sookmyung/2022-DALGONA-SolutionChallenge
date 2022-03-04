package com.dalgona.zerozone.domain.recent;

import com.dalgona.zerozone.domain.user.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class RecentSpeaking {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "RecentSpeaking_id")
    private Long id;

    @OneToOne
    private User user;

    @OneToMany(mappedBy = "recentSpeaking")
    private List<RecentSpeakingProb> recentSpeakigProbList = new ArrayList<>();

    // 최근 학습 추가
    public void addSpeakingProb(final RecentSpeakingProb recentSpeakingProb){
        recentSpeakigProbList.add(recentSpeakingProb);
    }

    // 최근 학습 삭제
    public void deleteSpeakingProb(final RecentSpeakingProb recentSpeakingProb){
        recentSpeakigProbList.remove(recentSpeakingProb);
    }

    // 최근 학습 엔티티 생성
    @Builder
    public RecentSpeaking(User user){
        this.user = user;
    }
}
