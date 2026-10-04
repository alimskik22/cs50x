//
//  QuizLogic.swift
//  QuietVoice
//
//  Description: Core quiz engine responsible for generating questions and validating answers.
//               Supports three question types: full ASL signs (video), fingerspelling letters (images),
//               and numbers (images). Each question includes the correct answer and three random
//               distractors pulled from the relevant data set (allSigns, allLetters, or allNumbers).
//               Used by all quiz modes: Sign of the Day, Quick Quiz, Random Set Quiz, Missed Signs Quiz,
//               Practice Topics, and Practice Fingerspelling.
//
//
//  Created by Alima Karimova
//
import Foundation


struct Question {
    let text: String
    let correctAnswer: String
    let options: [String]
    let mediaName: String
    let mediaType: MediaType
}



struct QuizLogic {

    // Generate question for a specific sign
    func generateQuestion(from sign: Sign, allSigns: [Sign]) -> Question {
        let wrongSigns = allSigns.filter { $0.word != sign.word }.shuffled().prefix(3)
        let wrongWords = wrongSigns.map { $0.word }
        let allOptions = ([sign.word] + wrongWords).shuffled()
        
        return Question(
            text: "What sign is this?",
            correctAnswer: sign.word,
            options: allOptions,
            mediaName: sign.videoName,
            mediaType: .video
        )
    }
    
    // Generate question for a letter (fingerspelling)
    func generateQuestion(for letter: Letter, allLetters: [Letter]) -> Question {
        let wrongLetters = allLetters.filter { $0.character != letter.character }.shuffled().prefix(3)
        let wrongChars = wrongLetters.map { $0.character }
        let allOptions = ([letter.character] + wrongChars).shuffled()
        
        return Question(
            text: "Which letter is this?",
            correctAnswer: letter.character,
            options: allOptions,
            mediaName: letter.imageName,
            mediaType: .image
        )
    }
    
    // Generate question for a number
    func generateQuestion(for number: Letter, allNumbers: [Letter]) -> Question {
        let wrongNumbers = allNumbers.filter { $0.character != number.character }.shuffled().prefix(3)
        let wrongChars = wrongNumbers.map { $0.character }
        let allOptions = ([number.character] + wrongChars).shuffled()
        
        return Question(
            text: "Which number is this?",
            correctAnswer: number.character,
            options: allOptions,
            mediaName: number.imageName,
            mediaType: .image
        )
    }
    
    func checkAnswer(selected: String, correct: String) -> Bool {
        return selected == correct
    }
}

