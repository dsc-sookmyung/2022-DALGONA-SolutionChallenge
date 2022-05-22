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

    public static BookmarkReadingProbResponseDto of(BookmarkReadingProb bookmarkReadingProb){
        // 단어
        if(bookmarkReadingProb.getReadingProb().getType().compareTo("word")==0){
            return new BookmarkReadingProbResponseDto(
                    "Word",
                    bookmarkReadingProb.getReadingProb().getWord().getWord(),
                    bookmarkReadingProb.getReadingProb().getWord().getId()
                    );
        }
        // 문장
        else if(bookmarkReadingProb.getReadingProb().getType().compareTo("sentence")==0){
            return new BookmarkReadingProbResponseDto(
                    "Sentence",
                    bookmarkReadingProb.getReadingProb().getSentence().getSentence(),
                    bookmarkReadingProb.getReadingProb().getSentence().getId()
            );
        }
        else return null;
    }

}
