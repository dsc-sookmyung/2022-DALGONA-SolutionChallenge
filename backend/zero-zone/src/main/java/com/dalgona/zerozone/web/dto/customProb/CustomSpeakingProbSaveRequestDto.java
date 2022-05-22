package com.dalgona.zerozone.web.dto.customProb;

import com.dalgona.zerozone.domain.customProbs.customSpeaking.CustomSpeakingProb;
import com.dalgona.zerozone.domain.user.User;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class CustomSpeakingProbSaveRequestDto{

    String type;
    String content;
    User user;
    String url;

    public void setUrl(String url) {
        this.url = url;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public CustomSpeakingProb toEntity(){
        return CustomSpeakingProb.builder()
                .user(user)
                .type(type)
                .content(content)
                .url(url)
                .build();
    }

}
