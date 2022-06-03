package com.dalgona.zerozone.service.init;

import com.dalgona.zerozone.domain.content.sentence.Sentence;
import com.dalgona.zerozone.domain.content.sentence.SentenceRepository;
import com.dalgona.zerozone.domain.content.word.Word;
import com.dalgona.zerozone.domain.content.word.WordRepository;
import com.dalgona.zerozone.domain.reading.ReadingProb;
import com.dalgona.zerozone.domain.reading.ReadingProbRepository;
import com.dalgona.zerozone.hangulAnalyzer.BucketType;
import com.dalgona.zerozone.hangulAnalyzer.SpacingInfoCreator;
import com.dalgona.zerozone.hangulAnalyzer.URLEnocder;
import com.dalgona.zerozone.hangulAnalyzer.UnicodeHandler;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@RequiredArgsConstructor
@Service
public class ReadingProbService {
    private final ReadingProbRepository readingProbRepository;
    private final WordRepository wordRepository;
    private final SentenceRepository sentenceRepository;


    public void init() {
        CSVReader csvReader = new CSVReader();
        List<List<String>> readingProbs = csvReader.readCSV("/home/minpearl0826/ReadingProb.csv"); // contents/ReadingProb.csv
        saveReadingProb(readingProbs);
    }

    private void saveReadingProb(List<List<String>> readingProbs) {
        ReadingProb readingProb;
        for (List<String> row : readingProbs) {
            String type = row.get(0);
            String token = row.get(1);
            String hint = UnicodeHandler.splitHangeulToOnsetAsString(token);
            String url = URLEnocder.generateURLWithTypeAndToken(type, token, BucketType.t_static);

            Word word;
            Sentence sentence;

            if (type.compareTo("word") == 0) {
                word = wordRepository.findByWord(token)
                        .orElseThrow(() -> new IllegalArgumentException(token + ": word 존재하지 않음"));
                readingProb = ReadingProb.builder()
                        .type(type)
                        .hint(hint)
                        .spacing_info("")
                        .url(url)
                        .word(word)
                        .build();
                if (!(readingProbRepository.findByWord(word).isPresent()))
                    readingProbRepository.save(readingProb);
            } else if (type.compareTo("sentence") == 0) {
                sentence = sentenceRepository.findBySentence(token)
                        .orElseThrow(() -> new IllegalArgumentException(token + ": sentence 존재하지 않음"));
                readingProb = ReadingProb.builder()
                        .type(type)
                        .hint(hint)
                        .spacing_info(SpacingInfoCreator.createSpacingInfo(token))
                        .url(url)
                        .sentence(sentence)
                        .build();
                if (!(readingProbRepository.findBySentence(sentence).isPresent()))
                    readingProbRepository.save(readingProb);

            }
        }
    }
}
