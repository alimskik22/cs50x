import Foundation
import Combine

class StorageManager: ObservableObject {
    private let defaults = UserDefaults.standard
    
    private let completedTopicsKey = "completedTopics"
    private let viewedSignsKey = "viewedSigns"
    private let missedSignsKey = "missedSigns"
    
    // MARK: - Topic Completion
    func markTopicAsCompleted(_ topicName: String) {
        var completed = getCompletedTopics()
        completed.insert(topicName)
        defaults.set(Array(completed), forKey: completedTopicsKey)
    }
    
    func getCompletedTopics() -> Set<String> {
        let array = defaults.array(forKey: completedTopicsKey) as? [String] ?? []
        return Set(array)
    }
    
    func isTopicCompleted(_ topicName: String) -> Bool {
        return getCompletedTopics().contains(topicName)
    }
    
    // MARK: - Viewed Signs
    func markSignAsViewed(_ signWord: String) {
        var viewed = getViewedSigns()
        viewed.insert(signWord)
        defaults.set(Array(viewed), forKey: viewedSignsKey)
    }
    
    func getViewedSigns() -> Set<String> {
        let array = defaults.array(forKey: viewedSignsKey) as? [String] ?? []
        return Set(array)
    }
    
    func isSignViewed(_ signWord: String) -> Bool {
        return getViewedSigns().contains(signWord)
    }
    
    // MARK: - Missed Signs
    func incrementMissedCount(for signWord: String) {
        var missed = getMissedCounts()
        missed[signWord] = (missed[signWord] ?? 0) + 1
        defaults.set(missed, forKey: missedSignsKey)
    }
    
    func getMissedCounts() -> [String: Int] {
        return defaults.dictionary(forKey: missedSignsKey) as? [String: Int] ?? [:]
    }
    
    func resetMissedCount(for signWord: String) {
        var missed = getMissedCounts()
        missed.removeValue(forKey: signWord)
        defaults.set(missed, forKey: missedSignsKey)
    }
    
    // MARK: - Reset
    func resetAllProgress() {
        defaults.removeObject(forKey: completedTopicsKey)
        defaults.removeObject(forKey: viewedSignsKey)
        defaults.removeObject(forKey: missedSignsKey)
    }
    
    // MARK: - Fingerspelling Learned Tracking
    private var learnedLettersKey: String { "learnedLetters" }
    private var learnedNumbersKey: String { "learnedNumbers" }

    func markLetterLearned(_ character: String) {
        var set = getLearnedLetters()
        set.insert(character)
        defaults.set(Array(set), forKey: learnedLettersKey)
    }

    func markNumberLearned(_ character: String) {
        var set = getLearnedNumbers()
        set.insert(character)
        defaults.set(Array(set), forKey: learnedNumbersKey)
    }

    func getLearnedLetters() -> Set<String> {
        let array = defaults.array(forKey: learnedLettersKey) as? [String] ?? []
        return Set(array)
    }

    func getLearnedNumbers() -> Set<String> {
        let array = defaults.array(forKey: learnedNumbersKey) as? [String] ?? []
        return Set(array)
    }
}
