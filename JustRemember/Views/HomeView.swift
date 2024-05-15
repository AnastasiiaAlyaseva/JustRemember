import SwiftUI

struct HomeView: View {
    @StateObject private var storage = Storage()
    
    private var networkClient: NetworkClient {
        NetworkClient(storage: storage)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                GradientView()
                
                if storage.collections.count == 0 {
                    LoaderAnimationView()
                }
                
                ScrollView {
                    ForEach(storage.collections) { collection in
                        NavigationLink(destination: TopicsView(words: collection.words, topicName: collection.name)) {
                            CardView(title: collection.name, subtitle: "")
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Topics")
            .toolbarBackground(Color.toolBarColor, for: .navigationBar)
            .navigationBarItems(trailing:
                                    NavigationLink(destination: SettingsView(storage: storage)) {
                Image("profileIcon")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .accessibilityIdentifier(Accessibility.HomeView.settingsViewButton)
            }
            )
        }
        .accentColor(.label)
        .onAppear{
            networkClient.fetchData()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
