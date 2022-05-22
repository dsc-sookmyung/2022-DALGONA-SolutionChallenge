package com.dalgona.zerozone.domain.reading;

import com.dalgona.zerozone.domain.bookmark.BookmarkReadingProb;
import com.dalgona.zerozone.domain.staticContent.sentence.Sentence;
import com.dalgona.zerozone.domain.staticContent.word.Word;
import com.dalgona.zerozone.domain.recent.RecentReadingProb;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

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

    @Column(length = 100)
    private String hint;

    @Column(length = 100)
    private String spacing_info;

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

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        ReadingProb that = (ReadingProb) o;
        boolean is_same = id.equals(that.id) && Objects.equals(type, that.type) && word.equals(that.word) && Objects.equals(sentence, that.sentence);
        return is_same;
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, type, url, hint, spacing_info, word, sentence, bookmarkReadingList, recentReadingList);
    }
}
