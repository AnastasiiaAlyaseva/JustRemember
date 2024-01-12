import SwiftUI

struct LoaderAnimationView: View {
    @State private var isAnimating = false
    @State private var showProgress = false

    private var foreverAnimation: Animation {
        Animation
            .spring(response: 1, dampingFraction: 0.7, blendDuration: 0)
            .repeatForever(autoreverses: false)
    }

    var body: some View {
        LazyVStack{
            if showProgress {
            Image(systemName: "hourglass.bottomhalf.filled")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 75, height: 100)
                .rotationEffect(Angle(degrees: isAnimating ? 180 : 0))
                .animation(foreverAnimation, value: isAnimating)
                .onAppear{
                    isAnimating = true
                }
                .onDisappear{
                    isAnimating = false
                }
            }
        }
        .onAppear {
            showProgress = true
        }
        .onDisappear {
            showProgress = false
        }
    }
}

struct LoaderAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        LoaderAnimationView()
    }
}
