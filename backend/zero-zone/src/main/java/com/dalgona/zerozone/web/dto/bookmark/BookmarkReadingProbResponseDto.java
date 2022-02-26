package com.dalgona.zerozone.web.dto.bookmark;

import com.dalgona.zerozone.domain.bookmark.BookmarkReadingProb;
import com.dalgona.zerozone.domain.content.sentence.Sentence;
import com.dalgona.zerozone.domain.content.word.Word;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Builder
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class BookmarkReadingProbResponseDto {

    String type;
    String content;
    Long id;

    @Builder
    public BookmarkReadingProbResponseDto(Word word){
        this.type = "Word";
        this.content = word.getWord();
        this.id = word.getId();
    }

    @Builder
    public BookmarkReadingProbResponseDto(Sentence sentence){
        this.type = "Sentence";
        this.content = sentence.getSentence();
        this.id = sentence.getId();
    }

    public static BookmarkReadingProbResponseDto of(BookmarkReadingProb bookmarkReadingProb){
        // 단어
        if(bookmarkReadingProb.getReadingProb().getType().compareTo("word")==0){
            return new BookmarkReadingProbResponseDto(
                    "word",
                    bookmarkReadingProb.getReadingProb().getWord().getWord(),
                    bookmarkReadingProb.getReadingProb().getWord().getId()
                    );
        }
        // 문장
        else if(bookmarkReadingProb.getReadingProb().getType().compareTo("sentence")==0){
            return new BookmarkReadingProbResponseDto(
                    "sentence",
                    bookmarkReadingProb.getReadingProb().getSentence().getSentence(),
                    bookmarkReadingProb.getReadingProb().getSentence().getId()
            );
        }
        else return null;
    }

}
