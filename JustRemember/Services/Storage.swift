import SwiftUI

final class Storage: ObservableObject {
    
    private let emotionsWords = [
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
    
    private let weatherWords = [
        Word(word: "Frosty", translation: "морозно"),
        Word(word: "Warm", translation: "тепло"),
        Word(word: "Stuffy", translation: "душно"),
        Word(word: "Breezy", translation: "тепло и умеренно ветрено"),
        Word(word: "Calm", translation: "тихо, спокойно")
    ]
    
    private let flowersWords = [
        Word(word: "Violet", translation: "фиалка"),
        Word(word: "Rose", translation: "роза"),
        Word(word: "Tulip", translation: "тюльпан"),
        Word(word: "Daffodil", translation: "нарцисс"),
        Word(word: "Daisy", translation: "ромашка")
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
