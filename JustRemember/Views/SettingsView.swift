import SwiftUI

struct SettingsView: View {
    @StateObject private var storage = Storage()
    @State private var isNotificationsEnabled = false
    @State private var selectedDate = Date()
    @State private var repeatInterval = 5
    @State private var showAlert = false
    private let notificationService = NotificationService()
    
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
                        
                        DatePicker("Pice a date:", selection: $selectedDate, in: Date()...)
                        let title = storage.getCollections()[1].words[1].word
                        let subtitle = storage.getCollections()[1].words[1].meaning
                        
                        Button("Schedule notification") {
                            notificationService.sendNotification(title: title, subtitle: subtitle, date: selectedDate)
                        }
                        
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
                            
                            notificationService.sendRepeatingNotification(title: title, subtitle: subtitle, reapeatInterval: interval)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .onAppear {
                notificationService.checkStatus { status in
                    switch status {
                    case .notDetermined:
                        notificationService.requestPermission { isEnabled in
                            if isEnabled {
                                isNotificationsEnabled = true
                            } else {
                                isNotificationsEnabled = false
                            }
                        }
                    case .autorized:
                        isNotificationsEnabled = true
                    case .denied:
                        showAlert = true
                    }
                }
                notificationService.requestPermission { isEnabled in
                    print(isEnabled)
                }
            }
            .alert(isPresented:$showAlert) {
                Alert(
                    title: Text("Notification permission was denied previously, go to settings & privacy to re-enable the permission!"),
                    dismissButton: .default(Text("Ok"))
                )
            }
            .onChange(of: isNotificationsEnabled) { active in
                if !active {
                    notificationService.cancelAllNotifications()
                    print("Canceled")
                }
            }
        }
        .accentColor(.blue)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
