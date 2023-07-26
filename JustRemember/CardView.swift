import SwiftUI

struct CardView: View {
    let word: String
    let translation: String
    
    var body: some View {
        VStack{
            Text(word)
                .font(.system(.title, design: .rounded))
                .fontWeight(.black)
            Text(translation)
                .font(.system(.title, design: .rounded))
        }
        .frame(maxWidth: .infinity,minHeight: 50 )
        .padding(25)
        .background(.blue.opacity(0.2))
        .cornerRadius(25)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(word: "Hello", translation: "Hi")
    }
}
