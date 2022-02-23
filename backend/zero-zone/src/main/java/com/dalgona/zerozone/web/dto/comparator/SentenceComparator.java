package com.dalgona.zerozone.web.dto.comparator;

import com.dalgona.zerozone.domain.sentence.Sentence;

import java.util.Comparator;

public class SentenceComparator implements Comparator<Sentence> {
    @Override
    public int compare(Sentence o1, Sentence o2) {
        if(o1.getId()>o2.getId()) return 1;
        else return -1;
    }
}
