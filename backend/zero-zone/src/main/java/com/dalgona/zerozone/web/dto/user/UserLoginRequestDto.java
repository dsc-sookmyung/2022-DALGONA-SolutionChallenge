package com.dalgona.zerozone.web.dto.user;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class UserLoginRequestDto {

    private String email;
    private String password;

    @Builder
    public UserLoginRequestDto(String email, String password){
        this.email=email;
        this.password=password;
    }


}
