import SwiftUI

final class Storage: ObservableObject {
    
    private let emotionsWords = [
        Word(word: "Fear", meaning: "страх"),
        Word(word: "Anger", meaning: "злость"),
        Word(word: "Disgust", meaning: "отвращение"),
        Word(word: "Sad", meaning: "грусть"),
        Word(word: "Happy", meaning: "счастье"),
        Word(word: "Surprise", meaning: "удивление"),
        Word(word: "Thrilled", meaning: "в восторге"),
        Word(word: "Cheerful", meaning: "радостный, веселый"),
        Word(word: "Excited", meaning: "очень радостный"),
        Word(word: "Delighted", meaning: "очень радостный")
    ]
    
    private let weatherWords = [
        Word(word: "Frosty", meaning: "морозно"),
        Word(word: "Warm", meaning: "тепло"),
        Word(word: "Stuffy", meaning: "душно"),
        Word(word: "Breezy", meaning: "тепло и умеренно ветрено"),
        Word(word: "Calm", meaning: "тихо, спокойно")
    ]
    
    private let flowersWords = [
        Word(word: "Violet", meaning: "фиалка"),
        Word(word: "Rose", meaning: "роза"),
        Word(word: "Tulip", meaning: "тюльпан"),
        Word(word: "Daffodil", meaning: "нарцисс"),
        Word(word: "Daisy", meaning: "ромашка")
    ]
    
    private lazy var collections: [Collection] = [
        Collection(name: "Emotions", words: emotionsWords),
        Collection(name: "Weather", words: weatherWords),
        Collection(name: "Flowers", words: flowersWords)
    ]
    
    // MARK: - Public
    func getCollections() -> [Collection] {
        return collections
    }
}
