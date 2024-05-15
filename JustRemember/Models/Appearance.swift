import Foundation

enum Appearance: String, CaseIterable {
    case dark
    case light
    case system
    
    var name: String {
        switch self {
        case .dark:
            return "Dark Mode"
        case .light:
            return "Light Mode"
        case .system:
            return "Same as Device Setting"
        }
    }
    
    var accesibilityIndetifier: String {
        switch self {
        case .dark:
            return Accessibility.AppearanceView.darkMode
        case .light:
            return Accessibility.AppearanceView.lightMode
        case .system:
            return Accessibility.AppearanceView.systemMode
        }
    }
}
