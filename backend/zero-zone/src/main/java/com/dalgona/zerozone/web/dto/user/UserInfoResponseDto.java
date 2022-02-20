package com.dalgona.zerozone.web.dto.user;

import com.dalgona.zerozone.domain.user.UserEmailAuth;
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


//    public UserEmailAuth toEntity(){
//        return UserEmailAuth.builder()
//                .email(email)
//                .authCode(authCode)
//                .build();
//    }
//
}
