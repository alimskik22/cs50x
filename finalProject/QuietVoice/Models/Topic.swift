//
//  Topic.swift
//  QuietVoice
//
//  Description: Data model representing a flashcard topic category.
//
//  Created by Alima Karimova
//
import Foundation

struct Topic: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let signs: [Sign]
}
