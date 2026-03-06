A Spring Boot based application that converts voice/audio notes into text using speech recognition technology. The system allows users to upload audio files and automatically generates readable text output.

This project demonstrates REST API development, file handling, speech recognition integration, and backend architecture using Java Spring Boot.

Features :
1.Upload voice/audio files
2.Convert speech into text automatically
3.Display converted text output
4.REST API based backend
5.Structured layered architecture
6.Logging and error handling


Tech stack: 
Java – Core programming language
Spring Boot – Backend framework
REST APIs – Communication between client and server
Maven – Dependency management
MySQL – Database
Google Speech-to-Text API – Voice recognition

Project Structure:

voice-note-to-text-converter
│
├── controller
│ └── VoiceController.java
│
├── service
│ └── SpeechService.java
│
├── repository
│ └── VoiceRepository.java
│
├── entity
│ └── VoiceNote.java
│
├── resources
│ └── application.properties
│
└── pom.xml
