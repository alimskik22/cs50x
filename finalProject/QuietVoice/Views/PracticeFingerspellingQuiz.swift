//
//  PracticeFingerspellingQuiz.swift
//  QuietVoice
//
//  Description: Quiz view for practicing fingerspelling alphabet and numbers
//               Features a selection screen where users choose between alphabet or numbers,
//               followed by a quiz with questions generated from the selected dataset.
//               Each question displays a handshape image and presents 4 multiple-choice options.
//               Tracks performance using StorageManager for missed sign counts.
//               Score screen shows results with "Practice Again" option to retry same mode.
//
//  AI Assistance: DeepSeek assisted with quiz logic, question generation for letters/numbers,
//                 and StorageManager integration for missed sign tracking.
//
//  Created by Alima Karimova and DeepSeek
//

import SwiftUI

struct PracticeFingerspellingQuizView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedMode: FingerspellingMode?
    @State private var showQuiz = false
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
    
    enum FingerspellingMode: String, CaseIterable, Identifiable {
        case alphabet = "Alphabet"
        case numbers = "Numbers"
        var id: String { rawValue }
    }
    
    // initializer for direct opening from Learn tab
    init(selectedMode: FingerspellingMode? = nil) {
        if let mode = selectedMode {
            self._selectedMode = State(initialValue: mode)
            self._showQuiz = State(initialValue: true)
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "#011A27"), Color(hex: "#0B5276")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            if showQuiz, let mode = selectedMode {
                if showScoreScreen {
                    PracticeFingerspellingScoreScreenView(
                        mode: mode,
                        score: score,
                        total: questions.count,
                        onClose: { dismiss() },
                        onPracticeAgain: {
                            resetQuiz()
                        }
                    )
                } else if questions.isEmpty {
                    ProgressView()
                        .tint(Color(hex: "#F0810F"))
                } else {
                    quizContent(for: mode)
                }
            } else {
                selectionView
            }
        }
        .onAppear {
            if showQuiz, questions.isEmpty, let mode = selectedMode {
                loadQuiz(for: mode)
            }
        }
    }
    
    // MARK: - Selection View
    private var selectionView: some View {
        
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
            
            
            // header
            Text("What do you want to practice?")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(Color(hex: "#011A27"))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color(hex: "#E6DF44"))
                .padding(.horizontal, 0)
            
            Spacer()
            
            // selection boxes
            HStack(spacing: 40) {
                ForEach(FingerspellingMode.allCases, id: \.self) { mode in
                    Button(action: {
                        selectedMode = mode
                    }) {
                        VStack(spacing: 16) {
                            Image(systemName: mode == .alphabet ? "character.book.closed" : "number.circle")
                                .font(.system(size: 50))
                                .foregroundColor(Color(hex: "#E6DF44"))
                            
                            Text(mode.rawValue)
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundColor(Color(hex: "#E6DF44"))
                        }
                        .frame(width: 140, height: 140)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(selectedMode == mode ? Color(hex: "#063852") : Color(hex: "#063852").opacity(0.5))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(selectedMode == mode ? Color(hex: "#E6DF44") : Color.clear, lineWidth: 3)
                                )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            
            Spacer()
            
            
            // next button
            Button(action: {
                if let mode = selectedMode {
                    loadQuiz(for: mode)
                    showQuiz = true
                }
            }) {
                Text("NEXT")
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
            .disabled(selectedMode == nil)
            .opacity(selectedMode == nil ? 0.5 : 1.0)
            .padding(.bottom, 40)
            
            Spacer()
        }
    }
    
    // MARK: - Quiz Content
    @ViewBuilder
    private func quizContent(for mode: FingerspellingMode) -> some View {
        VStack(spacing: 20) {
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
            Spacer()
            
            // header with question counter
            HStack {
                Text("What sign is this?")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Color(hex: "#011A27"))
                
                Spacer()
                
                Text("\(currentIndex + 1)/\(questions.count)")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Color(hex: "#011A27"))
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(Color(hex: "#E6DF44"))
            
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
            
            // Image media
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(hex: "#063852"))
                    .frame(width: 250, height: 250)
                
                Image(questions[currentIndex].mediaName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220, height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
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
    
    private func loadQuiz(for mode: FingerspellingMode) {
        let items: [Letter]
        switch mode {
        case .alphabet:
            items = allLetters
        case .numbers:
            items = allNumbers
        }
        
        questions = items.map { item in
            generateQuestionForLetter(item, mode: mode)
        }
        questions.shuffle()
        updateProgress()
    }
    
    private func generateQuestionForLetter(_ letter: Letter, mode: FingerspellingMode) -> Question {
        let allItems = mode == .alphabet ? allLetters : allNumbers
        let wrongItems = allItems.filter { $0.character != letter.character }.shuffled().prefix(3)
        let wrongChars = wrongItems.map { $0.character }
        let allOptions = ([letter.character] + wrongChars).shuffled()
        
        return Question(
            text: "What sign is this?",
            correctAnswer: letter.character,
            options: allOptions,
            mediaName: letter.imageName,
            mediaType: .image
        )
    }
    
    private func updateProgress() {
        progress = CGFloat(currentIndex) / CGFloat(questions.count)
    }
    
    private func handleAnswer(_ option: String) {
        guard !isAnswered else { return }
        
        let question = questions[currentIndex]
        let correct = (option == question.correctAnswer)
        
        selectedOption = option
        isCorrect = correct
        isAnswered = true
        
        if correct {
            // Mark learned in storage
            switch questions[currentIndex].mediaType {
            case .image:
                // Determine if this was alphabet or numbers by checking the selectedMode and label shape
                if let mode = selectedMode {
                    if mode == .alphabet {
                        storageManager.markLetterLearned(questions[currentIndex].correctAnswer)
                    } else {
                        storageManager.markNumberLearned(questions[currentIndex].correctAnswer)
                    }
                }
            default:
                break
            }
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
        if let mode = selectedMode {
            loadQuiz(for: mode)
        }
    }
    
    private func nextQuestion() {
        guard isAnswered else { return }
        
        if currentIndex + 1 < questions.count {
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

// MARK: - Practice Fingerspelling Score Screen
struct PracticeFingerspellingScoreScreenView: View {
    let mode: PracticeFingerspellingQuizView.FingerspellingMode
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
            return "Perfect!"
        } else if percentage >= 70 {
            return "Good job!"
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
            
            Text(mode.rawValue)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color(hex: "#E6DF44"))
            
            Text(message)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(Color(hex: "#E6DF44"))
            
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
    PracticeFingerspellingQuizView()
}

