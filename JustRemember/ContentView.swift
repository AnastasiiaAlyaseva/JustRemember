import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.blue, .white, .pink]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack{
                        CardView(word: "Anastasia", translation: "Anastasia")
                    }
                    .padding()
                }
                
                Spacer()
                    .navigationTitle("Word collection")
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
