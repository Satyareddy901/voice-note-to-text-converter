package com.voice;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication(scanBasePackages ="com.voice" )
public class VoiceNoteToTextConverterApplication {

	public static void main(String[] args) {
		SpringApplication.run(VoiceNoteToTextConverterApplication.class, args);
	}

}
