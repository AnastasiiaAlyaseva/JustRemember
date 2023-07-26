import SwiftUI

class WordStorage: ObservableObject {
    
    private let words = [
        Word(word: "Fear", translation: "страх"),
        Word(word: "Anger", translation: "злость"),
        Word(word: "Disgust", translation: "отвращение"),
        Word(word: "Sad", translation: "грусть"),
        Word(word: "Happy", translation: "счастье"),
        Word(word: "Surprise", translation: "удивление")
    ]
    
    func getWord() -> [Word] {
        return words
    }
}

