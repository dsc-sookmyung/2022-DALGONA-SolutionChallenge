package com.dalgona.zerozone.web.dto.user;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class UserLoginRequestDTO {

    private String email;
    private String password;

    @Builder
    public UserLoginRequestDTO(String email, String password){
        this.email=email;
        this.password=password;
    }


}
