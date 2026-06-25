//
//  StudyView.swift
//  QuietVoice
//
//  Description: Main view for studying ASL vocabulary through flashcards.
//               Features a topics grid with 5 categories arranged around a center star.
//               Topics glow yellow when completed. Tapping a topic opens FlashcardView.
//               After viewing all flashcards in a topic, shows TopicFinishedView with
//               option to take a practice quiz.
//  AI Assistance: Codex assisted with debugging navigation issues and
//                 connecting the Practice button to PracticeTopicsQuizView with preselected topic.
//
//  Created by Alima Karimova and Codex
//

import SwiftUI
import AVFoundation
import AVKit
import UIKit



// MARK: - Study View (Main Container)
struct StudyView: View {
    @State private var selectedTopic: Topic?
    @State private var showFlashcards = false
    @State private var topicFinished = false
    @State private var completedTopics: Set<String> = []
    @State private var showPracticeTopicsQuiz = false
    
    let topics = allTopics
    @StateObject private var storageManager = StorageManager()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.qvBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    if !showFlashcards {
                        TopicsGridView(
                            topics: topics,
                            completedTopics: completedTopics,
                            onTopicSelected: { topic in
                                selectedTopic = topic
                                showFlashcards = true
                            }
                        )
                        .onAppear {
                            completedTopics = storageManager.getCompletedTopics()
                        }
                    } else if let topic = selectedTopic {
                        if topicFinished {
                            TopicFinishedView(
                                topic: topic,
                                onTakeQuiz: { topicForQuiz in
                                    selectedTopic = topicForQuiz
                                    showPracticeTopicsQuiz = true
                                },
                                onBackToTopics: {
                                    // Reset to topics grid
                                    topicFinished = false
                                    selectedTopic = nil
                                    showFlashcards = false
                                }
                            )
                        } else {
                            FlashcardView(
                                topic: topic,
                                onFinish: {
                                    topicFinished = true
                                    storageManager.markTopicAsCompleted(topic.name)
                                    completedTopics = storageManager.getCompletedTopics()
                                }
                            )
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showPracticeTopicsQuiz) {
            if let topic = selectedTopic {
                PracticeTopicsQuizView(preselectedTopic: topic)
            }
        }
    }
}


// MARK: - Topics Grid View
struct TopicsGridView: View {
    let topics: [Topic]
    let completedTopics: Set<String>
    let onTopicSelected: (Topic) -> Void
    
    var body: some View {
        ZStack {
            Color.qvBackground
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                Spacer()
                Text("Study")
                    .font(.system(size: 34, weight: .semibold))
                    .foregroundColor(Color.qvPrimary)
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                
                Spacer()
                
                // Topics arranged around center star
                ZStack {
                    Image(systemName: "star.fill")
                        .font(.system(size: 85))
                        .foregroundColor(Color.qvSecondary)
                    
                    // Topics
                    ForEach(Array(topics.enumerated()), id: \.offset) { index, topic in
                        TopicButton(
                            topic: topic,
                            isCompleted: completedTopics.contains(topic.name),
                            angle: angleForIndex(index, total: topics.count),
                            onTap: { onTopicSelected(topic) }
                        )
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                Spacer()
                Spacer()
            }
        }
    }
    
    private func angleForIndex(_ index: Int, total: Int) -> Double {
        let angleStep = 360.0 / Double(total)
        return angleStep * Double(index) - 90
    }
}
// MARK: - Topic Button
struct TopicButton: View {
    let topic: Topic
    let isCompleted: Bool
    let angle: Double
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.qvSurface)
                    .frame(width: 100, height: 100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(
                                isCompleted ? Color.qvSecondary : Color.clear,
                                lineWidth: 2
                            )
                    )
                    .shadow(
                        color: isCompleted ? Color.qvSecondary.opacity(0.6) : .clear,
                        radius: 8,
                        x: 0,
                        y: 0
                    )
                
                Image(systemName: topic.icon)
                    .font(.system(size: 35))
                    .foregroundColor(Color.qvSecondary)
                    .opacity(isCompleted ? 1.0 : 0.3)
            }
            
            Text(topic.name.replacingOccurrences(of: " ", with: "\n"))
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(Color.qvSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .offset(x: 150 * cos(angle * .pi / 180), y: 150 * sin(angle * .pi / 180))
        .onTapGesture {
            onTap()
        }
    }
}
// MARK: - Looping Video Player

struct LoopingVideoPlayer: UIViewRepresentable {
    let videoName: String

    func makeUIView(context: Context) -> PlayerView {
        let view = PlayerView()

        // Try to locate an mp4 in the app bundle
        var sourceURL: URL? = Bundle.main.url(forResource: videoName, withExtension: "mp4")

        // If not found, try as a Data Asset (e.g., stored in an asset catalog)
        if sourceURL == nil, let dataAsset = NSDataAsset(name: videoName) {
            let tempURL = URL(fileURLWithPath: NSTemporaryDirectory())
                .appendingPathComponent("\(UUID().uuidString).mp4")
            do {
                try dataAsset.data.write(to: tempURL)
                sourceURL = tempURL
            } catch {
                print("Failed to write video data asset to temp file: \(error)")
            }
        }

        guard let url = sourceURL else {
            print("Video not found: \(videoName).mp4 (bundle or data asset)")
            return view
        }

        let asset = AVURLAsset(url: url)
        Task {
            do {
                let playable = try await asset.load(.isPlayable)
                guard playable else {
                    print("Asset not playable for \(videoName)")
                    return
                }
                await MainActor.run { [weak view] in
                    guard let view = view else { return }
                    let player = AVQueuePlayer()
                    let item = AVPlayerItem(asset: asset)
                    let looper = AVPlayerLooper(player: player, templateItem: item)

                    view.playerLayer.player = player
                    view.playerLayer.videoGravity = .resizeAspectFill
                    context.coordinator.looper = looper
                    player.play()
                    
                }
            } catch {
                print("Failed to load playability for \(videoName): \(error)")
            }
        }
        return view
    }

    func updateUIView(_ uiView: PlayerView, context: Context) {}
    func makeCoordinator() -> Coordinator { Coordinator() }
    
    class Coordinator { var looper: AVPlayerLooper? }
}

class PlayerView: UIView {
    override static var layerClass: AnyClass {
        AVPlayerLayer.self
    }

    var playerLayer: AVPlayerLayer {
        layer as! AVPlayerLayer
    }
}


// MARK: - Flashcard View
struct FlashcardView: View {
    let topic: Topic
    let onFinish: () -> Void
    
    @State private var currentIndex = 0
    @State private var dragOffset: CGFloat = 0
    

    var signs: [Sign] {
        topic.signs
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.qvBackground, Color.qvSurface],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 10) {
                
                Spacer()
                Text("Flashcards")
                    .font(.system(size: 34, weight: .semibold))
                    .foregroundColor(Color.qvPrimary)
                    .padding(.horizontal, 0)
                    .padding(.top, 20)
                
                Text(topic.name)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color.qvSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 0)
                
                Text("Swipe to view next flashcard")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(Color.qvSecondary.opacity(0.72))
                    .padding(.horizontal, 0)
                
                Spacer()
                Spacer()
                
                
                if signs.isEmpty {
                    Text("No signs in this topic")
                        .foregroundColor(.white)
                } else {
                    VStack(spacing: 20) {
                        if signs.indices.contains(currentIndex) {
                            LoopingVideoPlayer(videoName: signs[currentIndex].videoName)
                                .id(signs[currentIndex].videoName)
                                .frame(width: 320, height: 320)
                                .clipShape(RoundedRectangle(cornerRadius: 24))

                            Text(signs[currentIndex].word)
                                .font(.system(size: 26, weight: .semibold))
                                .foregroundColor(Color.qvSecondary)
                        } else {
                            Text("No signs available")
                                .foregroundColor(.white)
                        }
                    }
                    .offset(x: dragOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                dragOffset = gesture.translation.width
                            }
                            .onEnded { gesture in
                                if gesture.translation.width < -100 && currentIndex < signs.count - 1 {
                                    withAnimation {
                                        currentIndex += 1
                                    }
                                } else if gesture.translation.width > 100 && currentIndex > 0 {
                                    withAnimation {
                                        currentIndex -= 1
                                    }
                                }

                                if currentIndex == signs.count - 1 && gesture.translation.width < -100 {
                                    onFinish()
                                }

                                dragOffset = 0
                            }
                    )
                }
                Spacer()
                Spacer()
            }
        }
        .onAppear { currentIndex = 0 }
    }
}


// MARK: - Topic Finished View
struct TopicFinishedView: View {
    let topic: Topic
    let onTakeQuiz: (Topic) -> Void
    let onBackToTopics: () -> Void
    
    var body: some View {
        ZStack {
            Color.qvBackground
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Back button - top left
                HStack {
                    Button(action: onBackToTopics) {
                        Image(systemName: "arrow.left.circle.fill")
                            .font(.title2)
                            .foregroundColor(Color.qvPrimary)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
                Spacer()
                
                Text("Study")
                    .font(.system(size: 34, weight: .semibold))
                    .foregroundColor(Color.qvPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                
                Spacer()
                Spacer()
                
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.qvSurface)
                    .frame(width: 140, height: 140)
                    .overlay(
                        Image(systemName: "star.fill")
                            .font(.system(size: 70))
                            .foregroundColor(Color.qvSecondary)
                    )
                
                Spacer()
                
                Text(topic.name)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(Color.qvSecondary)
                
                Spacer()
                
                Text("Topic Finished! Ready for quiz?")
                    .font(.system(size: 22, weight: .regular))
                    .foregroundColor(Color.qvSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Spacer()
                Spacer()
                
                Button(action: {
                    onTakeQuiz(topic)
                }) {
                    Text("Practice")
                        .font(.headline)
                        .foregroundColor(Color.qvPrimary)
                        .frame(width: 200, height: 54)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.qvBackground)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.qvSurface, lineWidth: 1.5)
                        )
                }
                
                Spacer()
                Spacer()
            }
        }
    }
}

#Preview {
    StudyView()
}
