package com.dalgona.zerozone.config.security;

import com.dalgona.zerozone.jwt.JwtAccessDeniedHandler;
import com.dalgona.zerozone.jwt.JwtAuthenticationEntryPoint;
import com.dalgona.zerozone.jwt.JwtSecurityConfig;
import com.dalgona.zerozone.jwt.JwtTokenProvider;
import org.springframework.context.annotation.Bean;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

@EnableWebSecurity
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {

    private final JwtTokenProvider tokenProvider;
    private final JwtAuthenticationEntryPoint jwtAuthenticationEntryPoint;
    private final JwtAccessDeniedHandler jwtAccessDeniedHandler;

    public WebSecurityConfig(
            JwtTokenProvider tokenProvider,
            JwtAuthenticationEntryPoint jwtAuthenticationEntryPoint,
            JwtAccessDeniedHandler jwtAccessDeniedHandler
    ) {
        this.tokenProvider = tokenProvider;
        this.jwtAuthenticationEntryPoint = jwtAuthenticationEntryPoint;
        this.jwtAccessDeniedHandler = jwtAccessDeniedHandler;
    }

    // 암호화에 필요한 PasswordEncoder 를 Bean 등록합니다.
    @Bean
    public PasswordEncoder passwordEncoder(){
        return new BCryptPasswordEncoder();
    }

    @Bean
    @Override
    public AuthenticationManager authenticationManagerBean() throws Exception {
        return super.authenticationManagerBean();
    }

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http.csrf().disable()
                .exceptionHandling()
                .authenticationEntryPoint(jwtAuthenticationEntryPoint)
                .accessDeniedHandler(jwtAccessDeniedHandler)

                // 세션을 사용하지 않기 때문에 STATELESS로 설정
                .and()
                .sessionManagement()
                .sessionCreationPolicy(SessionCreationPolicy.STATELESS)

                .and()
                .authorizeRequests()
                .antMatchers("/user").permitAll()
                .antMatchers("/user/login").permitAll()
                .antMatchers("/user/email").permitAll()
                .antMatchers("/email/**").permitAll()
                .antMatchers("/user/password/lost").permitAll()
                .antMatchers("/token/reissue/accessToken").permitAll()

                .anyRequest().authenticated()

                .and()
                .apply(new JwtSecurityConfig(tokenProvider));

    }

    /*
    // Security 무시하기
    public void configure(WebSecurity web) throws Exception{
        web.ignoring().antMatchers("/h2-console/**")
        .antMatchers("/user")
                .antMatchers("/user/**")
                .antMatchers("/user/login")
                .antMatchers("/user/email")
                .antMatchers("/email/**")
                .antMatchers("/speaking/list/**")
                .antMatchers("/speaking/practice/**")
                //.antMatchers("/bookmark/**")
                .antMatchers("/recent/**");
    }

     */

}
