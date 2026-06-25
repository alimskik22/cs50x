import SwiftUI

// MARK: - Fingerspelling Main View
struct FingerspellingView: View {
    @State private var selectedTab = 0
    
    let tabs = ["Alphabet", "Numbers", "Learn"]
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                LinearGradient(
                    colors: [Color(hex: "#063852"), Color(hex: "#011A27")],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 0) {
                    // Title
                    Text("Fingerspelling")
                        .font(.system(size: 34, weight: .semibold))
                        .foregroundColor(Color(hex: "#F0810F"))
                        .padding(.horizontal, 24)
                        .padding(.top, 20)
                    
                    // Tab Bar
                    HStack(spacing: 0) {
                        ForEach(0..<tabs.count, id: \.self) { index in
                            VStack(spacing: 8) {
                                Text(tabs[index])
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(
                                        selectedTab == index ?
                                        Color(hex: "#E6DF44") :
                                        Color(hex: "#E6DF44").opacity(0.3)
                                    )
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .minimumScaleFactor(0.8)
                                    .lineLimit(1)
                                
                                // Active tab underline
                                Rectangle()
                                    .fill(
                                        selectedTab == index ?
                                        Color(hex: "#E6DF44") :
                                        Color.clear
                                    )
                                    .frame(height: 2)
                            }
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedTab = index
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                    
                    // Tab content
                    Group {
                        if selectedTab == 0 {
                            AlphabetView()
                        } else if selectedTab == 1 {
                            NumbersView()
                        } else {
                            LearnView()
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Alphabet View
struct AlphabetView: View {
    let letters = allLetters
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(Array(letters.enumerated()), id: \.offset) { index, letter in
                    VStack(spacing: 12) {
                        // Represent Image
                        Image(letter.imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 110, height: 140)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        
                        // Letter label
                        Text(letter.character)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(Color(hex: "#E6DF44"))
                    }
                    .padding(.vertical, 8)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)
            .padding(.bottom, 40)
        }
        .scrollIndicators(.hidden)
    }
}

// MARK: - Numbers View
struct NumbersView: View {
    let numbers = allNumbers
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(Array(numbers.enumerated()), id: \.offset) { index, number in
                    VStack(spacing: 12) {
                        // Image
                        Image(number.imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 110, height: 140)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        
                        // Number Label
                        Text(number.character)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(Color(hex: "#E6DF44"))
                    }
                    .padding(.vertical, 8)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)
            .padding(.bottom, 40)
        }
        .scrollIndicators(.hidden)
    }
}


// MARK: - Learn View
struct LearnView: View {
    @State private var quizMode: PracticeFingerspellingQuizView.FingerspellingMode?
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            Text("Quiz Yourself!")
                .font(.system(size: 22, weight: .regular))
                .foregroundColor(Color(hex: "#E6DF44"))
                .padding(.bottom, 40)
            
            Button(action: {
                quizMode = .alphabet
            }) {
                Text("Practice Alphabet")
                    .font(.headline)
                    .foregroundColor(Color(hex: "#F0810F"))
                    .frame(width: 220, height: 54)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color(hex: "#011A27"))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color(hex: "#063852"), lineWidth: 1.5)
                    )
            }
            
            Spacer(minLength: 20)
            
            Button(action: {
                quizMode = .numbers
            }) {
                Text("Practice Numbers")
                    .font(.headline)
                    .foregroundColor(Color(hex: "#F0810F"))
                    .frame(width: 220, height: 54)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color(hex: "#011A27"))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color(hex: "#063852"), lineWidth: 1.5)
                    )
            }
            
            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(item: $quizMode) { mode in
            PracticeFingerspellingQuizView(selectedMode: mode)
        }
    }
}

#Preview {
    FingerspellingView()
}
