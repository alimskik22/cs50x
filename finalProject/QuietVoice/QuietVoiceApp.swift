//
//  QuietVoiceApp.swift
//  QuietVoice
//
//  Description: Main app entry point. Manages the initial launch flow
//
//  Created by Alima Karimova
//

import SwiftUI

@main
struct QuietVoiceApp: App {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var showSplash = true
    
    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation {
                                showSplash = false
                            }
                        }
                    }
            } else if !hasSeenOnboarding {
                OnboardingContainerView()
                    .onDisappear {
                        hasSeenOnboarding = true
                    }
            } else {
                HomeView()
            }
        }
    }
}
