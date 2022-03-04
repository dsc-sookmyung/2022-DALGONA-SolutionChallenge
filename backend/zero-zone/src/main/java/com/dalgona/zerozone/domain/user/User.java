package com.dalgona.zerozone.domain.user;

import com.dalgona.zerozone.domain.test.Test;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Getter
@NoArgsConstructor
@AllArgsConstructor
//@Builder
@Entity
public class User{

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(length = 100, nullable = false, unique = true)
    private String email;

    @Column(length = 300, nullable = false)
    private String password;

    @Column(length = 300, nullable = false)
    private String name;

    @Column
    private String role;

    @JsonManagedReference
    @OneToMany(mappedBy = "user")
    private List<Test> tests = new ArrayList<>();

    @Builder
    public User(String email, String password, String name){
        this.email=email;
        this.password=password;
        this.name=name;
        this.role="ROLE_USER";
    }

    public User updateName(String name){
        this.name=name;
        return this;
    }

    public User updatePassword(String password){
        this.password=password;
        return this;
    }


}
