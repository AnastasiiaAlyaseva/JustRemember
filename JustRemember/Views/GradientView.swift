import SwiftUI

struct GradientView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        let gradientColors: [Color]
        
        if colorScheme == .dark {
            gradientColors = [Color(UIColor.systemBlue),Color(UIColor.black), Color(UIColor.systemPink)]
        } else {
            gradientColors = [Color(UIColor.systemBlue), .white, Color(UIColor.systemPink)]
        }
        
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
