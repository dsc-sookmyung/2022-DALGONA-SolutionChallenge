package com.dalgona.zerozone.web.dto.user;

import com.dalgona.zerozone.domain.User;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.Column;

@Getter
@NoArgsConstructor
public class UserSaveRequestDTO {

    private String email;
    private String password;
    private String name;

    @Builder
    public UserSaveRequestDTO(String email, String password, String name){
        this.email=email;
        this.password=password;
        this.name=name;
    }

    public User toEntity(){
        return User.builder()
                .email(email)
                .password(password)
                .name(name)
                .build();
    }

    public void encodePwd(String encodedPwd){
        this.password = encodedPwd;
    }

}
