package com.dalgona.zerozone.web.dto;

import lombok.Getter;

public class InvalidRequestFormatException extends RuntimeException implements CustomRuntimeException {

    @Getter
    private final String NAME;

    public InvalidRequestFormatException(String message) {
        super(message);
        NAME = "InvalidRequestFormatException";
    }

}

