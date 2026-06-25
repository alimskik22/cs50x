//
//  ProgressSectionView.swift
//  QuietVoice
//
//  Description: Progress tracking view with two tabs: Fingerspelling and Flashcards.
//
//  Created by Alima Karimova
//

import SwiftUI
import AVFoundation
import UIKit

struct ProgressSectionView: View {
    @State private var selectedTab: Tab = .fingerspelling
    @State private var completedTopics: Set<String> = []
    @State private var learnedLetters: Set<String> = []
    @State private var learnedNumbers: Set<String> = []
    
    @StateObject private var storage = StorageManager()
    @Namespace private var underlineNS
    
    enum Tab: Int, CaseIterable { case  fingerspelling, flashcards }
    
    private var gradientBackground: some View {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: .qvBackground, location: 0.15),
                .init(color: .qvSecondary, location: 0.95)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
    
    private var learnedVideoSigns: [Sign] {
        let topics = allTopics.filter { completedTopics.contains($0.name) }
        return topics.flatMap { $0.signs }
    }
    
    private var learnedLetterItems: [Letter] {
        allLetters.filter { learnedLetters.contains($0.character) }
    }
    
    private var learnedNumberItems: [Letter] {
        allNumbers.filter { learnedNumbers.contains($0.character) }
    }
    
    private var totalFlashcards: Int { allSigns.count }
    private var completedFlashcards: Int { learnedVideoSigns.count }
    
    var body: some View {
        ZStack {
            gradientBackground
            
            VStack(alignment: .leading, spacing: 0) {
                // Title
                Text("Progress")
                    .font(.system(size: 34, weight: .semibold))
                    .foregroundColor(.qvPrimary)
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                
                
                Spacer()
                Spacer()
                // Tabs
                tabs
                    .padding(.horizontal, 24)
                    .padding(.top, 10)
                
                // Content
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        switch selectedTab {
                      
                            
                        case .fingerspelling:
                            FingerspellingTab(learnedLettersCount: learnedLetters.count, learnedNumbersCount: learnedNumbers.count)
                        case .flashcards:
                            FlashcardsTab(
                                completed: completedFlashcards,
                                total: totalFlashcards,
                                completedTopics: allTopics.filter { completedTopics.contains($0.name) }
                            )
                        }
                    }
                    .padding(.top, 18)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
        }
        .onAppear(perform: refresh)
    }
    
    private var tabs: some View {
        HStack(spacing: 22) {
            tabItem("Fingerspelling", .fingerspelling)
            tabItem("Flashcards", .flashcards)
        }
    }

    private func tabItem(_ title: String, _ tab: Tab) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.18)) { selectedTab = tab }
        } label: {
            VStack(spacing: 6) {
                Text(title)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(selectedTab == tab ? Color.qvSecondary : Color.qvSecondary.opacity(0.3))
                if selectedTab == tab {
                    Capsule()
                        .fill(Color.qvSecondary)
                        .frame(height: 3)
                        .matchedGeometryEffect(id: "underline", in: underlineNS)
                } else {
                    Color.clear.frame(height: 3)
                }
            }
        }
        .buttonStyle(.plain)
    }
    
    private func refresh() {
        completedTopics = storage.getCompletedTopics()
        learnedLetters = storage.getLearnedLetters()
        learnedNumbers = storage.getLearnedNumbers()
    }
}


// MARK: - Fingerspelling Tab
private struct FingerspellingTab: View {
    let learnedLettersCount: Int
    let learnedNumbersCount: Int
    
    private let totalLetters = allLetters.count
    private let totalNumbers = allNumbers.count
    
    var body: some View {
        VStack(alignment: .leading, spacing: 26) {
            Spacer()
            Spacer()
            // Alphabet
            VStack(alignment: .leading, spacing: 10) {
                Text("Alphabet:")
                    .font(.system(size: 25, weight: .semibold))
                    .foregroundColor(.qvPrimary)
                ProgressLine(value: progress(learnedLettersCount, totalLetters))
                Text("\(learnedLettersCount)/\(totalLetters)")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.qvBackground)
            }
            
            // Numbers
            VStack(alignment: .leading, spacing: 10) {
                Text("Numbers:")
                    .font(.system(size: 25, weight: .semibold))
                    .foregroundColor(.qvPrimary)
                ProgressLine(value: progress(learnedNumbersCount, totalNumbers))
                Text("\(learnedNumbersCount)/\(totalNumbers)")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.qvBackground)
            }
        }
    }
    
    private func progress(_ learned: Int, _ total: Int) -> CGFloat {
        guard total > 0 else { return 0 }
        return CGFloat(learned) / CGFloat(total)
    }
}

// MARK: - Flashcards Tab
private struct FlashcardsTab: View {
    let completed: Int
    let total: Int
    let completedTopics: [Topic]
    
    private var grid: [GridItem] { Array(repeating: GridItem(.flexible(), spacing: 16), count: 3) }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Total progress
            Text("Total:")
                .font(.system(size: 25, weight: .semibold))
                .foregroundColor(.qvPrimary)
            ProgressLine(value: progress)
            Text("\(completed)/\(total)")
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.qvBackground)
            
            // Topics Learned
            Text("Topics Learned:")
                .font(.system(size: 25, weight: .semibold))
                .foregroundColor(.qvPrimary)
                .padding(.top, 10)
            
            LazyVGrid(columns: grid, spacing: 16) {
                ForEach(completedTopics, id: \.name) { topic in
                    VStack(spacing: 10) {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.qvSurface)
                            .frame(height: 80)
                            .overlay(
                                Image(systemName: topic.icon)
                                    .font(.system(size: 28))
                                    .foregroundColor(.qvSecondary)
                            )
                            .shadow(color: Color.qvSecondary.opacity(0.6), radius: 8)
                        Text(topic.name)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.qvSecondary)
                            .shadow(color: .qvBackground, radius: 1)
                    }
                }
            }
        }
    }
    
    private var progress: CGFloat {
        guard total > 0 else { return 0 }
        return CGFloat(completed) / CGFloat(total)
    }
}

// MARK: - Progress Line (Capsule style)
private struct ProgressLine: View {
    let value: CGFloat
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.qvSurface.opacity(0.41))
                    .frame(height: 30)
                Capsule()
                    .fill(Color.qvSecondary)
                    .frame(width: max(0, min(geo.size.width * value, geo.size.width)), height: 30)
            }
        }
        .frame(height: 30)
    }
}




#Preview {
    ProgressSectionView()
}
