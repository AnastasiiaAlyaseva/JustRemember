import SwiftUI

struct WordDescriptionView: View {
    let title: String
    let subtitle: String
    let description: String
    
    var body: some View {
        NavigationStack {
            ZStack{
                GradientView()
                VStack{
                    Image("Education")
                        .resizable()
                        .scaledToFit()
                        .blur(radius: 0.5)
                    
                    HStack{
                        Text(title)
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.black)
                            .foregroundColor(Color.black)
                        
                        Text("-")
                        Text(subtitle)
                            .font(.system(size: 20))
                            .foregroundColor(Color.black)
                        
                    }
                    
                    Text(description)
                        .padding()
                        .foregroundColor(Color.black)
                    
                    Spacer()
                }
            }
        }
    }
}


struct WordDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        WordDescriptionView(title: "Fear", subtitle: "Fear subtitle", description: "Feeling of great worry or anxiety caused by the knowledge of danger. \n • The soldier tried not to show his fear \n • She has a deep-seated fear of spiders.")
    }
}
