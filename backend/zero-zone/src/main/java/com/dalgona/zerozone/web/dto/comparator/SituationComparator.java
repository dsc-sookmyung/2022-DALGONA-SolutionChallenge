package com.dalgona.zerozone.web.dto.comparator;

import com.dalgona.zerozone.domain.letter.Coda;
import com.dalgona.zerozone.domain.sentence.Situation;

import java.util.Comparator;

public class SituationComparator implements Comparator<Situation> {
    @Override
    public int compare(Situation o1, Situation o2) {
        if(o1.getId()>o2.getId()) return 1;
        else return -1;
    }
}
