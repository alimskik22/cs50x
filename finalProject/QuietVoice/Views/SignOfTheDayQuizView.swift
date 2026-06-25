//
//  SignOfTheDayQuizView.swift
//  QuietVoice
//
//  Description: Daily quiz mode presenting one random sign from allSigns.
//               Features deterministic selection based on day of year (same sign for all users on same date).
//               Tracks wrong answers for Missed Signs Quiz via StorageManager.
//
//  AI Assistance: DeepSeek assisted with deterministic sign selection logic,
//                 and StorageManager integration.
//
//  Created by Alima Karimova and DeepSeek
//
import SwiftUI

struct SignOfTheDayQuizView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedOption: String?
    @State private var isCorrect: Bool?
    @State private var showCloseButton = false
    @State private var question: Question?
    @StateObject private var storageManager = StorageManager()
    
    private let quizLogic = QuizLogic()
    
    // Get random sign of the day
    private let signOfTheDay: Sign = {
        let calendar = Calendar.current
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let index = (dayOfYear - 1) % allSigns.count
        return allSigns[index]
    }()
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "#011A27"), Color(hex: "#0B5276")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Close button
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(Color(hex: "#F0810F"))
                            .background(
                                Circle()
                                    .fill(Color(hex: "#011A27"))
                                    .frame(width: 30, height: 30)
                            )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 60)
                
                Text("Choose the closest match")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color(hex: "#011A27"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color(hex: "#E6DF44"))
                
                Spacer()
                
                // Sign media
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color(hex: "#063852"))
                        .frame(width: 250, height: 250)
                    
                    LoopingVideoPlayer(videoName: signOfTheDay.videoName)
                        .id(signOfTheDay.videoName)
                        .frame(width: 250, height: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                }
                
                // Options
                if let question = question {
                    VStack(spacing: 16) {
                        ForEach(question.options, id: \.self) { option in
                            Button(action: {
                                handleAnswer(option)
                            }) {
                                Text(option)
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(Color(hex: "#011A27"))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(
                                        RoundedRectangle(cornerRadius: 14)
                                            .fill(optionColor(for: option))
                                    )
                            }
                            .disabled(selectedOption != nil)
                        }
                    }
                    .padding(.horizontal, 40)
                }
                
                // Close button
                if showCloseButton {
                    Button(action: { dismiss() }) {
                        Text("CLOSE")
                            .font(.headline)
                            .foregroundColor(Color(hex: "#F0810F"))
                            .frame(width: 200, height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color(hex: "#011A27"))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color(hex: "#063852"), lineWidth: 1.5)
                            )
                    }
                    .padding(.top, 20)
                }
                
                Spacer()
                Spacer()
            }
        }
        .onAppear {
            generateQuestion()
        }
    }
    
    private func generateQuestion() {
        question = quizLogic.generateQuestion(from: signOfTheDay, allSigns: allSigns)
    }
    
    private func optionColor(for option: String) -> Color {
        guard let selected = selectedOption else {
            return Color(hex: "#E6DF44").opacity(0.54)
        }
        
        guard let question = question else {
            return Color(hex: "#E6DF44").opacity(0.54)
        }
        
        // Show correct answer in green if user tapped wrong
        if option == question.correctAnswer && selected != question.correctAnswer && isCorrect == false {
            return Color(hex: "#54E644").opacity(0.54)
        }
        
        if selected == option {
            if let correct = isCorrect {
                if correct {
                    return Color(hex: "#54E644").opacity(0.54)
                } else {
                    return Color(hex: "#E66F44").opacity(0.54)
                }
            }
        }
        
        return Color(hex: "#E6DF44").opacity(0.54)
    }
    
    

    private func handleAnswer(_ option: String) {
        guard let question = question else { return }
        
        selectedOption = option
        let correct = quizLogic.checkAnswer(selected: option, correct: question.correctAnswer)
        isCorrect = correct
        showCloseButton = true
        
        if !correct {
            storageManager.incrementMissedCount(for: question.correctAnswer)
        }
    }
}

#Preview {
    SignOfTheDayQuizView()
}
