//
//  OnboardingContainerView.swift
//  QuietVoice
//
//  Description: Container view that manages the onboarding.
//
//  Created by Alima Karimova
//

import SwiftUI

struct OnboardingContainerView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var currentPage = 0
    
    var body: some View {
        TabView(selection: $currentPage) {
            Onboarding1View()
                .tag(0)
            
            Onboarding2View()
                .tag(1)
            
            Onboarding3View()
                .tag(2)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onAppear {
            // Onboarding finished
            if currentPage == 2 {
                hasSeenOnboarding = true
            }
        }
    }
}
