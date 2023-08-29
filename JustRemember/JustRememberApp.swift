import SwiftUI

@main
struct JustRememberApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some Scene {
        WindowGroup {
            HomeView()
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
