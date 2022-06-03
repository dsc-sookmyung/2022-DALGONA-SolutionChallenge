package com.dalgona.zerozone.service.init;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.List;

@RequiredArgsConstructor
@Service
public class InitService {

    private final AuthorityService authorityService;
    private final CategoryService categoryService;
    private final LetterService letterService;
    private final WordService wordService;
    private final SentenceService sentenceService;
    private final ReadingProbService readingProbService;
    private final SpeakingProbService speakingProbService;

    public void init(){
//        initAuthority();
//        initCategory();
//        initContent();
//        initProb();
    }

    // Authority
    private void initAuthority(){
        authorityService.init();
    }

    // Category : Onset, Nucleus, Coda, Situation
    private void initCategory(){
        categoryService.init();
    }

    // Letter, Word, Sentence
    private void initContent(){
        letterService.init();
        wordService.init();
        sentenceService.init();
    }

    // ReadingProb, SpeakinProb
    private void initProb(){
        readingProbService.init();
        speakingProbService.init();
    }


    
}
