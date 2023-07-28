import SwiftUI

final class WordStorage: ObservableObject {
    
    private let words = [
        Word(word: "Fear", translation: "страх"),
        Word(word: "Anger", translation: "злость"),
        Word(word: "Disgust", translation: "отвращение"),
        Word(word: "Sad", translation: "грусть"),
        Word(word: "Happy", translation: "счастье"),
        Word(word: "Surprise", translation: "удивление"),
        Word(word: "Thrilled", translation: "в восторге"),
        Word(word: "Cheerful", translation: "радостный, веселый"),
        Word(word: "Excited", translation: "очень радостный"),
        Word(word: "Delighted", translation: "очень радостный")
    ]
    
    func getWord() -> [Word] {
        return words
    }
    
    
    private var collections = [Collection]()
    
    init() {
        collections = [
            Collection(name: "Emotions", words: words),
            Collection(name: "Weather", words: words),
            Collection(name: "Flowers", words: words)
        ]
    }
    
    func getCollections() -> [Collection] {
        return collections
    }
}
