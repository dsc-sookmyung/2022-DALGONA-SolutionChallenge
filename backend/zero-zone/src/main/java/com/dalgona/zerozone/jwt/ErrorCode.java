package com.dalgona.zerozone.jwt;

import lombok.Getter;

@Getter
public class ErrorCode {

    String code;
    int status;
    String message;

    public ErrorCode(String code, int status, String message){
        this.code = code;
        this.status = status;
        this.message = message;
    }

    @Getter
    public static final ErrorCode INVALID_SIGNATURE = new ErrorCode("INVALID_SIGNATURE", 401, "잘못된 JWT 서명입니다.");
    public static final ErrorCode EXPIRED_TOKEN = new ErrorCode("EXPIRED_TOKEN", 401, "만료된 JWT 토큰입니다.");
    public static final ErrorCode UNSUPPORTED_TOKEN = new ErrorCode("UNSUPPORTED_TOKEN", 401, "지원되지 않는 JWT 토큰입니다.");
    public static final ErrorCode INVALID_TOKEN = new ErrorCode("INVALID_TOKEN", 401, "JWT 토큰이 잘못되었습니다.");
    public static final ErrorCode NON_LOGIN = new ErrorCode("NON_LOGIN", 401, "토큰이 전달되지 않았습니다.");

}
