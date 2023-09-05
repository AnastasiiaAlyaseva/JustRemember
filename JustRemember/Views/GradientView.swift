import SwiftUI

struct GradientView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        let middleColor: Color = .appTextColor(for: colorScheme)
        
        let gradientColors = [Color(UIColor.systemBlue), middleColor, Color(UIColor.systemPink)]
        
        return LinearGradient(gradient: Gradient(colors: gradientColors),
                              startPoint: .topLeading,
                              endPoint: .bottomTrailing)
        .edgesIgnoringSafeArea(.all)
    }
}

struct GradientView_Previews: PreviewProvider {
    static var previews: some View {
        GradientView()
    }
}
