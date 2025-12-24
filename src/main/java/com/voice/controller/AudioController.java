package com.voice.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.voice.service.SpeechToTextService;



@RestController
@RequestMapping("/api")
@CrossOrigin

public class AudioController 
{
	@Autowired
	private SpeechToTextService speechService;
	
	@PostMapping("/record")
	public ResponseEntity<Map<String,String>> uploadAudio(@RequestParam("audio")MultipartFile audioFile)
	{
		String transcription =speechService.convertAudioToText(audioFile);
		
		return ResponseEntity.ok(Map.of("transcription",transcription));
		
	}
	@GetMapping("/check")
	public String check() 
	{
	    return "OK";
	}
	
}
