//
//  Onboarding1View.swift
//  QuietVoice
//
//  Description: First of three onboarding screens.
//
//  Created by Alima Karimova
//
import SwiftUI

struct Onboarding1View: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var navigateToNext = false
    
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
                DotRow(currentPage: 0, totalPages: 3)
                    .padding(.top, 20)
                
                // Welcome image
                Image("welcome")
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 0)
                    .padding(.top, 18)
                
                Spacer(minLength: 32)
                
                // Title and description
                VStack(alignment: .leading, spacing: 16) {
                    Text("Welcome to QuietVoice")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(Color(hex: "#F0810F"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                    
                    Text("Start your journey into ASL today. Learn at your own pace, anywhere, anytime.")
                        .font(.system(size: 18))
                        .foregroundColor(Color(hex: "#E6DF44"))
                        .multilineTextAlignment(.leading)
                        .lineSpacing(4)
                        .padding(.horizontal, 20)
                }
                .padding(.horizontal, 16)
                
                Spacer()
                
                // Continue button
                Button(action: {
                    navigateToNext = true
                }) {
                    Text("Continue")
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
                navigateToNext = true
            }) {
                Text("Skip")
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: "#F0810F"))
            }
            .padding(.trailing, 20)
            .padding(.top, 16)
        }
        .fullScreenCover(isPresented: $navigateToNext) {
            Onboarding2View()
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    Onboarding1View()
}
