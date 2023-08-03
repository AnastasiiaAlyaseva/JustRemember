import SwiftUI

struct SettingsView: View {
    @StateObject private var storage = Storage()
    @State private var isNotificationsEnabled = false
    @State private var selectedDate = Date()
    @State private var repeatInterval = 5
    let notify = NotificationService()
    
    var body: some View {
        NavigationStack {
            Form {
                Image("profileIcon")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Section(header: Text("Notification settings")) {
                    Toggle("Notification", isOn: $isNotificationsEnabled.animation())
                    if isNotificationsEnabled {
                        Button("Request permission"){
                            notify.requestPermission()
                        }
                        .foregroundColor(Color.blue)
                        
                        DatePicker("Pice a date:", selection: $selectedDate, in: Date()...)
                        let title = storage.getCollections()[1].words[1].word
                        let subtitle = storage.getCollections()[1].words[1].meaning
                        
                        Button("Schedule notification") {
                            notify.sendNotification(title: title, subtitle: subtitle, date: selectedDate)
                        }
                        .foregroundColor(Color.blue)
                        
                        Picker("Choose reapeat interval", selection: $repeatInterval) {
                            Text("5 minutes").tag(5)
                            Text("10 minutes").tag(10)
                            Text("15 minutes").tag(15)
                            Text("20 minutes").tag(20)
                        }
                        .pickerStyle(MenuPickerStyle())
                        
                        
                        Button("Reapeat notification") {
                            let interval = TimeInterval(repeatInterval * 60)
                            let title = storage.getCollections()[1].words[1].word
                            let subtitle = storage.getCollections()[1].words[1].meaning
                            
                            notify.sendRepeatingNotification(title: title, subtitle: subtitle, reapeatInterval: interval)
                        }
                        .foregroundColor(Color.blue)
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
