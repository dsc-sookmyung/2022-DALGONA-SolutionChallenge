package com.dalgona.zerozone.web.dto.speakingPractice;

import com.dalgona.zerozone.domain.letter.Coda;

import java.util.Comparator;

public class CodasComparator implements Comparator<Coda> {
    @Override
    public int compare(Coda o1, Coda o2) {
        if(o1.getId()>o2.getId()) return 1;
        else return -1;
    }
}
