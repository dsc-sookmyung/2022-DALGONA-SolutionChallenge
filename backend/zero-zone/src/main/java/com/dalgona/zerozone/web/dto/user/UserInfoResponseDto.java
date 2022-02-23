package com.dalgona.zerozone.web.dto.user;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class UserInfoResponseDto {

    private String email;
    private String name;

    @Builder
    public UserInfoResponseDto(String email, String name){
        this.email=email;
        this.name=name;
    }

}
