import Foundation

struct Topic: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let signs: [Sign]
}
