package com.dalgona.zerozone.domain.bookmark;

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
public class BookmarkSpeakingProb {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "BOOKMARKSPEAKINGPROB_ID")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "bookmarkSpeaking_id")
    private BookmarkSpeaking bookmarkSpeaking;

    @ManyToOne
    @JoinColumn(name = "speakingProb_id")
    private SpeakingProb speakingProb;

    @Builder
    public BookmarkSpeakingProb(BookmarkSpeaking bookmarkSpeaking, SpeakingProb speakingProb){
        this.bookmarkSpeaking = bookmarkSpeaking;
        this.speakingProb = speakingProb;
    }

    @Override
    public boolean equals(Object object) {
        BookmarkSpeakingProb findBookmarkSpeakingProb = (BookmarkSpeakingProb) object;
        SpeakingProb findSpeakingProb = findBookmarkSpeakingProb.getSpeakingProb();
        // 타입과 일련번호가 동일하면 동일한 객체
        if (findSpeakingProb.getId() == this.speakingProb.getId() &&
                (findSpeakingProb.getType().compareTo(this.speakingProb.getType())==0)) {
            return true;
        }
        return false;
    }

}
