import SwiftUI

struct GradientView: View {
    var body: some View {
        LinearGradient(gradient: Gradient(
            colors: [.blue, .white, .pink]),
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
