import SwiftUI

struct SettingsView: View {
    @StateObject private var storage = Storage()
    @State private var toggleIsActive = false
    @State private var selectedDate = Date()
    let notify = Notifications()
    
    var body: some View {
        NavigationStack {
            
            Form{
                
                    Image("profileIcon")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                
                Section(header: Text("Notification settings")){
                    Toggle("Notification", isOn: $toggleIsActive.animation())
                    if toggleIsActive {
                        Button("Request permission"){
                            notify.requestPermission()
                        }
                        DatePicker("Pice a date:", selection: $selectedDate, in: Date()...)
                        let title = storage.getCollections()[1].words[1].word
                        let subtitle = storage.getCollections()[1].words[1].meaning
                        
                        Button("Schedule notification") {
                            notify.sendNotification(at: selectedDate, title: title, subtitle: subtitle)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
        }
        }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
