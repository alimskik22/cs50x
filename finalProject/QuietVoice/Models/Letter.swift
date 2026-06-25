//
//  Letter.swift
//  QuietVoice
//
//  Description: Data model for fingerspelling letters and numbers.
//               Each Letter instance represents a single character (A-Z or 0-10)
//               with its corresponding jpg image name for display in the
//               Fingerspelling section grid and quizzes.
//
//  Created by Alima Karimova
//

import Foundation

struct Letter: Identifiable {
    let id = UUID()
    let character: String
    let imageName: String
}
