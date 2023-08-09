import SwiftUI

struct TopicsView: View {
    let words: [Word]
    
    var body: some View {
        NavigationStack {
            ZStack {
                GradientView()
                
                ScrollView {
                    ForEach(words) { word in
                        NavigationLink(destination: WordDescriptionView(title: word.word, subtitle: word.meaning, description: "Detailed descriptions will be available here soon. Stay tuned for updates!")) {
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

struct TopicsView_Previews: PreviewProvider {
    static var previews: some View {
        TopicsView(words: [
            Word(word: "Disgust", meaning: "отвращение"),
            Word(word: "Sad", meaning: "грусть")
        ])
    }
}
