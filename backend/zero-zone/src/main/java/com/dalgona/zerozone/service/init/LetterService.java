package com.dalgona.zerozone.service.init;

import com.dalgona.zerozone.domain.content.letter.*;
import com.dalgona.zerozone.hangulAnalyzer.UnicodeHandler;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@RequiredArgsConstructor
@Service
public class LetterService {
    private final LetterRepository letterRepository;
    private final CodaRepository codaRepository;
    private final NucleusRepository nucleusRepository;
    private final OnsetRepository onsetRepository;

    public void init() {
        CSVReader csvReader = new CSVReader();
        List<List<String>> letters = csvReader.readCSV("/home/minpearl0826/Letter.csv");
        saveLetter(letters);
    }
    private void saveLetter(List<List<String>> letters){
        Letter letter;
        for(List<String> row : letters){
            String token = row.get(0);

            List<String> consonant = UnicodeHandler.splitHangeulToConsonant(token);
            
            for(String s : consonant) System.out.println("s = " + s);

            Onset onset = onsetRepository.findByOnset(consonant.get(0))
                    .orElseThrow(() -> new IllegalArgumentException(token + ": onset 존재하지 않음"));
            Nucleus nucleus = nucleusRepository.findByNucleus(consonant.get(1))
                    .orElseThrow(() -> new IllegalArgumentException(token + ": nucleus 존재하지 않음"));
            Optional<Coda> optionalCoda = codaRepository.findByCoda(consonant.get(2));
            Coda coda;
            if(!optionalCoda.isPresent()){
                coda = codaRepository.findByCoda("null")
                        .orElseThrow(() -> new IllegalArgumentException("종성 테이블에 null이 존재하지 않음"));
            }else{
                coda = optionalCoda.get();
            }

            letter = Letter.builder()
                    .onset(onset)
                    .nucleus(nucleus)
                    .coda(coda)
                    .letter(token)
                    .build();

            if(!(letterRepository.findByLetter(token).isPresent()))
                letterRepository.save(letter);
        }

    }
}