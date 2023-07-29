import SwiftUI

struct WordsListView: View {
    var words: [Word]
    
    var body: some View {
        NavigationStack {
            ZStack {
                GradientView()
                
                ScrollView {
                    ForEach(words) { word in
                        CardView(title: word.word, subtitle: word.translation)
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
            Word(word: "Disgust", translation: "отвращение"),
            Word(word: "Sad", translation: "грусть")
        ])
    }
}
