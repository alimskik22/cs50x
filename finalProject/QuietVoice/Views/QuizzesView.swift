//
//  QuizzesView.swift
//  QuietVoice
//
//  Description: Main hub for all quiz modes, displayed as a 2-column grid of interactive cards.
//               Features six quiz options: Sign of the Day, Quick Quiz, Random Set Quiz,
//               Missed Signs Quiz, Practice Topics, and Practice Fingerspelling.
//               Each card includes a gradient icon and title. Tapping a card presents
//               the corresponding quiz view as a sheet.
//
//  Created by Alima Karimova
//
import SwiftUI

struct QuizzesView: View {
    @State private var showSignOfTheDayQuiz = false
    @State private var showQuickQuiz = false
    @State private var showRandomSetQuiz = false
    @State private var showMissedSignsQuiz = false
    @State private var showPracticeTopicsQuiz = false
    @State private var showPracticeFingerspellingQuiz = false

    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color(hex: "#011A27"), Color(hex: "#0B5276")],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 24) {
                    // Title
                    Spacer()
                    Text("Quizzes")
                        .font(.system(size: 34, weight: .semibold))
                        .foregroundColor(Color(hex: "#F0810F"))
                        .padding(.horizontal, 24)
                        .padding(.top, 20)
                    Spacer()
                    Spacer()
                    
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            // Sign of the day
                            QuizBox(
                                icon: "calendar",
                                iconColors: [Color(hex: "#F0810F"), Color(hex: "#E6DF44")],
                                title: "Sign of the day"
                            ) {
                                showSignOfTheDayQuiz = true
                            }
                            
                            // Quick Quiz
                            QuizBox(
                                icon: "clock",
                                iconColors: [Color(hex: "#E6DF44"), Color(hex: "#807C26")],
                                title: "Quick Quiz"
                            ) {
                                showQuickQuiz = true
                            }
                            
                            // Random Set Quiz
                            QuizBox(
                                icon: "cube.transparent",
                                iconColors: [Color(hex: "#F0810F"), Color(hex: "#E6DF44")],
                                title: "Random Set Quiz"
                            ) {
                                showRandomSetQuiz = true
                            }
                            
                            // Missed Signs Quiz
                            QuizBox(
                                icon: "xmark.circle",
                                iconColors: [Color(hex: "#F0810F"), Color(hex: "#E6DF44")],
                                title: "Missed Signs Quiz"
                            ) {
                                showMissedSignsQuiz = true
                            }
                            
                            // Practice Topics - NO direct navigation here
                            QuizBox(
                                icon: "triangle",
                                iconColors: [Color(hex: "#F0810F"), Color(hex: "#E6DF44")],
                                title: "Practice Topics"
                            ) {
                                showPracticeTopicsQuiz = true
                            }
                            
                            // Practice Fingerspelling - NO direct navigation here
                            QuizBox(
                                icon: "hand.thumbsup",
                                iconColors: [Color(hex: "#E6DF44")],
                                title: "Practice Fingerspelling"
                            ) {
                                showPracticeFingerspellingQuiz = true
                            }
                        }
                        .padding(.horizontal, 10)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .sheet(isPresented: $showSignOfTheDayQuiz) {
            SignOfTheDayQuizView()
        }
        .sheet(isPresented: $showQuickQuiz) {
            QuickQuizView()
        }
        .sheet(isPresented: $showRandomSetQuiz) {
            RandomSetQuizView()
        }
        .sheet(isPresented: $showMissedSignsQuiz) {
            MissedSignsQuizView()
        }
        .sheet(isPresented: $showPracticeTopicsQuiz) {
            PracticeTopicsQuizView()
        }
        .sheet(isPresented: $showPracticeFingerspellingQuiz) {
            PracticeFingerspellingQuizView()
        }
    }
}

// MARK: - Quiz Box Component
struct QuizBox: View {
    let icon: String
    let iconColors: [Color]
    let title: String
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 32))
                    .foregroundStyle(
                        iconColors.count == 1 ?
                        AnyShapeStyle(iconColors[0]) :
                        AnyShapeStyle(
                            LinearGradient(
                                colors: iconColors,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    )
                    .frame(height: 50)
                
                Text(title)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(Color(hex: "#F0810F"))
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(hex: "#063852"))
                    .shadow(color: .qvSecondary, radius: 1)
            )
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .animation(.easeOut(duration: 0.1), value: isPressed)
        }
        .buttonStyle(.plain)
        .onLongPressGesture(minimumDuration: 0.01, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

#Preview {
    QuizzesView()
}
