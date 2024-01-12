import SwiftUI

struct SettingsView: View {
    let storage: Storage
    private let notificationService: NotificationServiceProtocol = NotificationService()
    
    @State private var isNotificationsEnabled = false
    @State private var selectedStartDate = Date() + 5 * 60 // current time + 5 minutes
    @State private var repeatInterval = NotificationReapeatInterval.oneDay
    @State private var noPermissionsAlert = false
    @State private var errorScheduleAlert = false
    @State private var notificationCount: Int = 0
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationStack {
            Form {
                Image("profileIcon")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Section(header: Text("Notification settings"),
                        footer: Text("Control the way you receive notifications as you see best. Optimise the balance between learning and comfort.")
                    .font(.footnote)
                    .foregroundColor(.gray)) {
                        Toggle("Notifications", isOn: $isNotificationsEnabled.animation())
                        
                        if isNotificationsEnabled {
                            
                            if notificationCount > 0 {
                                Text("\(notificationCount) notifications remaining")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            } else {
                                DatePicker("Start date:", selection: $selectedStartDate, in: (selectedStartDate)...)
                                
                                Picker("Reapeat interval", selection: $repeatInterval) {
                                    ForEach(NotificationReapeatInterval.allCases, id:\.self) { interval in
                                        Text(interval.name).tag(interval)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .accentColor(.label)
                                
                                Button("Remebmer all words") {
                                    scheduleAllWords()
                                    Task {
                                        let notificationCount = await notificationService.countRemainingNotifications()
                                        if notificationCount == 0 {
                                            errorScheduleAlert = true
                                        }
                                        self.notificationCount = notificationCount
                                    }
                                }
                                .alert(isPresented:$errorScheduleAlert) {
                                    return Alert(
                                        title: Text("Oops!\n Check system permissions or time of notifications."),
                                        dismissButton: .default(Text("Ok"))
                                    )
                                }
                            }
                        }
                    }
                
                Section(header: Text("Appearance")) {
                    NavigationLink("Appearance", destination: AppearanceView())
                }
            }
            .navigationTitle("Settings")
            .onAppear {
                checkNotificationsPermissions()
            }
            .alert(isPresented:$noPermissionsAlert) {
                Alert(
                    title: Text("Go to settings & privacy to re-enable the permission!"),
                    dismissButton: .default(Text("Settings")) {
                        
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                )
            }
            .onChange(of: isNotificationsEnabled) { isEnabled in
                if !isEnabled {
                    notificationService.cancelAllNotifications()
                    Task {
                        notificationCount = await notificationService.countRemainingNotifications()
                    }
                    print("Cancelled All Notifications")
                }
            }
            
            SupportEmailButton()
            
            Text("Version \(AppInfoProvider.appVersion()).\(AppInfoProvider.appBuild())")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .accentColor(.systemBlue)
    }
    
    private func checkNotificationsPermissions() {
        notificationService.checkStatus { status in
            switch status {
            case .notDetermined:
                notificationService.requestPermission { isEnabled in
                    isNotificationsEnabled = isEnabled
                }
            case .autorized:
                Task {
                    notificationCount = await notificationService.countRemainingNotifications()
                    isNotificationsEnabled = notificationCount > 0
                }
            case .denied:
                noPermissionsAlert = true
            }
        }
    }
    
    private func scheduleAllWords() {
            var date = selectedStartDate
            var allWords: [Word] = []
            for collection in storage.collections {
                allWords += collection.words
            }
            for word in allWords.shuffled() {
                let title = word.word
                let subtitle = word.meaning
                notificationService.scheduleNotification(title: title, subtitle: subtitle, date: date)
                date += TimeInterval(repeatInterval.rawValue)
            }
        }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(storage: Storage())
    }
}
