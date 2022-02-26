package com.dalgona.zerozone.web.dto.bookmark;

import com.dalgona.zerozone.domain.bookmark.BookmarkReadingProb;
import com.dalgona.zerozone.domain.bookmark.BookmarkSpeakingProb;
import com.dalgona.zerozone.domain.content.letter.Letter;
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
public class BookmarkSpeakingProbResponseDto {

    String type;
    String content;
    Long id;

    @Builder
    public BookmarkSpeakingProbResponseDto(Letter letter){
        this.type = "Letter";
        this.content = letter.getLetter();
        this.id = letter.getId();
    }

    @Builder
    public BookmarkSpeakingProbResponseDto(Word word){
        this.type = "Word";
        this.content = word.getWord();
        this.id = word.getId();
    }

    @Builder
    public BookmarkSpeakingProbResponseDto(Sentence sentence){
        this.type = "Sentence";
        this.content = sentence.getSentence();
        this.id = sentence.getId();
    }

    public static BookmarkSpeakingProbResponseDto of(BookmarkSpeakingProb bookmarkSpeakingProb){
        // 글자
        if(bookmarkSpeakingProb.getSpeakingProb().getType().compareTo("letter")==0){
            return new BookmarkSpeakingProbResponseDto(
                    "Letter",
                    bookmarkSpeakingProb.getSpeakingProb().getLetter().getLetter(),
                    bookmarkSpeakingProb.getSpeakingProb().getLetter().getId()
            );
        }
        // 단어
        else if(bookmarkSpeakingProb.getSpeakingProb().getType().compareTo("word")==0){
            return new BookmarkSpeakingProbResponseDto(
                    "Word",
                    bookmarkSpeakingProb.getSpeakingProb().getWord().getWord(),
                    bookmarkSpeakingProb.getSpeakingProb().getWord().getId()
            );
        }
        // 문장
        else if(bookmarkSpeakingProb.getSpeakingProb().getType().compareTo("sentence")==0){
            return new BookmarkSpeakingProbResponseDto(
                    "Sentence",
                    bookmarkSpeakingProb.getSpeakingProb().getSentence().getSentence(),
                    bookmarkSpeakingProb.getSpeakingProb().getSentence().getId()
            );
        }
        else return null;
    }

}
