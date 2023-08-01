import SwiftUI

struct WordsListView: View {
    var words: [Word]
    
    var body: some View {
        NavigationStack {
            ZStack {
                GradientView()
                
                ScrollView {
                    ForEach(words) { word in
                        NavigationLink(destination: WordDescriptionView(title: word.word, subtitle: word.meaning, description: "Feeling of great worry or anxiety caused by the knowledge of danger.")) {
                            CardView(title: word.word, subtitle: word.meaning) }
                    }
                    .padding()
                }
            }
            .navigationTitle("Words List")
            .toolbarBackground(Color.blue.opacity(0.6), for: .navigationBar)
        }
    }
}

struct WordsListView_Previews: PreviewProvider {
    static var previews: some View {
        WordsListView(words: [
            Word(word: "Disgust", meaning: "отвращение"),
            Word(word: "Sad", meaning: "грусть")
        ])
    }
}
