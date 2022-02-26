package com.dalgona.zerozone.domain.bookmark;

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
public class BookmarkReadingProb {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "BOOKMARKREADINGPROB_ID")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "bookmarkReading_id")
    private BookmarkReading bookmarkReading;

    @ManyToOne
    @JoinColumn(name = "readingProb_id")
    private ReadingProb readingProb;

    @Builder
    public BookmarkReadingProb(BookmarkReading bookmarkReading, ReadingProb readingProb){
        this.bookmarkReading = bookmarkReading;
        this.readingProb = readingProb;
    }

    @Override
    public boolean equals(Object object) {
        BookmarkReadingProb findBookmarkReadingProb = (BookmarkReadingProb) object;
        ReadingProb findReadingProb = findBookmarkReadingProb.getReadingProb();
        // 타입과 일련번호가 동일하면 동일한 객체
        if (findReadingProb.getId() == this.readingProb.getId() &&
                (findReadingProb.getType().compareTo(this.readingProb.getType())==0)) {
            return true;
        }
        return false;
    }

}
