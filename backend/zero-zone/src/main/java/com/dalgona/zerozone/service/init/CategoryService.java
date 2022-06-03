package com.dalgona.zerozone.service.init;

import com.dalgona.zerozone.domain.content.letter.*;
import com.dalgona.zerozone.domain.content.sentence.Situation;
import com.dalgona.zerozone.domain.content.sentence.SituationRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@RequiredArgsConstructor
@Service
public class CategoryService {

    private final OnsetRepository onsetRepository;
    private final NucleusRepository nucleusRepository;
    private final CodaRepository codaRepository;
    private final SituationRepository situationRepository;

    public void init() {
        // csv로부터 초성 읽어오기
        initOnset();
        initNucleus();
        initCoda();
        initSituation();
    }

    private void initOnset(){
        CSVReader csvReader = new CSVReader();
        List<List<String>> onsets = csvReader.readCSV("/home/minpearl0826/Onset.csv");
        saveOnset(onsets);
    }

    private void saveOnset(List<List<String>> onsets){
        Onset onset;
        for(List<String> row : onsets){
            Long id = Long.parseLong(row.get(0));
            String token = row.get(1);
            onset = Onset.builder().id(id).onset(token).build();
            if(!(onsetRepository.findById(id).isPresent()))
                onsetRepository.save(onset);
        }
    }

    private void initNucleus(){
        CSVReader csvReader = new CSVReader();
        List<List<String>> nucleuses = csvReader.readCSV("/home/minpearl0826/Nucleus.csv");
        saveNucleus(nucleuses);
    }

    private void saveNucleus(List<List<String>> nucleuses){
        Nucleus nucleus;
        for(List<String> row : nucleuses){
            Long id = Long.parseLong(row.get(0));
            String token = row.get(1);
            nucleus = Nucleus.builder().id(id).nucleus(token).build();
            if(!(nucleusRepository.findById(id).isPresent()))
                nucleusRepository.save(nucleus);
        }
    }

    private void initCoda(){
        CSVReader csvReader = new CSVReader();
        List<List<String>> codas = csvReader.readCSV("/home/minpearl0826/Coda.csv");
        saveCodas(codas);
    }

    private void saveCodas(List<List<String>> codas){
        Coda coda;
        for(List<String> row : codas){
            Long id = Long.parseLong(row.get(0));
            String token = row.get(1);
            coda = Coda.builder().id(id).coda(token).build();
            if(!(codaRepository.findById(id).isPresent()))
                codaRepository.save(coda);
        }
    }

    private void initSituation(){
        CSVReader csvReader = new CSVReader();
        List<List<String>> situations = csvReader.readCSV("/home/minpearl0826/Situation.csv");
        saveSituations(situations);
    }

    private void saveSituations(List<List<String>> situations){
        Situation situation;
        for(List<String> row : situations){
            Long id = Long.parseLong(row.get(0));
            String token = row.get(1);
            situation = Situation.builder().id(id).situation(token).build();
            if(!(situationRepository.findById(id).isPresent()))
                situationRepository.save(situation);
        }
    }



}