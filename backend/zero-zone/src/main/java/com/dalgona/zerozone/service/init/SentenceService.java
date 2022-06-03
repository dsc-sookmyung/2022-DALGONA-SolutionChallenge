package com.dalgona.zerozone.service.init;

import com.dalgona.zerozone.domain.content.sentence.Sentence;
import com.dalgona.zerozone.domain.content.sentence.SentenceRepository;
import com.dalgona.zerozone.domain.content.sentence.Situation;
import com.dalgona.zerozone.domain.content.sentence.SituationRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@RequiredArgsConstructor
@Service
public class SentenceService {
    private final SentenceRepository sentenceRepository;
    private final SituationRepository situationRepository;

    public void init() {
        CSVReader csvReader = new CSVReader();
        List<List<String>> sentences = csvReader.readCSV("/home/minpearl0826/Sentence.csv");
        saveSentence(sentences);
    }

    private void saveSentence(List<List<String>> sentences) {
        Sentence sentence;
        for(List<String> row : sentences){
            String token = row.get(0);
            Situation situation = situationRepository.findBySituation(row.get(1))
                    .orElseThrow(() -> new IllegalArgumentException(token + ": situation 존재하지 않음"));

            sentence = Sentence.builder()
                    .situation(situation)
                    .sentence(token)
                    .build();

            if(!(sentenceRepository.findBySentence(token).isPresent()))
                sentenceRepository.save(sentence);
        }
    }

}
