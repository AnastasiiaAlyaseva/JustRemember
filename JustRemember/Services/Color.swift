import SwiftUI

extension Color {
    static func appTextColor(for colorScheme: ColorScheme) -> Color {
        return colorScheme == .dark ? Color.black : Color.white
    }
    
    static func imageColor(for colorScheme: ColorScheme) -> Color {
        return colorScheme == .dark ? Color.mint : Color.black
    }
}
