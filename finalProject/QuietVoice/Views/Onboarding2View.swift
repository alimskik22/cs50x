//
//  Onboarding2View.swift
//  QuietVoice
//
//  Description: Second onboarding screen explaining what users will learn.
//
//  Created by Alima Karimova
//

import SwiftUI

struct Onboarding2View: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var navigateToNext = false
    
    let items = [
        ("star.fill", "Everyday Essentials"),
        ("star.fill", "People & Relationships"),
        ("star.fill", "Actions & Directions"),
        ("star.fill", "Fingerspelling")
    ]
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color(hex: "#011A27")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Navigation dots
                DotRow(currentPage: 1, totalPages: 3)
                    .padding(.top, 20)
                
                Spacer(minLength: 32)
                
                // stacked rectangles with stars
                VStack(spacing: 16) {
                    ForEach(items, id: \.1) { item in
                        HStack(spacing: 12) {
                            Image(systemName: item.0)
                                .font(.system(size: 20))
                                .foregroundColor(Color(hex: "#E6DF44"))
                            
                            Text(item.1)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(Color(hex: "#E6DF44"))
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(hex: "#063852"))
                        )
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer(minLength: 40)
                
                // Title and description
                VStack(alignment: .leading, spacing: 12) {
                    Text("What you'll learn")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(Color(hex: "#F0810F"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                    
                    Text("Master these essential skills at your own pace. Every sign brings you closer to real connection.")
                        .font(.system(size: 18))
                        .foregroundColor(Color(hex: "#E6DF44"))
                        .multilineTextAlignment(.leading)
                        .lineSpacing(4)
                        .padding(.horizontal, 20)
                }
                .padding(.horizontal, 14)
                
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
            Onboarding3View()
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    Onboarding2View()
}
