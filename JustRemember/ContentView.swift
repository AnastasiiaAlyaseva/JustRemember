import SwiftUI

struct ContentView: View {
    @StateObject private var wordStorage = WordStorage()
    
    var body: some View {
        
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.blue, .white, .pink]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    ForEach(wordStorage.getCollections()) { collection in
                        NavigationLink(destination: WordListView(words: collection.words)) {
                            CardView(word: collection.name, translation: "")
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Word collection")
            .toolbarBackground(Color.blue.opacity(0.6), for: .navigationBar)
            .navigationBarItems(trailing:
                                    Image("profileIcon")
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
