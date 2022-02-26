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
public class BookmarkReading {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "BOOKMARKREADING_ID")
    private Long id;

    @OneToOne
    private User user;

    @OneToMany(mappedBy = "bookmarkReading")
    private List<BookmarkReadingProb> bookmarkReadingList = new ArrayList<>();

    // 북마크 추가
    public void addReadingProb(final BookmarkReadingProb bookmarkReadingProb){
        bookmarkReadingList.add(bookmarkReadingProb);
    }

    // 북마크 삭제
    public void deleteReadingProb(final BookmarkReadingProb bookmarkReadingProb){
        bookmarkReadingList.remove(bookmarkReadingProb);
    }

    @Builder
    public BookmarkReading(User user){
        this.user = user;
        this.bookmarkReadingList = new ArrayList<>();
    }

}
