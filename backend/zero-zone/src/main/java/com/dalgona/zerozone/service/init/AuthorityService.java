package com.dalgona.zerozone.service.init;

import com.dalgona.zerozone.domain.user.Authority;
import com.dalgona.zerozone.domain.user.AuthorityRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@RequiredArgsConstructor
@Service
public class AuthorityService {
    private final AuthorityRepository authorityRepository;

    public void init() {
        CSVReader csvReader = new CSVReader();
        List<List<String>> authorities = csvReader.readCSV("/home/minpearl0826/Authority.csv");
        saveSpeakingProb(authorities);
    }

    private void saveSpeakingProb(List<List<String>> authorities) {
        Authority authority;
        for(List<String> row : authorities){
            String token = row.get(0);
            authority = Authority.builder()
                    .authorityName(token)
                    .build();

            if(!(authorityRepository.findByAuthorityName(token).isPresent()))
                authorityRepository.save(authority);
        }

    }

}
