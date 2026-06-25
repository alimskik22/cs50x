//
//  SplashView.swift
//  QuietVoice
//
//  Description: Launch screen displayed when the app first opens.
//
//  AI Assistance: Codex assisted with precise RGB conversion for brand colors
//                 (converting hex #011A27, #F0810F, #E6DF44, #063852 to 0-1 scale values).
//
//  Created by Alima Karimova and Codex
//

import SwiftUI

// MARK: - Brand Palette
extension Color {
    // Background: #011A27 (dark blue)
    static let qvBackground = Color(red: 0.0039215686, green: 0.1019607843, blue: 0.1529411765)
    // Primary accent: #F0810F (orange)
    static let qvPrimary    = Color(red: 0.9411764706, green: 0.5058823529, blue: 0.0588235294)
    // Secondary accent: #E6DF44 (yellow)
    static let qvSecondary  = Color(red: 0.9019607843, green: 0.8745098039, blue: 0.2666666667)
    // Surface/cards: #063852 (medium blue)
    static let qvSurface    = Color(red: 0.0235294118, green: 0.2196078431, blue: 0.3215686275)
}

// MARK: - Splash View
struct SplashView: View {
    var onFinish: (() -> Void)? = nil
    var logoAssetName: String = "logo"
    var logoSize: CGFloat = 270
    

    private var logoView: some View {
        Image(logoAssetName)
            .resizable()
            .renderingMode(.original)
            .interpolation(.high)
            .antialiased(true)
            .scaledToFit()
            .frame(width: logoSize, height: logoSize)
    }

    var body: some View {
        ZStack {
            Color.qvBackground
                .ignoresSafeArea()

            logoView
                .accessibilityHidden(true)
        }
        .preferredColorScheme(.dark)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("QuietVoice")
        .accessibilityHint("Splash screen")
    }
}

#Preview("Splash") {
    SplashView()
}

