import SwiftUI

final class Storage: ObservableObject {
    @Published var collections: [Collection] = []
}
