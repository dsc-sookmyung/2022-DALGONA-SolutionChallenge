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
public class RecentReading {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "RECENTREADING_ID")
    private Long id;

    @OneToOne
    private User user;

    @OneToMany(mappedBy = "recentReading")
    private List<RecentReadingProb> recentReadingProbList = new ArrayList<>();

    // 최근 학습 추가
    public void addReadingProb(final RecentReadingProb recentReadingProb){
        recentReadingProbList.add(recentReadingProb);
    }

    // 최근 학습 삭제
    public void deleteReadingProb(final RecentReadingProb recentReadingProb){
        recentReadingProbList.remove(recentReadingProb);
    }

    // 최근 학습 엔티티 생성
    @Builder
    public RecentReading(User user){
        this.user = user;
    }

}
