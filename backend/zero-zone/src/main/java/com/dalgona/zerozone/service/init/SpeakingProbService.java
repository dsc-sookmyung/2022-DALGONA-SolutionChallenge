package com.dalgona.zerozone.service.init;

import com.dalgona.zerozone.domain.content.letter.Letter;
import com.dalgona.zerozone.domain.content.letter.LetterRepository;
import com.dalgona.zerozone.domain.content.sentence.Sentence;
import com.dalgona.zerozone.domain.content.sentence.SentenceRepository;
import com.dalgona.zerozone.domain.content.word.Word;
import com.dalgona.zerozone.domain.content.word.WordRepository;
import com.dalgona.zerozone.domain.speaking.SpeakingProb;
import com.dalgona.zerozone.domain.speaking.SpeakingProbRepository;
import com.dalgona.zerozone.hangulAnalyzer.BucketType;
import com.dalgona.zerozone.hangulAnalyzer.URLEnocder;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@RequiredArgsConstructor
@Service
public class SpeakingProbService {
    private final SpeakingProbRepository speakingProbRepository;
    private final LetterRepository letterRepository;
    private final WordRepository wordRepository;
    private final SentenceRepository sentenceRepository;

    public void init() {
        CSVReader csvReader = new CSVReader();
        List<List<String>> speakingProbs = csvReader.readCSV("/home/minpearl0826/SpeakingProb.csv");
        saveSpeakingProb(speakingProbs);
    }

    private void saveSpeakingProb(List<List<String>> speakingProbs) {
        SpeakingProb speakingProb;
        for(List<String> row : speakingProbs){
            String type = row.get(0);
            String token = row.get(1);
            String url = URLEnocder.generateURLWithTypeAndToken(type, token, BucketType.t_static);

            Letter letter;
            Word word;
            Sentence sentence;

            if(type.compareTo("letter")==0){
                letter = letterRepository.findByLetter(token)
                        .orElseThrow(() -> new IllegalArgumentException(token + ": letter 존재하지 않음"));
                speakingProb = SpeakingProb.builder()
                        .type(type)
                        .url(url)
                        .letter(letter)
                        .build();
                if(!(speakingProbRepository.findByLetter(letter).isPresent()))
                    speakingProbRepository.save(speakingProb);
            }
            else if(type.compareTo("word")==0){
                word = wordRepository.findByWord(token)
                        .orElseThrow(() -> new IllegalArgumentException(token + ": word 존재하지 않음"));
                speakingProb = SpeakingProb.builder()
                        .type(type)
                        .url(url)
                        .word(word)
                        .build();
                if(!(speakingProbRepository.findByWord(word).isPresent()))
                    speakingProbRepository.save(speakingProb);
            }
            else if(type.compareTo("sentence")==0){
                sentence = sentenceRepository.findBySentence(token)
                        .orElseThrow(() -> new IllegalArgumentException(token + ": sentence 존재하지 않음"));
                speakingProb = SpeakingProb.builder()
                        .type(type)
                        .url(url)
                        .sentence(sentence)
                        .build();
                if(!(speakingProbRepository.findBySentence(sentence).isPresent()))
                    speakingProbRepository.save(speakingProb);
            }
        }
    }

}
