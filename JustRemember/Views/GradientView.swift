import SwiftUI

struct GradientView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        let secondColor: Color = .gradientElementColor(colorScheme: colorScheme)
        
        let gradientColors = [.systemBlue, secondColor, .systemPink]
        
        return LinearGradient(
            gradient: Gradient(colors: gradientColors),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .edgesIgnoringSafeArea(.all)
    }
}

struct GradientView_Previews: PreviewProvider {
    static var previews: some View {
        GradientView()
    }
}
