package com.dalgona.zerozone.web.dto.comparator;

import com.dalgona.zerozone.domain.letter.Nucleus;

import java.util.Comparator;

public class NucleusComparator implements Comparator<Nucleus> {

    @Override
    public int compare(Nucleus o1, Nucleus o2) {
        if(o1.getId()>o2.getId()) return 1;
        else return -1;
    }
}
