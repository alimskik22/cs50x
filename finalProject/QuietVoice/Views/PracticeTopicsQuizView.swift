//
//  PracticeTopicsQuizView.swift
//  QuietVoice
//
//  Description: Quiz view for practicing vocabulary from specific topics.
//               Features a selection screen displaying all 5 topics with visual cards showing topic icons.
//               Topics glow yellow when previously completed. Selected topic gets yellow border.
//               Supports direct opening from Study section when a user finishes a topic,
//               bypassing the selection screen and loading the quiz immediately.
//
//  AI Assistance: DeepSeek assisted with
//                 direct navigation with preselectedTopic parameter, and question generation.
//
//  Created by Alima Karimova and DeepSeek
//

import SwiftUI

struct PracticeTopicsQuizView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTopic: Topic?
    @State private var showQuiz = false
    @State private var questions: [Question] = []
    @State private var currentIndex = 0
    @State private var selectedOption: String?
    @State private var isAnswered = false
    @State private var isCorrect: Bool?
    @State private var showScoreScreen = false
    @State private var score = 0
    @State private var progress: CGFloat = 0.0
    @State private var completedTopics: Set<String> = []
    
    @StateObject private var storageManager = StorageManager()
    private let quizLogic = QuizLogic()
    
    init(preselectedTopic: Topic? = nil) {
        _selectedTopic = State(initialValue: preselectedTopic)
        _showQuiz = State(initialValue: preselectedTopic != nil)
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "#011A27"), Color(hex: "#0B5276")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            if showQuiz, let topic = selectedTopic {
                // Quiz Screen
                if showScoreScreen {
                    PracticeScoreScreenView(
                        topicName: topic.name,
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
                    quizContent
                }
            } else {
                // Topic Selection Screen
                topicSelectionView
            }
        }
        .onAppear {
            if showQuiz, questions.isEmpty, let topic = selectedTopic {
                loadQuiz(for: topic)
            }
        }
    }
    
    // MARK: - Topic Selection View
    private var topicSelectionView: some View {
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
            
            Spacer()
            
            // header
            Text("Choose a topic to practice")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(Color(hex: "#011A27"))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color(hex: "#E6DF44"))
                .padding(.horizontal, 0)
            
            Spacer()
            
            // Topics grid
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                ForEach(allTopics) { topic in
                    TopicSelectionCard(
                        topic: topic,
                        isCompleted: completedTopics.contains(topic.name),
                        isSelected: selectedTopic?.name == topic.name,
                        onTap: {
                            selectedTopic = topic
                        }
                    )
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            // Next button
            Button(action: {
                if let topic = selectedTopic {
                    loadQuiz(for: topic)
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
            .disabled(selectedTopic == nil)
            .opacity(selectedTopic == nil ? 0.5 : 1.0)
            .padding(.bottom, 40)
            
            Spacer()
        }
        .onAppear {
            completedTopics = storageManager.getCompletedTopics()
        }
    }
    
    // MARK: - Quiz Content
    private var quizContent: some View {
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
            
            // Video media
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(hex: "#063852"))
                    .frame(width: 250, height: 250)
                
                LoopingVideoPlayer(videoName: questions[currentIndex].mediaName)
                    .id(questions[currentIndex].mediaName)
                    .frame(width: 250, height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
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
    
    private func loadQuiz(for topic: Topic) {
        questions = topic.signs.map { sign in
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
        if let topic = selectedTopic {
            loadQuiz(for: topic)
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

// MARK: - Topic Selection Card
struct TopicSelectionCard: View {
    let topic: Topic
    let isCompleted: Bool
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(hex: "#063852"))
                        .frame(width: 100, height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(
                                    isSelected ? Color(hex: "#E6DF44") : Color.clear,
                                    lineWidth: 3
                                )
                        )
                    
                    Image(systemName: topic.icon)
                        .font(.system(size: 40))
                        .foregroundColor(Color(hex: "#E6DF44"))
                        .shadow(
                            color: isCompleted ? Color(hex: "#E6DF44").opacity(0.6) : .clear,
                            radius: 8
                        )
                }
                
                Text(topic.name)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color(hex: "#E6DF44"))
                    .multilineTextAlignment(.center)
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Practice Score Screen
struct PracticeScoreScreenView: View {
    let topicName: String
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
            
            Text(topicName)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color(hex: "#E6DF44"))
            
            Text(message)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(Color(hex: "#E6DF44"))
            
            Spacer()
            
            // Practice Again button
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
    PracticeTopicsQuizView()
}

