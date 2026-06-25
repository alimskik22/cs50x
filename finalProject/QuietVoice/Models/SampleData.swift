//
//  SampleData.swift
//  QuietVoice
//
//  Description: Central data repository for all app content.
//
//  Created by Alima Karimova
//

import Foundation

let greetingsSigns = [
    Sign(word: "Hello", videoName: "hello", topic: "Greetings"),
    Sign(word: "Bye", videoName: "bye", topic: "Greetings"),
    Sign(word: "Good morning", videoName: "good_morning", topic: "Greetings"),
    Sign(word: "Good afternoon", videoName: "good_afternoon", topic: "Greetings"),
    Sign(word: "Good evening", videoName: "good_evening", topic: "Greetings")
]

let familySigns = [
    Sign(word: "Grandmother", videoName: "grandma", topic: "Family"),
    Sign(word: "Grandfather", videoName: "grandpa", topic: "Family"),
    Sign(word: "Father", videoName: "father", topic: "Family"),
    Sign(word: "Mother", videoName: "mother", topic: "Family"),
    Sign(word: "Brother", videoName: "brother", topic: "Family"),
    Sign(word: "Sister", videoName: "sister", topic: "Family"),
    Sign(word: "Friend", videoName: "friend", topic: "Family")
]


let foodSigns = [
    Sign(word: "Apple", videoName: "apple", topic: "Food"),
    Sign(word: "Coffee", videoName: "coffee", topic: "Food"),
    Sign(word: "Drink", videoName: "drink", topic: "Food"),
    Sign(word: "Eat", videoName: "eat", topic: "Food"),
    Sign(word: "Hungry", videoName: "hungry", topic: "Food"),
    Sign(word: "Tea", videoName: "tea", topic: "Food"),
    Sign(word: "Water", videoName: "water", topic: "Food")
]


let basicActionsSigns = [
    Sign(word: "Come", videoName: "come", topic: "Basic Actions"),
    Sign(word: "Go", videoName: "go", topic: "Basic Actions"),
    Sign(word: "Help", videoName: "help", topic: "Basic Actions"),
    Sign(word: "Sit", videoName: "sit", topic: "Basic Actions"),
    Sign(word: "Stand", videoName: "stand", topic: "Basic Actions")
]


let commonPhrasesAndWordsSigns = [
    Sign(word: "How are you?", videoName: "how_are_u", topic: "Common Phrases"),
    Sign(word: "I love you", videoName: "i_love_u", topic: "Common Phrases"),
    Sign(word: "Nice to meet you", videoName: "nice_to_meet_u", topic: "Common Phrases"),
    Sign(word: "No", videoName: "no", topic: "Common Phrases"),
    Sign(word: "Yes", videoName: "yes", topic: "Common Phrases"),
    Sign(word: "Please", videoName: "please", topic: "Common Phrases"),
    Sign(word: "Sorry", videoName: "sorry", topic: "Common Phrases"),
    Sign(word: "Thank you", videoName: "thank_u", topic: "Common Phrases")
]


let allTopics = [
    Topic(name: "Greetings", icon: "hand.wave", signs: greetingsSigns),
    Topic(name: "Family", icon: "person.2", signs: familySigns),
    Topic(name: "Food", icon: "fork.knife", signs: foodSigns),
    Topic(name: "Basic Actions", icon: "figure.walk", signs: basicActionsSigns),
    Topic(name: "Common Phrases", icon: "bubble.left.and.bubble.right", signs: commonPhrasesAndWordsSigns)
]

let allSigns: [Sign] = greetingsSigns + familySigns + foodSigns + basicActionsSigns + commonPhrasesAndWordsSigns

let allLetters = [
    Letter(character: "A", imageName: "a"),
    Letter(character: "B", imageName: "b"),
    Letter(character: "C", imageName: "c"),
    Letter(character: "D", imageName: "d"),
    Letter(character: "E", imageName: "e"),
    Letter(character: "F", imageName: "f"),
    Letter(character: "G", imageName: "g"),
    Letter(character: "H", imageName: "h"),
    Letter(character: "I", imageName: "i"),
    Letter(character: "J", imageName: "j"),
    Letter(character: "K", imageName: "k"),
    Letter(character: "L", imageName: "l"),
    Letter(character: "M", imageName: "m"),
    Letter(character: "N", imageName: "n"),
    Letter(character: "O", imageName: "o"),
    Letter(character: "P", imageName: "p"),
    Letter(character: "Q", imageName: "q"),
    Letter(character: "R", imageName: "r"),
    Letter(character: "S", imageName: "s"),
    Letter(character: "T", imageName: "t"),
    Letter(character: "U", imageName: "u"),
    Letter(character: "V", imageName: "v"),
    Letter(character: "W", imageName: "w"),
    Letter(character: "X", imageName: "x"),
    Letter(character: "Y", imageName: "y"),
    Letter(character: "Z", imageName: "z")
]


let allNumbers = [
    Letter(character: "0", imageName: "0"),
    Letter(character: "1", imageName: "1"),
    Letter(character: "2", imageName: "2"),
    Letter(character: "3", imageName: "3"),
    Letter(character: "4", imageName: "4"),
    Letter(character: "5", imageName: "5"),
    Letter(character: "6", imageName: "6"),
    Letter(character: "7", imageName: "7"),
    Letter(character: "8", imageName: "8"),
    Letter(character: "9", imageName: "9"),
    Letter(character: "10", imageName:"10")
]


let allLettersAndNumbers = allLetters + allNumbers


enum MediaType {
    case video
    case image
}

// Combined array for quizzes (videos + images)
let allQuizItems: [QuizItem] = {
    var items: [QuizItem] = []
    
    // Add all signs as video items
    for sign in allSigns {
        items.append(QuizItem(
            text: sign.word,
            mediaName: sign.videoName,
            mediaType: .video
        ))
    }
    
    // Add all letters as image items
    for letter in allLetters {
        items.append(QuizItem(
            text: letter.character,
            mediaName: letter.imageName,
            mediaType: .image
        ))
    }
    
    // Add all numbers as image items
    for number in allNumbers {
        items.append(QuizItem(
            text: number.character,
            mediaName: number.imageName,
            mediaType: .image
        ))
    }
    
    return items
}()


struct QuizItem {
    let text: String
    let mediaName: String
    let mediaType: MediaType
}

