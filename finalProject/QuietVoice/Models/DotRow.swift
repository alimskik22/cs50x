//
//  DotRow.swift
//  QuietVoice
//
//  Description: Reusable component displaying navigation dots for onboarding screens.
//               Shows current page position with active dot highlighted in yellow (#E6DF44)
//               and inactive dots at 35% opacity. Used across all three onboarding screens.
//
//  Created by Alima Karimova
//
import SwiftUI

struct DotRow: View {
    var currentPage: Int
    var totalPages: Int
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<totalPages, id: \.self) { page in
                Circle()
                    .fill(page == currentPage ? Color(hex: "#E6DF44") : Color(hex: "#E6DF44").opacity(0.35))
                    .frame(width: 8, height: 8)
            }
        }
    }
}
