//
//  Sign.swift
//  QuietVoice
//
//  Description: Data model representing a full ASL sign.
//               Each Sign instance contains the word/phrase, the corresponding MP4 video filename,
//               the topic category it belongs to, id, and a counter for tracking incorrect quiz answers.
//               Used throughout the app for flashcards, quizzes, and progress tracking.
//
//  Created by Alima Karimova
//

import Foundation

struct Sign: Identifiable {
    let id = UUID()
    let word: String
    let videoName: String
    let topic: String
    var timesMissed: Int = 0
}
