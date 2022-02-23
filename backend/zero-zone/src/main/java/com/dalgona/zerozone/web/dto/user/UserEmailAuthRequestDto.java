package com.dalgona.zerozone.web.dto.user;

import com.dalgona.zerozone.domain.user.UserEmailAuth;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class UserEmailAuthRequestDto {

    String email;
    String authCode;

    @Builder
    public UserEmailAuthRequestDto(String email, String authCode){
        this.email=email;
        this.authCode=authCode;
    }

    public UserEmailAuth toEntity(){
        return UserEmailAuth.builder()
                .email(email)
                .authCode(authCode)
                .build();
    }

}