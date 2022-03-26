package com.dalgona.zerozone.web.dto.user;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class UserLoginResponseDto {
    String accessToken;
    String refreshToken;
    String email;

    @Builder
    public UserLoginResponseDto(String accessToken, String refreshToken, String email){
        this.accessToken = accessToken;
        this.refreshToken = refreshToken;
        this.email = email;
    }
}
