//
//  MIssedSignsQuizView.swift
//  QuietVoice
//
//  Description: Quiz mode that tests users only on signs they previously answered incorrectly.
//               Questions are dynamically generated from StorageManager's missed counts.
//               Correct answers automatically remove the sign from missed list.
//               Displays friendly message when no missed signs exist.
//
//
//  Created by Alima Karimova
//

import SwiftUI

struct MissedSignsQuizView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var storageManager = StorageManager()
    @State private var questions: [Question] = []
    @State private var currentIndex = 0
    @State private var selectedOption: String?
    @State private var isAnswered = false
    @State private var isCorrect: Bool?
    @State private var showScoreScreen = false
    @State private var score = 0
    @State private var progress: CGFloat = 0.0
    @State private var missedSignsList: [Sign] = []
    
    private var totalQuestions: Int {
        questions.count
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "#011A27"), Color(hex: "#0B5276")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            if showScoreScreen {
                MissedScoreScreenView(
                    score: score,
                    total: totalQuestions,
                    onClose: { dismiss() },
                    onPracticeAgain: {
                        resetQuiz()
                    }
                )
            } else if questions.isEmpty {
                VStack(spacing: 20) {
                    Text("No missed signs yet!")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color(hex: "#E6DF44"))
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Text("Keep practicing other quizzes to build your missed signs list.")
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "#E6DF44").opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
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
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                VStack(spacing: 20) {
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
                    
                    
                    
                    // Yellow header with dynamic counter
                    HStack {
                        Text("What sign is this?")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(Color(hex: "#011A27"))
                        
                        Spacer()
                        
                        Text("\(currentIndex + 1)/\(totalQuestions)")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(Color(hex: "#011A27"))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color(hex: "#E6DF44"))
                    .padding(.horizontal, 0)
                    
                    
                    
                    // Progress bar
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color(hex: "#E6DF44").opacity(0.54))
                                .frame(height: 8)
                                .cornerRadius(4)
                            
                            Rectangle()
                                .fill(Color(hex: "#F0810F"))
                                .frame(width: geometry.size.width * progress, height: 8)
                                .cornerRadius(4)
                                .animation(.easeInOut(duration: 0.3), value: progress)
                        }
                    }
                    .frame(height: 8)
                    .padding(.horizontal, 20)
                    
                    // Sign media
                    ZStack {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color(hex: "#063852"))
                            .frame(width: 250, height: 250)
                        
                        if questions[currentIndex].mediaType == .video {
                            LoopingVideoPlayer(videoName: questions[currentIndex].mediaName)
                                .id(questions[currentIndex].mediaName)
                                .frame(width: 250, height: 250)
                                .clipShape(RoundedRectangle(cornerRadius: 24))
                        } else {
                            Image(questions[currentIndex].mediaName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 250, height: 250)
                                .clipShape(RoundedRectangle(cornerRadius: 24))
                        }
                    }
                    
                    // Options
                    VStack(spacing: 16) {
                        ForEach(questions[currentIndex].options, id: \.self) { option in
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
                            .disabled(isAnswered)
                        }
                    }
                    .padding(.horizontal, 40)
                    
                    // Next button
                    Button(action: {
                        nextQuestion()
                    }) {
                        Text("Next")
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
                    .disabled(!isAnswered)
                    .opacity(isAnswered ? 1.0 : 0.5)
                    
                    Spacer()
                    Spacer()
                }
            }
        }
        .onAppear {
            loadMissedSigns()
        }
    }
    
    private func loadMissedSigns() {
        let missedCounts = storageManager.getMissedCounts()
        let missedSignWords = Set(missedCounts.keys)
        
        // Get signs that have been missed at least once
        missedSignsList = allSigns.filter { missedSignWords.contains($0.word) }
        
        if !missedSignsList.isEmpty {
            generateQuestions()
        }
    }
    
    private func generateQuestions() {
        questions = missedSignsList.map { sign in
            generateQuestionForSign(sign)
        }
        updateProgress()
    }
    
    private func generateQuestionForSign(_ sign: Sign) -> Question {
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
    
    private func updateProgress() {
        progress = CGFloat(currentIndex) / CGFloat(totalQuestions)
    }
    
    private func handleAnswer(_ option: String) {
        guard !isAnswered else { return }
        
        let question = questions[currentIndex]
        let correct = (option == question.correctAnswer)
        
        selectedOption = option
        isCorrect = correct
        isAnswered = true
        
        if correct {
            score += 1
            // If answered correctly, remove from missed signs
            storageManager.resetMissedCount(for: question.correctAnswer)
        }
    }
    
    private func optionColor(for option: String) -> Color {
        guard isAnswered else {
            return Color(hex: "#E6DF44").opacity(0.54)
        }
        
        let question = questions[currentIndex]
        
        if option == question.correctAnswer {
            return Color(hex: "#54E644").opacity(0.54)
        }
        
        if option == selectedOption && isCorrect == false {
            return Color(hex: "#E66F44").opacity(0.54)
        }
        
        return Color(hex: "#E6DF44").opacity(0.54)
    }
    
    private func resetQuiz() {
        currentIndex = 0
        score = 0
        selectedOption = nil
        isAnswered = false
        isCorrect = nil
        showScoreScreen = false
        loadMissedSigns()
        updateProgress()
    }
    
    private func nextQuestion() {
        guard isAnswered else { return }
        
        if currentIndex + 1 < totalQuestions {
            currentIndex += 1
            selectedOption = nil
            isAnswered = false
            isCorrect = nil
            updateProgress()
        } else {
            showScoreScreen = true
        }
    }
}

// MARK: - Missed Score Screen
struct MissedScoreScreenView: View {
    let score: Int
    let total: Int
    let onClose: () -> Void
    let onPracticeAgain: () -> Void
    
    private var percentage: Int {
        guard total > 0 else { return 0 }
        return Int((Double(score) / Double(total)) * 100)
    }
    
    private var message: String {
        if percentage == 100 {
            return "Perfect! You mastered them all!"
        } else if percentage >= 70 {
            return "Great improvement!"
        } else {
            return "Keep practicing!"
        }
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Text("Your Score")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(Color(hex: "#011A27"))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color(hex: "#E6DF44"))
                .padding(.horizontal, 0)
            
            Spacer()
            
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(hex: "#F0810F"))
                .frame(width: 150, height: 150)
                .overlay(
                    Text("\(score)/\(total)")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(Color(hex: "#011A27"))
                )
            
            Text(message)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color(hex: "#E6DF44"))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            Spacer()
            
            Button(action: onPracticeAgain) {
                Text("PRACTICE AGAIN")
                    .font(.headline)
                    .foregroundColor(Color(hex: "#F0810F"))
                    .frame(width: 220, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color(hex: "#011A27"))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color(hex: "#063852"), lineWidth: 1.5)
                    )
            }
            

            Button(action: onClose) {
                Text("CLOSE")
                    .font(.headline)
                    .foregroundColor(Color(hex: "#E6DF44"))
                    .frame(width: 220, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color(hex: "#011A27"))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color(hex: "#063852"), lineWidth: 1.5)
                    )
            }
            
            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [Color(hex: "#011A27"), Color(hex: "#0B5276")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }
}

#Preview {
    MissedSignsQuizView()
}
