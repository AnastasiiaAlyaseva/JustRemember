import SwiftUI

struct HomeView: View {
    @StateObject private var storage = Storage()
    
    var body: some View {
        NavigationStack {
            ZStack {
                GradientView()
                
                ScrollView {
                    ForEach(storage.getCollections()) { collection in
                        NavigationLink(destination: TopicsView(words: collection.words)) {
                            CardView(title: collection.name, subtitle: "")
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Topics")
            .toolbarBackground(Color.blue.opacity(0.6), for: .navigationBar)
            .navigationBarItems(trailing:
                NavigationLink(destination: SettingsView()) {
                    Image("profileIcon")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                }
            )
        }.accentColor(.black)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
