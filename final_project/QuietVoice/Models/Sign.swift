import Foundation

struct Sign: Identifiable {
    let id = UUID()
    let word: String
    let videoName: String
    let topic: String
    var timesMissed: Int = 0
}
