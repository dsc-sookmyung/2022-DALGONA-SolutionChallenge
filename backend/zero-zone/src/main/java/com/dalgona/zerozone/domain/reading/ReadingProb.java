package com.dalgona.zerozone.domain.reading;

import com.dalgona.zerozone.domain.bookmark.BookmarkReadingProb;
import com.dalgona.zerozone.domain.content.sentence.Sentence;
import com.dalgona.zerozone.domain.content.word.Word;
import com.dalgona.zerozone.domain.recent.RecentReadingProb;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class ReadingProb {

    @Id
//    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "READINGPROBS_ID")
    private Long id;

    @Column(length = 20, nullable = false)
    private String type;

    @Column
    private String url;

    @Column(length = 100, nullable = false)
    private String hint;

    @OneToOne
    @JoinColumn(name = "WORD_ID")
    private Word word;

    @OneToOne
    @JoinColumn(name = "SENTENCE_ID")
    private Sentence sentence;

    @OneToMany(mappedBy = "readingProb")
    private List<BookmarkReadingProb> bookmarkReadingList = new ArrayList<>();

    @OneToMany(mappedBy = "readingProb")
    private List<RecentReadingProb> recentReadingList = new ArrayList<>();

}
