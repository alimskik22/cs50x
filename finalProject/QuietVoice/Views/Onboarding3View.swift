//
//  Onboarding3View.swift
//  QuietVoice
//
//  Description: Final onboarding screen that marks onboarding as completed.
//
//  Created by Alima Karimova
//

import SwiftUI

struct Onboarding3View: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var navigateToHome = false
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            LinearGradient(
                colors: [Color(hex: "#011A27"), Color(hex: "#063852")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Navigation dots 
                DotRow(currentPage: 2, totalPages: 3)
                    .padding(.top, 20)
                
                Spacer()
                
                // Title and description
                VStack(alignment: .leading, spacing: 12) {
                    Text("Let's Begin")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(Color(hex: "#F0810F"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                    
                    Text("Everything you need to start learning ASL is right here!")
                        .font(.system(size: 18))
                        .foregroundColor(Color(hex: "#E6DF44"))
                        .multilineTextAlignment(.leading)
                        .lineSpacing(4)
                        .padding(.horizontal, 20)
                }
                .padding(.horizontal, 14)
                
                Spacer()
                
                // Get Started button
                Button(action: {
                    hasSeenOnboarding = true
                    navigateToHome = true
                }) {
                    Text("Get Started")
                        .font(.headline)
                        .foregroundColor(Color(hex: "#F0810F"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color(hex: "#011A27"))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color(hex: "#063852"), lineWidth: 1.5)
                        )
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
            
            // Skip button
            Button(action: {
                hasSeenOnboarding = true
                navigateToHome = true
            }) {
                Text("Skip")
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: "#F0810F"))
            }
            .padding(.trailing, 20)
            .padding(.top, 16)
        }
        .fullScreenCover(isPresented: $navigateToHome) {
            HomeView()
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    Onboarding3View()
}
