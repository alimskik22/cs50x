//
//  HomeView.swift
//  QuietVoice
//
//  AI Assistance: Article text content was generated with
//                 assistance from ChatGPT and then reviewed and formatted by me.
//
//  Created by Alima Karimova and ChatGPT
//

import SwiftUI

// MARK: - Article Model
struct Article: Identifiable {
    let id = UUID()
    let title: String
    let content: String
    let gradientColors: [Color]
    let sheetColors: [Color]
}

// MARK: - Home View

struct HomeView: View {
    @State private var selectedTab = 0
    @State private var selectedArticle: Article?
    
    let articles: [Article] = [
        Article(title: "The History of ASL", content: "American Sign Language (ASL) is one of the most widely used sign languages in the world. It is a complete natural language with its own grammar and structure, not simply English expressed through hand signs.\n\nThe roots of ASL go back to the early 1800s. Before formal Deaf education existed in America, many Deaf people used local sign systems or \"home signs\" to communicate. A major turning point came when Thomas Hopkins Gallaudet traveled to Europe to study methods for teaching Deaf students. In France, he met Laurent Clerc, a Deaf teacher who used French Sign Language.\n\nIn 1817, they founded the American School for the Deaf, the first permanent school for Deaf students in the United States. Over time, French Sign Language mixed with local American signing systems, leading to the development of ASL.\n\nDuring the late 19th century, sign language faced major challenges. After the Second International Congress on Education of the Deaf, many schools began banning sign language and forcing Deaf students to rely on speech and lip-reading. Even so, Deaf communities continued using ASL in daily life, helping the language survive.\n\nIn the 1960s, linguist William Stokoe proved that ASL had its own grammar and linguistic rules, helping it gain recognition as a real language.\n\nToday, ASL is more than a communication system — it is an important part of Deaf culture, identity, and history.", gradientColors: [Color(hex: "#CA8034"), Color(hex: "#D9D45A")], sheetColors: [Color(hex: "#CA8034"), Color(hex: "#D9D45A")]),
        Article(title: "ASL in Education", content: "American Sign Language (ASL) plays an important role in Deaf education. For many Deaf and hard-of-hearing students, ASL provides a natural and effective way to learn, communicate, and express ideas. Unlike spoken language methods that depend mainly on hearing, ASL allows students to access information visually.\n\nThe use of ASL in education began to grow after the founding of the American School for the Deaf in 1817. Schools for Deaf students used sign language to teach subjects such as reading, math, and science. However, during the late 1800s, many schools stopped using sign language after the Second International Congress on Education of the Deaf promoted oral education, which focused only on speech and lip-reading.\n\nOver time, educators realized that many Deaf students learned more successfully when ASL was included in the classroom. Today, many schools and universities recognize ASL as an important educational tool and even offer ASL courses as foreign language credits.\n\nASL in education is not only about communication. It also supports academic growth, confidence, social connection, and Deaf culture. By using ASL, schools can create a more accessible and inclusive learning environment for Deaf students.", gradientColors: [Color(hex: "#307BA2"), Color(hex: "#043D5A")], sheetColors: [Color(hex: "#307BA2"), Color(hex: "#043D5A")]),
        Article(title: "Innovations in ASL", content: "Innovations in American Sign Language (ASL) have improved communication, education, and accessibility for Deaf and hard-of-hearing individuals. Technology has made ASL more visible and easier to use in everyday life.\n\nOne important innovation is video communication. Video calling apps such as Zoom and video relay services allow people to communicate using ASL from different locations. This has made communication faster and more accessible.\n\nAnother major development is the use of ASL in digital education. Online ASL classes, mobile apps, and interactive dictionaries help both Deaf and hearing people learn sign language more easily. Many schools and universities now include ASL courses in their programs.\n\nArtificial intelligence and motion-recognition technology are also being explored to improve sign language translation and accessibility tools. In addition, captions and interpreters are now more common in television, social media, and public events, increasing awareness of Deaf culture and ASL.\n\nThese innovations continue to support inclusion and create more opportunities for communication and learning through ASL.", gradientColors: [Color(hex: "#3943D0"), Color(hex: "#CDCA80")], sheetColors: [Color(hex: "#3943D0"), Color(hex: "#CDCA80")]),
        Article(title: "Deaf Culture", content: "Deaf culture is a community and way of life shared by many Deaf and hard-of-hearing people. It is centered around American Sign Language (ASL), shared experiences, traditions, values, and visual communication.\n\nFor many people in the Deaf community, Deafness is not viewed as a disability, but as a cultural identity. Communication through ASL plays an important role in building connections and expressing ideas, emotions, and stories.\n\nDeaf culture values eye contact, facial expressions, and clear visual communication. Community events, schools for Deaf students, social gatherings, and organizations help strengthen relationships within the Deaf community.\n\nEducation and history are also important parts of Deaf culture. Despite periods when sign language was banned in schools, Deaf communities continued to preserve ASL and pass it to future generations.\n\nToday, Deaf culture is more visible through media, technology, interpreters, and online platforms. It continues to promote inclusion, accessibility, and respect for Deaf individuals and their language.", gradientColors: [Color(hex: "#E6DF44"), Color(hex: "#C4B43A")], sheetColors: [Color(hex: "#E6DF44"), Color(hex: "#C4B43A")]),
        Article(title: "Fingerspelling", content: "Fingerspelling is a part of American Sign Language (ASL) that uses hand shapes to represent the letters of the alphabet. It is commonly used to spell names, places, brands, or words that do not have a specific sign.\n\nIn ASL, each letter has its own hand position. Fingerspelling helps Deaf and hearing people communicate more clearly, especially when introducing new vocabulary or proper nouns.\n\nFingerspelling is not the same as full sign language. ASL includes its own grammar and signs, while fingerspelling is mainly used as a support tool within conversations.\n\nLearning fingerspelling is often one of the first steps in studying ASL because it helps students become familiar with hand movements and visual communication. Speed and accuracy improve with practice, allowing conversations to flow more naturally.\n\nToday, fingerspelling remains an important part of ASL and Deaf communication.", gradientColors: [Color(hex: "#A88C70"), Color(hex: "#CDCA80")], sheetColors: [Color(hex: "#A88C70"), Color(hex: "#CDCA80")]),
        Article(title: "Language Deprivation", content: "Language deprivation happens when a child does not have full access to language during early development. This can affect communication, learning, emotional growth, and cognitive development. Deaf children are especially at risk if they are not exposed to accessible language, such as American Sign Language (ASL), at a young age.\n\nMany Deaf children are born to hearing parents who may not know sign language. If communication is delayed or limited, the child may struggle to develop strong language skills during critical early years of brain development.\n\nLanguage deprivation can lead to difficulties in education, reading, social interaction, and mental health. It may also affect confidence and the ability to build relationships.\n\nResearch and Deaf educators emphasize the importance of early language access. Learning ASL from a young age can help Deaf children develop communication skills, academic abilities, and social connections more effectively.\n\nProviding accessible language early in life is essential for healthy development and equal opportunities.", gradientColors: [Color(hex: "#E6DF44"), Color(hex: "#F0810F")], sheetColors: [Color(hex: "#E6DF44"), Color(hex: "#F0810F")]),
        Article(title: "Ethics in Sign Language Technology", content: "Sign language technology has created new opportunities for communication and accessibility, but it also raises important ethical questions. Tools such as AI translators, motion-recognition systems, and automated captioning are designed to support Deaf and hard-of-hearing individuals, yet they are not always accurate or inclusive.\n\nOne major concern is accuracy. American Sign Language (ASL) is a complex language that includes facial expressions, body movement, and context. Technology that only focuses on hand movements may misunderstand meaning and create communication errors.\n\nPrivacy is another issue. Some sign language technologies use cameras and video recordings to collect data, which can raise concerns about consent and personal information.\n\nThere are also concerns about representation. Many Deaf advocates believe Deaf communities should be involved in designing and testing sign language technologies. Without their input, tools may ignore cultural and linguistic aspects of ASL.\n\nEthics in sign language technology is about more than innovation. It is about creating tools that are accurate, respectful, accessible, and developed with the Deaf community rather than only for it.", gradientColors: [Color(hex: "#F0810F"), Color(hex: "#D48A2B")], sheetColors: [Color(hex: "#F0810F"), Color(hex: "#D48A2B")]),
        Article(title: "The 5 Parameters of ASL", content: "American Sign Language (ASL) uses five main parameters to form signs. These parameters work together to create meaning, similar to how sounds form words in spoken languages.\n\n1. Handshape\nHandshape refers to the shape the hand makes while signing. Different handshapes can completely change the meaning of a sign.\n\n2. Palm Orientation\nPalm orientation is the direction the palm faces during a sign, such as up, down, inward, or outward. Changing the palm direction can create a different sign.\n\n3. Location\nLocation refers to where the sign is made on or near the body. Some signs are produced near the face, chest, or shoulders, and the location affects meaning.\n\n4. Movement\nMovement describes how the hands move while making a sign. The motion may be straight, circular, repeated, or directional.\n\n5. Non-Manual Signals\nNon-manual signals include facial expressions, head movements, eye gaze, and body posture. These are essential in ASL because they help show emotions, questions, emphasis, and grammar.\n\nAll five parameters are important in ASL. If one parameter changes, the meaning of the sign may also change.", gradientColors: [Color(hex: "#1F6385"), Color(hex: "#F0EDA2")], sheetColors: [Color(hex: "#1F6385"), Color(hex: "#F0EDA2")]),
        Article(title: "Iconicity in Sign Language", content: "Iconicity refers to the relationship between a sign and its meaning when the form of the sign visually resembles what it represents. In American Sign Language (ASL), many signs are iconic, meaning the movement or shape of the hands reflects real-world features of the concept.\n\nFor example, some signs imitate actions (like eating or drinking), while others visually represent the shape or function of objects. This makes some ASL signs easier to learn for beginners because the meaning can often be guessed from the form.\n\nHowever, not all signs in ASL are iconic. Over time, many signs become more abstract as languages evolve. Even when a sign originally had a clear visual connection, repeated use can reduce that connection.\n\nIconicity helps explain why ASL can feel intuitive in some cases, but ASL is still a fully structured language with grammar and rules that go beyond visual resemblance.\n\nUnderstanding iconicity shows how visual languages naturally connect meaning and form, while still developing complexity like spoken languages.", gradientColors: [Color(hex: "#F0810F"), Color(hex: "#E6DF44")], sheetColors: [Color(hex: "#F0810F"), Color(hex: "#E6DF44")])
    ]
    

    
    var body: some View {
        NavigationStack {
            ZStack {
                
                TabView(selection: $selectedTab) {
                    InsightsView(articles: articles, selectedArticle: $selectedArticle)
                        .tabItem {
                            Image(systemName: "house.fill")
                        }
                        .tag(0)
    
                    
                    StudyView()
                        .tabItem {
                            Image(systemName: "book.fill")
                        }
                        .tag(1)
     
                    
                    FingerspellingView()
                        .tabItem {
                            Image(systemName: "magnifyingglass")
                        }
                        .tag(2)
                    
                    QuizzesView()
                        .tabItem {
                            Image(systemName: "square.grid.2x2")
                        }
                        .tag(3)
                    
                    ProgressSectionView()
                        .tabItem {
                            Image(systemName: "checkmark.circle")
                        }
                        .tag(4)
                }
                .tint(Color(hex: "#F0810F"))

            }
        }
        .sheet(item: $selectedArticle) { article in
            ArticleSheetView(article: article)
        }
    }
}



// MARK: - Insights View
struct InsightsView: View {
    let articles: [Article]
    @Binding var selectedArticle: Article?

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "#011A27"), Color(hex: "#063852")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {

                // Fixed Header
                Text("Insights")
                    .font(.system(size: 34, weight: .semibold))
                    .foregroundColor(Color(hex: "#F0810F"))
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    .padding(.bottom, 20)

                // Scrollable Content
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(articles) { article in
                            ArticleBox(article: article)
                                .onTapGesture {
                                    selectedArticle = article
                                }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)
                }
            }
        }
    }
}
// MARK: - Article Box
struct ArticleBox: View {
    let article: Article
    
    var body: some View {
        Text(article.title)
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(Color(hex: "#011A27"))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 20)
            .padding(.horizontal, 20)
            .background(
                LinearGradient(colors: article.gradientColors, startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

// MARK: - Article Sheet
struct ArticleSheetView: View {
    let article: Article
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            LinearGradient(
                colors: article.sheetColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            NavigationStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {

                        Text(article.title)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(Color(hex: "#011A27"))

                        let paragraphs = article.content.components(separatedBy: "\n\n")

                        ForEach(paragraphs, id: \.self) { paragraph in
                            Text(paragraph)
                                .font(.system(size: 17))
                                .foregroundColor(Color(hex: "#011A27"))
                                .lineSpacing(6)
                        }
                    }
                    .padding(24)
                }
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(Color(hex: "#011A27"))
                        }
                    }
                }
            }
            .background(Color.clear)
        }
        .presentationBackground(.clear)
    }
}





#Preview {
    HomeView()
}
