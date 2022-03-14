package com.dalgona.zerozone.web.dto.user;

import com.dalgona.zerozone.domain.user.Authority;
import com.dalgona.zerozone.domain.user.User;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.Set;

@Getter
@NoArgsConstructor
public class UserSaveRequestDto {

    private String email;
    private String password;
    private String name;

    @Builder
    public UserSaveRequestDto(String email, String password, String name){
        this.email=email;
        this.password=password;
        this.name=name;
    }

    public User toEntity(Set<Authority> authorities){
        return User.builder()
                .email(email)
                .password(password)
                .name(name)
                .authorities(authorities)
                .build();
    }

    public void encodePwd(String encodedPwd){
        this.password = encodedPwd;
    }

}
