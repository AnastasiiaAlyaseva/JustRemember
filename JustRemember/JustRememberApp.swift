import SwiftUI

@main
struct JustRememberApp: App {
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .task {
                    AppearanceController().setAppearance()
                }
        }
    }
}
