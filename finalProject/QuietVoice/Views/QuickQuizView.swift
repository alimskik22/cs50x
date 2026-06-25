//
//  QuickQuizView.swift
//  QuietVoice
//
//  Description: Quiz mode that presents 5 random questions from the quiz pool
//               Tracks missed answers for Missed Signs Quiz via StorageManager.
//
//  AI Assistance: DeepSeek assisted with question generation and StorageManager integration.
//
//  Created by Alima Karimova and DeepSeek
//

import SwiftUI

struct QuickQuizView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var questions: [Question] = []
    @State private var currentIndex = 0
    @State private var selectedOption: String?
    @State private var isAnswered = false
    @State private var isCorrect: Bool?
    @State private var showScoreScreen = false
    @State private var score = 0
    @State private var progress: CGFloat = 0.0
    
    @StateObject private var storageManager = StorageManager()

    
    private let quizLogic = QuizLogic()
    private let totalQuestions = 5
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "#011A27"), Color(hex: "#0B5276")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            if showScoreScreen {
                ScoreScreenView(
                    score: score,
                    total: totalQuestions,
                    onClose: { dismiss() }
                )
            } else if questions.isEmpty {
                // Loading state
                ProgressView()
                    .tint(Color(hex: "#F0810F"))
            } else {
                // Quiz content
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
                    
                    //header with question counter
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
            generateQuestions()
        }
    }
    
    private func generateQuestions() {
        // Get 5 random items
        let randomItems = allQuizItems.shuffled().prefix(totalQuestions)
        
        questions = randomItems.map { item in
            Question(
                text: "What sign is this?",
                correctAnswer: item.text,
                options: generateRandomOptions(correct: item.text),
                mediaName: item.mediaName,
                mediaType: item.mediaType
            )
        }
        
        updateProgress()
    }

    private func generateRandomOptions(correct: String) -> [String] {
        // Get random wrong answers from allQuizItems (excluding correct)
        let wrongItems = allQuizItems.filter { $0.text != correct }.shuffled().prefix(3)
        let wrongAnswers = wrongItems.map { $0.text }
        let allOptions = [correct] + wrongAnswers
        return allOptions.shuffled()
    }
    
    private func updateProgress() {
        progress = CGFloat(currentIndex) / CGFloat(totalQuestions)
    }
    
    private func handleAnswer(_ option: String) {
        guard !isAnswered else { return }
        
        let question = questions[currentIndex]
        let correct = quizLogic.checkAnswer(selected: option, correct: question.correctAnswer)
        
        selectedOption = option
        isCorrect = correct
        isAnswered = true
        
        if correct {
            score += 1
        } else {
            storageManager.incrementMissedCount(for: question.correctAnswer)
        }
    }
    
    private func optionColor(for option: String) -> Color {
        guard isAnswered else {
            return Color(hex: "#E6DF44").opacity(0.54)
        }
        
        let question = questions[currentIndex]
        
        // Show correct answer in green
        if option == question.correctAnswer {
            return Color(hex: "#54E644").opacity(0.54)
        }
        
        // Show user's wrong answer in light-red
        if option == selectedOption && isCorrect == false {
            return Color(hex: "#E66F44").opacity(0.54)
        }
        
        return Color(hex: "#E6DF44").opacity(0.54)
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

// MARK: - Score Screen
struct ScoreScreenView: View {
    let score: Int
    let total: Int
    let onClose: () -> Void
    
    private var percentage: Int {
        Int((Double(score) / Double(total)) * 100)
    }
    
    private var message: String {
        switch percentage {
        case 90...100:
            return "Excellent!"
        case 70...89:
            return "Good job!"
        default:
            return "Keep practicing!"
        }
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // header
            Text("Your Score")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(Color(hex: "#011A27"))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color(hex: "#E6DF44"))
                .padding(.horizontal, 0)
            
            Spacer()
            
            // Score square
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(hex: "#F0810F"))
                .frame(width: 150, height: 150)
                .overlay(
                    Text("\(score)/\(total)")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(Color(hex: "#011A27"))
                )
            
            // Message
            Text(message)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color(hex: "#E6DF44"))
            
            Spacer()
            
            // Close button
            Button(action: onClose) {
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
    QuickQuizView()
}
