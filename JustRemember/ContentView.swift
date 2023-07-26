import SwiftUI

struct ContentView: View {
@StateObject private var wordStorage = WordStorage()
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.blue, .white, .pink]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack{
                        ForEach(wordStorage.getWord()) { wordCart in
                            CardView(word: wordCart.word, translation: wordCart.translation)
                        }
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
