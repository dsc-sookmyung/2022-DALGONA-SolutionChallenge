package com.dalgona.zerozone.service.customProb;

import com.dalgona.zerozone.domain.customProbs.customReading.CustomReadingProb;
import com.dalgona.zerozone.domain.customProbs.customReading.CustomReadingProbRepository;
import com.dalgona.zerozone.domain.user.User;
import com.dalgona.zerozone.domain.user.UserRepository;
import com.dalgona.zerozone.hangulAnalyzer.BucketType;
import com.dalgona.zerozone.hangulAnalyzer.SpacingInfoCreator;
import com.dalgona.zerozone.hangulAnalyzer.URLEnocder;
import com.dalgona.zerozone.hangulAnalyzer.UnicodeHandler;
import com.dalgona.zerozone.jwt.SecurityUtil;
import com.dalgona.zerozone.web.dto.Response;
import com.dalgona.zerozone.web.dto.customProb.CustomReadingProbResponseDto;
import com.dalgona.zerozone.web.dto.customProb.CustomReadingProbSaveRequestDto;
import com.dalgona.zerozone.web.dto.customProb.CustomReadingProbUpdateRequestDto;
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
public class CustomReadingProbService {

    private final UserRepository userRepository;
    private final CustomReadingProbRepository customReadingProbRepository;

    private final Response response;

    private User getCurrentUser(){
        return SecurityUtil.getCurrentUsername().flatMap(userRepository::findByEmail).orElse(null);
    }
    private boolean isNotValidForProb(User user) {
        User currentUser = getCurrentUser();
        return !currentUser.equals(user);
    }

    @Transactional
    public ResponseEntity<?> createCustomReadingProb(CustomReadingProbSaveRequestDto requestDto) {
        User user = getCurrentUser();
        String url = URLEnocder.generateURLWithTypeAndToken(requestDto.getType(), requestDto.getContent(), BucketType.t_custom);
        requestDto.setUser(user);
        requestDto.setUrl(url);
        if(requestDto.getHint() == null){
            String onsetHint = UnicodeHandler.splitHangeulToOnsetAsString(requestDto.getContent());
            requestDto.setHint(onsetHint);
        }
        if(isSentenceType(requestDto.getType())){
            String spacing_info = SpacingInfoCreator.createSpacingInfo(requestDto.getContent());
            requestDto.setSpacing_info(spacing_info);
        }
        CustomReadingProb customReadingProb;
        try {
            customReadingProb = customReadingProbRepository.save(requestDto.toEntity());
        }catch (IllegalArgumentException e){
            return response.fail("연습 문제 생성에 실패했습니다.", HttpStatus.NOT_ACCEPTABLE);
        }
        CustomReadingProbResponseDto responseDto = new CustomReadingProbResponseDto(customReadingProb);
        return response.success(responseDto, "연습 문제 생성에 성공했습니다.", HttpStatus.OK);
    }
    private boolean isSentenceType(String type){
        return (type.compareTo("sentence"))==0;
    }

    @Transactional
    public ResponseEntity<?> getCustomReadingProbs() {
        User user = getCurrentUser();
        List<CustomReadingProb> customReadingProbList =
                customReadingProbRepository.findAllByUser(user);
        List<CustomReadingProbResponseDto> responseDtos = new ArrayList<>();
        for(CustomReadingProb prob : customReadingProbList){
            responseDtos.add(new CustomReadingProbResponseDto(prob));
        }
        return response.success(responseDtos, "커스텀 연습 문제 전체 조회에 성공했습니다.", HttpStatus.OK);
    }

    @Transactional
    public ResponseEntity<?> getCustomReadingProb(Long id) {
        Optional<CustomReadingProb> optionalCustomReadingProb = customReadingProbRepository.findById(id);
        if(!optionalCustomReadingProb.isPresent()){
            return response.fail("존재하지 않는 연습 문제입니다.", HttpStatus.BAD_REQUEST);
        }
        CustomReadingProb customReadingProb = optionalCustomReadingProb.get();
        if(isNotValidForProb(customReadingProb.getUser())){
            return response.fail("접근 권한이 없습니다.", HttpStatus.BAD_REQUEST);
        }
        CustomReadingProbResponseDto responseDto = new CustomReadingProbResponseDto(customReadingProb);
        return response.success(responseDto, "커스텀 연습 문제 조회에 성공했습니다.", HttpStatus.OK);
    }

    @Transactional
    public ResponseEntity<?> updateCustomReadingProb(CustomReadingProbUpdateRequestDto requestDto) {
        Optional<CustomReadingProb> optionalCustomReadingProb = customReadingProbRepository.findById(requestDto.getId());
        if(!optionalCustomReadingProb.isPresent()){
            return response.fail("존재하지 않는 연습 문제입니다.", HttpStatus.BAD_REQUEST);
        }
        CustomReadingProb customReadingProb = optionalCustomReadingProb.get();
        if(isNotValidForProb(customReadingProb.getUser())){
            return response.fail("접근 권한이 없습니다.", HttpStatus.BAD_REQUEST);
        }

        customReadingProb.updateType(requestDto.getType());
        customReadingProb.updateHint(requestDto.getHint());
        // 만약 content가 달라졌다면, 영상과 띄어쓰기 정보를 새로 생성한다
        if(isContentChanged(customReadingProb.getContent(), requestDto.getContent())){
            // 영상 요청
            String newURL = URLEnocder.generateURLWithTypeAndToken(requestDto.getType(), requestDto.getContent(), BucketType.t_custom);
            customReadingProb.updateUrl(newURL);
            // 띄어쓰기 정보 다시 생성
            if(isSentenceType(requestDto.getType())){
                String spacing_info = SpacingInfoCreator.createSpacingInfo(requestDto.getContent());
                customReadingProb.updateSpacingInfo(spacing_info);
            }
            customReadingProb.updateContent(requestDto.getContent());
        }
        CustomReadingProbResponseDto responseDto = new CustomReadingProbResponseDto(customReadingProb);
        return response.success(responseDto, "연습 문제 수정에 성공했습니다.", HttpStatus.OK);
    }
    private boolean isContentChanged(String originContent, String newContent){
        return (originContent.compareTo(newContent))!=0;
    }

    @Transactional
    public ResponseEntity<?> deleteCustomReadingProb(Long id) {
        Optional<CustomReadingProb> optionalCustomReadingProb = customReadingProbRepository.findById(id);
        if(!optionalCustomReadingProb.isPresent()){
            return response.fail("존재하지 않는 연습 문제입니다.", HttpStatus.BAD_REQUEST);
        }
        CustomReadingProb customReadingProb = optionalCustomReadingProb.get();
        if(isNotValidForProb(customReadingProb.getUser())){
            return response.fail("접근 권한이 없습니다.", HttpStatus.BAD_REQUEST);
        }
        customReadingProbRepository.deleteById(id);
        return response.success("커스텀 연습 문제 삭제에 성공했습니다.");
    }

}
