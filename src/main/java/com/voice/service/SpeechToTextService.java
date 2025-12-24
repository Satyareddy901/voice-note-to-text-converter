package com.voice.service;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.google.cloud.speech.v1.RecognitionAudio;
import com.google.cloud.speech.v1.RecognitionConfig;
import com.google.cloud.speech.v1.RecognizeResponse;
import com.google.cloud.speech.v1.SpeechClient;
import com.google.cloud.speech.v1.SpeechRecognitionResult;
import com.google.protobuf.ByteString;

@Service
public class SpeechToTextService 
{
	public String convertAudioToText(MultipartFile file)
	{
		try(SpeechClient speechClient=SpeechClient.create())
		{
			byte[] audioBytes =file.getBytes();
			
			RecognitionAudio  audio =RecognitionAudio.newBuilder()
					.setContent(ByteString.copyFrom(audioBytes)).build();
			
			 RecognitionConfig config = RecognitionConfig.newBuilder()
	                    .setEncoding(RecognitionConfig.AudioEncoding.OGG_OPUS)
	            
	                    .setLanguageCode("en-US")
	                    .build();
			 RecognizeResponse response= speechClient.recognize(config,audio);
			 
			 StringBuilder resultText =new StringBuilder();
			 for(SpeechRecognitionResult result: response.getResultsList())
			 {
				 resultText.append(result.getAlternatives(0).getTranscript());
				 
			 }
			 return resultText.toString();
		}catch(Exception e)
		{
			e.printStackTrace();
			return "Error occured while converting audio";
		}
		
	}
}
