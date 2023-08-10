import SwiftUI

struct LoaderAnimationView: View {
    @State private var isAnimating = false
    
    var foreverAnimation: Animation {
        Animation
            .spring(response: 1, dampingFraction: 0.7, blendDuration: 0)
            .repeatForever(autoreverses: false)
    }
    
    var body: some View {
        Image(systemName: "hourglass.bottomhalf.filled")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 75, height: 100)
            .rotationEffect(Angle(degrees: isAnimating ? 180 : 0))
            .animation(foreverAnimation, value: isAnimating)
            .onAppear{
                isAnimating = true
                
            }
    }
}

struct LoaderAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        LoaderAnimationView()
    }
}
