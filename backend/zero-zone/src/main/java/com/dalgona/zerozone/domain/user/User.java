package com.dalgona.zerozone.domain.user;

import com.dalgona.zerozone.domain.test.Test;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.util.*;

@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
public class User{

    @Id
    @Column(name = "user_id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long userId;

    @Column(length = 100, nullable = false, unique = true)
    private String email;

    @Column(length = 300, nullable = false)
    private String password;

    @Column(length = 300, nullable = false)
    private String name;

    @JsonManagedReference
    @OneToMany(mappedBy = "user")
    private List<Test> tests = new ArrayList<>();

    @Column(name = "refresh_token_value")
    private String refreshTokenValue;

    @ManyToMany
    @JoinTable(
            name = "user_authority",
            joinColumns = {@JoinColumn(name = "user_id", referencedColumnName = "user_id")},
            inverseJoinColumns = {@JoinColumn(name = "authority_name", referencedColumnName = "authority_name")})
    private Set<Authority> authorities = new HashSet<>();

    @Builder
    public User(String email, String password, String name){
        this.email=email;
        this.password=password;
        this.name=name;
    }

    public User updateName(String name){
        this.name=name;
        return this;
    }

    public User updatePassword(String password){
        this.password=password;
        return this;
    }

    public User updateAuthorities(Set<Authority> authorities){
        this.authorities = authorities;
        return this;
    }

    public void updateRefreshTokenValue(String refreshToken) {
        this.refreshTokenValue = refreshToken;
    }
}
