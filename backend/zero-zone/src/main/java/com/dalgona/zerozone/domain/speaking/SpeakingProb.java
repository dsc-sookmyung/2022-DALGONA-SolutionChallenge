package com.dalgona.zerozone.domain.speaking;

import com.dalgona.zerozone.domain.bookmark.BookmarkSpeakingProb;
import com.dalgona.zerozone.domain.content.letter.Letter;
import com.dalgona.zerozone.domain.content.sentence.Sentence;
import com.dalgona.zerozone.domain.content.word.Word;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.lang.invoke.CallSite;
import java.util.ArrayList;
import java.util.List;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Builder
public class SpeakingProb {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "SPEAKINGPROBS_ID")
    private Long id;

    @Column(length = 20, nullable = false)
    private String type;

    @Column
    private String url;

    @OneToOne
    @JoinColumn(name = "LETTER_ID")
    private Letter letter;

    @OneToOne
    @JoinColumn(name = "WORD_ID")
    private Word word;

    @OneToOne
    @JoinColumn(name = "SENTENCE_ID")
    private Sentence sentence;

    @OneToMany(mappedBy = "speakingProb")
    private List<BookmarkSpeakingProb> bookmarkSpeakingProbList = new ArrayList<>();

}
