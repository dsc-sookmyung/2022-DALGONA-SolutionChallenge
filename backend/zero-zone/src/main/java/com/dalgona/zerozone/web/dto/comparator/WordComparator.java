package com.dalgona.zerozone.web.dto.comparator;

import com.dalgona.zerozone.domain.letter.Coda;
import com.dalgona.zerozone.domain.word.Word;

import java.util.Comparator;

public class WordComparator implements Comparator<Word> {
    @Override
    public int compare(Word o1, Word o2) {
        if(o1.getId()>o2.getId()) return 1;
        else return -1;
    }
}
