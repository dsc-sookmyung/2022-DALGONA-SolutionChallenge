package com.dalgona.zerozone.service.customProb;

import com.dalgona.zerozone.domain.customProbs.customReading.CustomReadingProb;
import com.dalgona.zerozone.domain.customProbs.customSpeaking.CustomSpeakingProb;
import com.dalgona.zerozone.domain.customProbs.customSpeaking.CustomSpeakingProbRepository;
import com.dalgona.zerozone.domain.user.User;
import com.dalgona.zerozone.domain.user.UserRepository;
import com.dalgona.zerozone.hangulAnalyzer.BucketType;
import com.dalgona.zerozone.hangulAnalyzer.URLEnocder;
import com.dalgona.zerozone.jwt.SecurityUtil;
import com.dalgona.zerozone.web.dto.Response;
import com.dalgona.zerozone.web.dto.customProb.CustomReadingProbResponseDto;
import com.dalgona.zerozone.web.dto.customProb.CustomSpeakingProbResponseDto;
import com.dalgona.zerozone.web.dto.customProb.CustomSpeakingProbSaveRequestDto;
import com.dalgona.zerozone.web.dto.customProb.CustomSpeakingProbUpdateRequestDto;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@RequiredArgsConstructor
@Service
public class CustomSpeakingProbService {

    private final UserRepository userRepository;
    private final CustomSpeakingProbRepository customSpeakingProbRepository;

    private final Response response;

    private User getCurrentUser(){
        return SecurityUtil.getCurrentUsername().flatMap(userRepository::findByEmail).orElse(null);
    }
    private boolean isNotValidForProb(User user) {
        User currentUser = getCurrentUser();
        return !currentUser.equals(user);
    }

    @Transactional
    public ResponseEntity<?> createCustomSpeakingProb(CustomSpeakingProbSaveRequestDto requestDto) {
        User user = getCurrentUser();
        String url = URLEnocder.generateURLWithTypeAndToken(requestDto.getType(), requestDto.getContent(), BucketType.t_custom);
        requestDto.setUser(user);
        requestDto.setUrl(url);
        CustomSpeakingProb customSpeakingProb;
        try {
            customSpeakingProb = customSpeakingProbRepository.save(requestDto.toEntity());
        }catch (IllegalArgumentException e){
            return response.fail("?????? ?????? ????????? ??????????????????.", HttpStatus.NOT_ACCEPTABLE);
        }
        CustomSpeakingProbResponseDto responseDto = new CustomSpeakingProbResponseDto(customSpeakingProb);
        return response.success(responseDto, "?????? ?????? ????????? ??????????????????.", HttpStatus.OK);
    }

    @Transactional
    public ResponseEntity<?> getCustomSpeakingProbs() {
        User user = getCurrentUser();
        List<CustomSpeakingProb> customSpeakingProbList =
                customSpeakingProbRepository.findAllByUser(user);
        List<CustomSpeakingProbResponseDto> responseDtos = new ArrayList<>();
        for(CustomSpeakingProb prob : customSpeakingProbList){
            responseDtos.add(new CustomSpeakingProbResponseDto(prob));
        }
        return response.success(responseDtos, "????????? ?????? ?????? ?????? ????????? ??????????????????.", HttpStatus.OK);
    }

    @Transactional
    public ResponseEntity<?> getCustomSpeakingProb(Long id) {
        User user = getCurrentUser();
        Optional<CustomSpeakingProb> optionalCustomSpeakingProb = customSpeakingProbRepository.findById(id);
        if(!optionalCustomSpeakingProb.isPresent()){
            return response.fail("???????????? ?????? ?????? ???????????????.", HttpStatus.BAD_REQUEST);
        }
        CustomSpeakingProb customSpeakingProb = optionalCustomSpeakingProb.get();
        if(isNotValidForProb(customSpeakingProb.getUser())){
            return response.fail("?????? ????????? ????????????.", HttpStatus.BAD_REQUEST);
        }
        CustomSpeakingProbResponseDto responseDto = new CustomSpeakingProbResponseDto(customSpeakingProb);
        return response.success(responseDto, "????????? ?????? ?????? ????????? ??????????????????.", HttpStatus.OK);
    }

    // ?????? ?????? ?????? : ????????? ????????? url??? ?????? ???????????????
    @Transactional
    public ResponseEntity<?> updateCustomSpeakingProb(CustomSpeakingProbUpdateRequestDto requestDto) {
        Optional<CustomSpeakingProb> optionalCustomSpeakingProb = customSpeakingProbRepository.findById(requestDto.getId());
        if(!optionalCustomSpeakingProb.isPresent()){
            return response.fail("???????????? ?????? ?????? ???????????????.", HttpStatus.BAD_REQUEST);
        }
        CustomSpeakingProb customSpeakingProb = optionalCustomSpeakingProb.get();
        if(isNotValidForProb(customSpeakingProb.getUser())){
            return response.fail("?????? ????????? ????????????.", HttpStatus.BAD_REQUEST);
        }

        customSpeakingProb.updateType(requestDto.getType());
        // ?????? content??? ???????????????, ????????? ?????? ????????????
        if(isContentChanged(customSpeakingProb.getContent(), requestDto.getContent())){
            // ?????? ??????
            String newURL = URLEnocder.generateURLWithTypeAndToken(requestDto.getType(), requestDto.getContent(), BucketType.t_custom);
            customSpeakingProb.updateContent(requestDto.getContent());
            customSpeakingProb.updateUrl(newURL);
        }
        CustomSpeakingProbResponseDto responseDto = new CustomSpeakingProbResponseDto(customSpeakingProb);
        return response.success(responseDto, "?????? ?????? ????????? ??????????????????.", HttpStatus.OK);
    }
    private boolean isContentChanged(String originContent, String newContent){
        return (originContent.compareTo(newContent))!=0;
    }

    @Transactional
    public ResponseEntity<?> deleteCustomSpeakingProb(Long id) {
        Optional<CustomSpeakingProb> optionalCustomSpeakingProb = customSpeakingProbRepository.findById(id);
        if(!optionalCustomSpeakingProb.isPresent()){
            return response.fail("???????????? ?????? ?????? ???????????????.", HttpStatus.BAD_REQUEST);
        }
        CustomSpeakingProb customSpeakingProb = optionalCustomSpeakingProb.get();
        if(isNotValidForProb(customSpeakingProb.getUser())){
            return response.fail("?????? ????????? ????????????.", HttpStatus.BAD_REQUEST);
        }
        customSpeakingProbRepository.deleteById(id);
        return response.success("????????? ?????? ?????? ????????? ??????????????????.");

    }

}
