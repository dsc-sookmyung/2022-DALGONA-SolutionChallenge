package com.dalgona.zerozone.web.dto.comparator;

import com.dalgona.zerozone.domain.content.Content;

import java.util.Comparator;

public class ContentComparator implements Comparator<Content> {
    @Override
    public int compare(Content o1, Content o2) {
        if(o1.getId()>o2.getId()) return 1;
        else return -1;
    }
}
