package com.dalgona.zerozone.service.user;

import com.dalgona.zerozone.domain.bookmark.BookmarkReading;
import com.dalgona.zerozone.domain.bookmark.BookmarkReadingRepository;
import com.dalgona.zerozone.domain.bookmark.BookmarkSpeaking;
import com.dalgona.zerozone.domain.bookmark.BookmarkSpeakingRepository;
import com.dalgona.zerozone.domain.user.*;
import com.dalgona.zerozone.jwt.JwtAuthenticationFilter;
import com.dalgona.zerozone.jwt.JwtTokenProvider;
import com.dalgona.zerozone.jwt.SecurityUtil;
import com.dalgona.zerozone.web.dto.Response;
import com.dalgona.zerozone.web.dto.token.TokensResponseDto;
import com.dalgona.zerozone.web.dto.user.UserInfoResponseDto;
import com.dalgona.zerozone.web.dto.user.UserLoginRequestDto;
import com.dalgona.zerozone.web.dto.user.UserLoginResponseDto;
import com.dalgona.zerozone.web.dto.user.UserSaveRequestDto;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletRequest;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.Optional;
import java.util.UUID;

@RequiredArgsConstructor
@Service
public class UserService {

    private final UserRepository userRepository;
    private final UserEmailAuthRepository userEmailAuthRepository;
    private final BookmarkReadingRepository bookmarkReadingRepository;
    private final BookmarkSpeakingRepository bookmarkSpeakingRepository;

    private final PasswordEncoder pwdEncorder;
    private final JwtTokenProvider jwtTokenProvider;
    private final Response response;

    // 회원가입
    @Transactional
    public ResponseEntity<?> join(UserSaveRequestDto userSaveRequestDTO){
        if (isExistingUser(userSaveRequestDTO.getEmail())) {
            return response.fail("이미 회원가입된 이메일입니다.", HttpStatus.BAD_REQUEST);
        }
        // 이메일 인증을 마친 사용자인지 확인
        if (!isAuthed(userSaveRequestDTO.getEmail())){
            return response.fail("이메일이 인증되지 않은 이메일입니다.", HttpStatus.BAD_REQUEST);
        }

        // 비밀번호 암호화
        String encodedPwd = pwdEncorder.encode(userSaveRequestDTO.getPassword());
        userSaveRequestDTO.encodePwd(encodedPwd);

        // DB 저장
        Authority authority = Authority.builder().authorityName("ROLE_USER").build();
        User user = userRepository.save(userSaveRequestDTO.toEntity(Collections.singleton(authority)));

        // 북마크 생성
        BookmarkReading bookmarkReading = new BookmarkReading(user);
        bookmarkReadingRepository.save(bookmarkReading);
        BookmarkSpeaking bookmarkSpeaking = new BookmarkSpeaking(user);
        bookmarkSpeakingRepository.save(bookmarkSpeaking);

        return response.success("회원가입에 성공했습니다.");
    }

    // 이메일 중복체크 내부 메소드
    public boolean isExistingUser(String email) {
        Optional<User> findUser = userRepository.findByEmail(email);
        return findUser.isPresent();
    }

    // 이메일 중복체크
    @Transactional
    public ResponseEntity<?> isExist(String email){
        return response.success(isExistingUser(email), "이메일 중복체크에 성공했습니다.", HttpStatus.OK);
    }

    // 로그인
    @Transactional
    public ResponseEntity<?> login(UserLoginRequestDto userLoginRequestDTO){

        Optional<User> member = userRepository.findByEmail(userLoginRequestDTO.getEmail());
        if (!member.isPresent()) {
            return response.fail("가입되지 않은 E-MAIL 입니다.", HttpStatus.BAD_REQUEST);
        }
        User findMember = member.get();
        if (!pwdEncorder.matches(userLoginRequestDTO.getPassword(), findMember.getPassword())) {
            return response.fail("잘못된 비밀번호입니다.", HttpStatus.BAD_REQUEST);
        }

        String accessToken = jwtTokenProvider.createAccessToken(findMember.getEmail(), findMember.getAuthorities());
        String refreshTokenValue = UUID.randomUUID().toString().replace("-", "");
        findMember.updateRefreshTokenValue(refreshTokenValue);
        String refreshToken = jwtTokenProvider.createRefreshToken(refreshTokenValue);

        HttpHeaders httpHeaders = new HttpHeaders();
        httpHeaders.add(JwtAuthenticationFilter.AUTHORIZATION_HEADER, "Bearer " + accessToken);
        UserLoginResponseDto userLoginResponseDto = new UserLoginResponseDto(accessToken, refreshToken, findMember.getEmail());

        return response.success(userLoginResponseDto, "로그인에 성공했습니다.", HttpStatus.OK);
    }

    // 인증된 이메일인지 확인
    public boolean isAuthed(String email){
        Optional<UserEmailAuth> findUser = userEmailAuthRepository.findByEmail(email);
        if(!findUser.isPresent())
            return false;
        LocalDateTime validTime = findUser.get().getAuthValidTime();
        if(validTime.isAfter(LocalDateTime.now()))
            return true;
        else
            return false;
    }

    // 비밀번호 인증된 이메일인지 확인
    public boolean isAuthedPwd(String email){
        Optional<UserEmailAuth> findUser = userEmailAuthRepository.findByEmail(email);
        if(!findUser.isPresent())
            return false;
        LocalDateTime validTime = findUser.get().getAuthPwdValidTime();
        if(validTime.isAfter(LocalDateTime.now()))
            return true;
        else
            return false;
    }

    private User getCurrentUser(){
        return SecurityUtil.getCurrentUsername().flatMap(userRepository::findByEmail).orElse(null);
    }

    // 내 정보 조회
    @Transactional
    public ResponseEntity<?> getMyInfo(){
        User user = getCurrentUser();
        UserInfoResponseDto info = new UserInfoResponseDto(user.getEmail(), user.getName());
        return response.success(info, "내 정보 조회에 성공했습니다.", HttpStatus.OK);
    }

    // 이름 수정
    @Transactional
    public ResponseEntity<?> updateMyName(String newName){
        User user = getCurrentUser();
        user.updateName(newName);
        return response.success("회원 이름 수정에 성공했습니다.");
    }

    // 비번 분실시 비밀번호 수정
    @Transactional
    public ResponseEntity<?> updateMyPasswordIfLost(String email, String newPassword){
        Optional<UserEmailAuth> findUser = userEmailAuthRepository.findByEmail(email);
        // 인증된 이메일인지 확인
        if(findUser.isPresent()){
            // 인증되었다면 비밀번호 수정
            if(isAuthedPwd(findUser.get().getEmail())){
                String encodedPwd = pwdEncorder.encode(newPassword);
                Optional<User> user = userRepository.findByEmail(email);
                if(!user.isPresent()) return response.fail("존재하지 않는 이메일입니다.", HttpStatus.BAD_REQUEST);
                user.get().updatePassword(encodedPwd);
                return response.success("회원 비밀번호 수정에 성공했습니다.");
            }
        }
        return response.fail("인증되지 않은 이메일입니다.", HttpStatus.BAD_REQUEST);
    }

    // 인증토큰 재발급
    public ResponseEntity<?> reissueAccessToken(String userEmail, String givenRefreshToken, HttpServletRequest request) {
        Optional<User> user = userRepository.findByEmail(userEmail);
        if(!user.isPresent()) return response.fail("존재하지 않는 이메일입니다.", HttpStatus.BAD_REQUEST);
        User findUser = user.get();

        String requiredValue = findUser.getRefreshTokenValue();
        if (!jwtTokenProvider.validateToken(givenRefreshToken, request))
            return response.fail("리프레시 토큰이 유효하지 않습니다. 다시 로그인해주세요.", HttpStatus.BAD_REQUEST);

        // 새로운 토큰을 받기 위한 Authentication 객체
        UsernamePasswordAuthenticationToken authenticationToken =
                new UsernamePasswordAuthenticationToken(findUser.getEmail(), null);

        // 인증 토큰 재발급
        String accessToken = jwtTokenProvider.createAccessToken(findUser.getEmail(), findUser.getAuthorities());
        String refreshTokenValue = UUID.randomUUID().toString().replace("-", "");
        findUser.updateRefreshTokenValue(refreshTokenValue);
        String refreshToken = jwtTokenProvider.createRefreshToken(refreshTokenValue);
        TokensResponseDto tokens = new TokensResponseDto(accessToken, refreshToken);

        HttpHeaders httpHeaders = new HttpHeaders();
        httpHeaders.add(JwtAuthenticationFilter.AUTHORIZATION_HEADER, "Bearer " + accessToken);

        return response.success(tokens, "인증 토큰을 재발급했습니다.", HttpStatus.OK);
    }
}
