import SwiftUI

struct CardView: View {
    let title: String
    let subtitle: String
    
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack{
            Image(systemName: "text.book.closed")
                .resizable()
                .frame(width: 30, height: 30)
                .accentColor(.imageColor(colorScheme: colorScheme))
            
            Spacer()
            
            VStack(alignment: .center){
            Text(title)
                .font(.system(.title, design: .rounded))
                .fontWeight(.black)
                .accentColor(.label)

            Text(subtitle)
                .font(.system(size: 20))
                .accentColor(.label)

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
        CardView(title: "Hello", subtitle: "Hi")
    }
}
