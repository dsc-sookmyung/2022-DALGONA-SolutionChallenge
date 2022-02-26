package com.dalgona.zerozone.domain.bookmark;

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
public class BookmarkSpeaking {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "BOOKMARKSPEAKING_ID")
    private Long id;

    @OneToOne
    private User user;

    @OneToMany(mappedBy = "bookmarkSpeaking")
    private List<BookmarkSpeakingProb> bookmarkSpeakingList = new ArrayList<>();

    // 북마크 추가
    public void addSpeakingProb(final BookmarkSpeakingProb bookmarkSpeakingProb){
        bookmarkSpeakingList.add(bookmarkSpeakingProb);
    }

    // 북마크 삭제
    public void deleteSpeakingProb(final BookmarkSpeakingProb bookmarkSpeakingProb){
        bookmarkSpeakingList.remove(bookmarkSpeakingProb);
    }

    @Builder
    public BookmarkSpeaking(User user){
        this.user = user;
        this.bookmarkSpeakingList = new ArrayList<>();
    }

}
