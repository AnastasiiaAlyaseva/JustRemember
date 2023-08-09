import Foundation

struct Word: Identifiable, Codable {
    var id: UUID? = UUID()
    let word: String
    let meaning: String
}
