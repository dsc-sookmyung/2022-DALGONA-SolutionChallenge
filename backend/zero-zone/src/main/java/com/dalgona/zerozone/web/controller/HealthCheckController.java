package com.dalgona.zerozone.web.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HealthCheckController {
    @GetMapping("/api/ping")
    public String ping(){
        return "ok";
    }
}