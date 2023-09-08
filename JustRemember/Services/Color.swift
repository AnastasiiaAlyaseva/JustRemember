import SwiftUI

extension Color {
    static func gradientElementColor(colorScheme: ColorScheme) -> Color {
        return colorScheme == .dark ? Color.black : Color.white
    }
    
    static func imageColor(colorScheme: ColorScheme) -> Color {
        return colorScheme == .dark ? Color.mint : Color.black
    }
    
    static let label  = Color(UIColor.label)
    static let toolBarColor = Color.blue.opacity(0.6)
    static let systemBlue = Color(UIColor.systemBlue)
    static let systemPink = Color(UIColor.systemPink)
    
}
