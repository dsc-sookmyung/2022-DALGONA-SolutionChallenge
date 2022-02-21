package com.dalgona.zerozone.domain.user;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;

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
    private boolean authStatus;

    @Column
    private String authPwdCode;

    @Column
    private boolean authPwdStatus;

    @Builder
    public UserEmailAuth(String email, String authCode, boolean authStatus){
        this.email=email;
        this.authCode=authCode;
        this.authStatus=authStatus;
    }


    public UserEmailAuth updateCode(String authCode){
        this.authCode=authCode;
        this.authStatus=false;
        return this;
    }

    public UserEmailAuth updateAuthStatus(boolean authStatus){
        this.authStatus=authStatus;
        return this;
    }

    public UserEmailAuth updatePwdCode(String authPwdCode){
        this.authPwdCode=authPwdCode;
        this.authPwdStatus=false;
        return this;
    }

    public UserEmailAuth updateAuthPwdStatus(boolean authPwdStatus){
        this.authPwdStatus=authPwdStatus;
        return this;
    }


}