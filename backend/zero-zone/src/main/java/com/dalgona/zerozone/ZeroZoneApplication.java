package com.dalgona.zerozone;

import com.dalgona.zerozone.domain.content.letter.Onset;
import com.dalgona.zerozone.domain.content.letter.OnsetRepository;
import com.dalgona.zerozone.service.init.InitService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

@EnableJpaAuditing
@SpringBootApplication
@RequiredArgsConstructor
public class ZeroZoneApplication implements CommandLineRunner {

	public static void main(String[] args) {
		SpringApplication.run(ZeroZoneApplication.class, args);
	}

	private final InitService initService;
	@Override
	public void run(String... args) throws Exception {
		System.out.println("===Initialize===");
		initService.init();
	}

}
