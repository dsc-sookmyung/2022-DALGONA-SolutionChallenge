package com.dalgona.zerozone.service.init;

import com.dalgona.zerozone.domain.content.letter.Onset;
import com.dalgona.zerozone.domain.content.letter.OnsetRepository;
import com.dalgona.zerozone.domain.content.word.Word;
import com.dalgona.zerozone.domain.content.word.WordRepository;
import com.dalgona.zerozone.hangulAnalyzer.UnicodeHandler;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@RequiredArgsConstructor
@Service
public class WordService {
    private final WordRepository wordRepository;
    private final OnsetRepository onsetRepository;

    public void init() {
        CSVReader csvReader = new CSVReader();
        List<List<String>> words = csvReader.readCSV("/home/minpearl0826/Word.csv");
        saveWord(words);
    }

    private void saveWord(List<List<String>> words){
        Word word;
        for(List<String> row : words){
            String token = row.get(0);

            String firstLetter = ""+token.charAt(0);
            String extractedOnset = UnicodeHandler.splitHangeulToOnsetAsString(firstLetter);

            Optional<Onset> optionalOnset = onsetRepository.findByOnset(extractedOnset);
            Onset onset;
            // 초성이 없는 문자열이면 ㅇ으로 분류한다
            if(!optionalOnset.isPresent()){
                onset = onsetRepository.findByOnset("ㅇ")
                        .orElseThrow(() -> new IllegalArgumentException("초성 테이블에 ㅇ이 존재하지 않음"));
            }else{
                onset = optionalOnset.get();
            }

            word = Word.builder()
                    .onset(onset)
                    .word(token)
                    .build();

            if(!(wordRepository.findByWord(token).isPresent()))
                wordRepository.save(word);
        }
    }


}
