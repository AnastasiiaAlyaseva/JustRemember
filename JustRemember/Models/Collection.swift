import Foundation

struct Collection: Identifiable, Codable {
    var id: UUID? = UUID()
    let name: String
    let words: [Word]
}

