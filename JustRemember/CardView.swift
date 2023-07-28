import SwiftUI

struct CardView: View {
    let word: String
    let translation: String

    var body: some View {
        HStack{
            Image(systemName: "text.book.closed")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(Color.black)
            
            Spacer()
            
            VStack(alignment: .center){
            Text(word)
                .font(.system(.title, design: .rounded))
                .fontWeight(.black)
                .foregroundColor(Color.black)
                
            Text(translation)
                .font(.system(.title, design: .rounded))
                .foregroundColor(Color.black)

        }
            Spacer()
            Image(systemName: "chevron.right")
        }
        .frame(maxWidth: .infinity, minHeight: 50 )
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
