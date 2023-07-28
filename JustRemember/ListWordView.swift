import SwiftUI

struct WordListView: View {
    var words: [Word]
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.blue, .white, .pink]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    ForEach(words) { word in
                        CardView(word: word.word, translation: word.translation)
                    }
                    .padding()
                }
            }
            .navigationTitle("Word list")
            .toolbarBackground(Color.blue.opacity(0.6), for: .navigationBar)
            
        }
    }
}

struct WordListView_Previews: PreviewProvider {
    static var previews: some View {
        WordListView(words: [Word(word: "Disgust", translation: "отвращение"),
        Word(word: "Sad", translation: "грусть")])
    }
}
