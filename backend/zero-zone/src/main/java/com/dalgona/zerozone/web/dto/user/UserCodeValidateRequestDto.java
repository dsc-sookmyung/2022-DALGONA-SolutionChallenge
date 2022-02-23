package com.dalgona.zerozone.web.dto.user;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class UserCodeValidateRequestDto {

    private String email;
    private String authCode;

    @Builder
    public UserCodeValidateRequestDto(String email, String authCode){
        this.email=email;
        this.authCode=authCode;
    }

}