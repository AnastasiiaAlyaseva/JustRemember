import SwiftUI

final class AppearanceController {
    @AppStorage(AppConstatns.appAppearance) private var selectedAppearance = Appearance.system
    
    func setAppearance() {
        let style: UIUserInterfaceStyle
        switch selectedAppearance {
        case .dark:
            style = .dark
        case .light:
            style = .light
        case .system:
            style = .unspecified
        }
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.overrideUserInterfaceStyle = style
    }
}
