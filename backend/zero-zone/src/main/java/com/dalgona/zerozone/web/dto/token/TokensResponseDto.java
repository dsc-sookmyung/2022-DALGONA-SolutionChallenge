package com.dalgona.zerozone.web.dto.token;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class TokensResponseDto {
    String accessToken;
    String refreshToken;

    @Builder
    public TokensResponseDto(String accessToken, String refreshToken){
        this.accessToken = accessToken;
        this.refreshToken = refreshToken;
    }

}
