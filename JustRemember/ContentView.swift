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
                            NavigationLink(destination: Text(""), label: {
                                CardView(word: wordCart.word, translation: wordCart.translation)
                            })
                        }
                    }
                    .padding()
                }
                .navigationTitle("Word collection")
                .navigationBarItems(
                trailing:
                    Image("profileIcon")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                )
                
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
