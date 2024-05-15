import SwiftUI

struct TopicsView: View {
    let words: [Word]
    let topicName: String
    
    var body: some View {
        NavigationStack {
            ZStack {
                GradientView()
                
                ScrollView {
                    ForEach(words) { word in
                        NavigationLink(destination: WordDescriptionView(title: word.word, subtitle: word.meaning, description: "")) {
                            CardView(title: word.word, subtitle: word.meaning) }
                    }
                    .padding()
                }
            }
            .navigationTitle(topicName)
            .toolbarBackground(Color.toolBarColor, for: .navigationBar)
        }
        .accessibilityIdentifier(Accessibility.TopicsView.topicsViewIdentifier)
    }
}

struct TopicsView_Previews: PreviewProvider {
    static var previews: some View {
        TopicsView(words: [
            Word(word: "Dishonest", meaning: "intending to trick people"),
            Word(word: "Easy-going", meaning: "calm and not easily worried")
        ], topicName: "Personality")
    }
}
