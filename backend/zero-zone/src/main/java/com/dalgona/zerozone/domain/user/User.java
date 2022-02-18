package com.dalgona.zerozone.domain.user;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import javax.persistence.*;

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

    @Builder
    public User(String email, String password, String name){
        System.out.println("User Builder");
        this.email=email;
        this.password=password;
        this.name=name;
        this.role="ROLE_USER";
    }


}
