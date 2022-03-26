package com.dalgona.zerozone.domain.user;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.time.LocalDateTime;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class UserEmailAuth {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(length = 100, nullable = false, unique = true)
    private String email;

    @Column
    private String authCode;

    @Column
    private LocalDateTime authValidTime;

    @Column
    private String authPwdCode;

    @Column
    private LocalDateTime authPwdValidTime;

    @Builder
    public UserEmailAuth(String email, String authCode, LocalDateTime authValidTime){
        this.email=email;
        this.authCode=authCode;
        this.authValidTime = authValidTime;
    }

    public UserEmailAuth updateCode(String authCode){
        this.authCode=authCode;
        return this;
    }

    public UserEmailAuth updateAuthValidTime(LocalDateTime authValidTime){
        this.authValidTime = authValidTime;
        return this;
    }

    public UserEmailAuth updatePwdCode(String authPwdCode){
        this.authPwdCode=authPwdCode;
        return this;
    }

    public void updateAuthPwdValidTime(LocalDateTime validTime) {
        this.authPwdValidTime = validTime;
    }

}