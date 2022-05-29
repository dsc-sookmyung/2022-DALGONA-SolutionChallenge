package com.dalgona.zerozone.web.dto.customProb;

import com.dalgona.zerozone.domain.customProbs.customReading.CustomReadingProb;
import com.dalgona.zerozone.domain.user.User;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class CustomReadingProbSaveRequestDto {

    String type;
    String content;
    String hint;
    String spacing_info;
    User user;
    String url;

    public void setUrl(String url) {
        this.url = url;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public void setHint(String hint) {
        this.hint = hint;
    }

    public void setSpacing_info(String spacing_info) { this.spacing_info = spacing_info; }

    public CustomReadingProb toEntity(){
        return CustomReadingProb.builder()
                .user(user)
                .type(type)
                .content(content)
                .hint(hint)
                .spacing_info(spacing_info)
                .url(url)
                .build();
    }


}
