import SwiftUI

struct AppearanceView: View {
    @AppStorage(AppConstatns.appAppearance) private var selectedAppearance = Appearance.system
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(Appearance.allCases, id: \.self) { appearance in
                    Button(action: {
                        selectedAppearance = appearance
                    }) {
                        HStack {
                            Text(appearance.name)
                            Spacer()
                            if appearance == selectedAppearance {
                                Image(systemName: "checkmark")
                                    .accessibilityIdentifier(Accessibility.ImageView.imageViewIdentifier)
                            }
                        }
                    }.accessibilityIdentifier(appearance.accesibilityIndetifier)
                }
            }
            .accentColor(.label)
            .navigationTitle("Appearance")
            
        }
        .onChange(of: selectedAppearance) { userSelection in
            AppearanceController().setAppearance()
        }
    }
}

struct AppearanceView_Previews: PreviewProvider {
    static var previews: some View {
        AppearanceView()
    }
}
