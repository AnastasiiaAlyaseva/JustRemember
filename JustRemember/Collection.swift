import SwiftUI

struct Collection: Identifiable {
    let id = UUID()
    let name: String
    let words: [Word]
}
