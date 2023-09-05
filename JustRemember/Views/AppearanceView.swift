import SwiftUI

struct AppearanceView: View {
    @AppStorage("selectedAppearance") private var selectedAppearance = Appearance.system
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(Appearance.allCases, id: \.self) { appearance in
                    Button(action: {
                        selectedAppearance = appearance
                        setAppearance(appearance)
                    }) {
                        HStack {
                            Text(appearance.name)
                            Spacer()
                            if appearance == selectedAppearance {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            }
            .accentColor(.label)
            .navigationTitle("Appearance")
        }
    }
    
    private func setAppearance (_ selectedAppearance: Appearance){
        let style: UIUserInterfaceStyle
        switch selectedAppearance {
        case .dark:
            style = .dark
        case .light:
            style = .light
        case .system:
            style = .unspecified
        }
        UIApplication.shared.windows.first?.overrideUserInterfaceStyle = style
    }
}

struct AppearanceView_Previews: PreviewProvider {
    static var previews: some View {
        AppearanceView()
    }
}
