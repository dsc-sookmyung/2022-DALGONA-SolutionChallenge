package com.dalgona.zerozone.domain.recent;

import com.dalgona.zerozone.domain.reading.ReadingProb;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class RecentReadingProb {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "RECENTREADINGPROB_ID")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "recentReading_id")
    private RecentReading recentReading;

    @ManyToOne
    @JoinColumn(name = "readingProb_id")
    private ReadingProb readingProb;

    @Builder
    public RecentReadingProb(RecentReading recentReading, ReadingProb readingProb){
        this.recentReading = recentReading;
        this.readingProb = readingProb;
    }

    // 객체 비교 함수
    @Override
    public boolean equals(Object object) {
        RecentReadingProb findRecentReadingProb = (RecentReadingProb) object;
        ReadingProb findReadingProb = findRecentReadingProb.getReadingProb();
        // 타입과 일련번호가 동일하면 동일한 객체
        if (findReadingProb.getId() == this.readingProb.getId() &&
                (findReadingProb.getType().compareTo(this.readingProb.getType())==0)) {
            return true;
        }
        return false;
    }

}
