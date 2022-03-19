package com.dalgona.zerozone.web.dto.user;

import com.dalgona.zerozone.domain.user.UserEmailAuth;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Getter
@NoArgsConstructor
public class UserEmailAuthRequestDto {

    String email;
    String authCode;
    LocalDateTime authValidTime;

    @Builder
    public UserEmailAuthRequestDto(String email, String authCode, LocalDateTime authValidTime){
        this.email=email;
        this.authCode=authCode;
        this.authValidTime=authValidTime;
    }

    public UserEmailAuth toEntity(){
        return UserEmailAuth.builder()
                .email(email)
                .authCode(authCode)
                .authValidTime(authValidTime)
                .build();
    }

}