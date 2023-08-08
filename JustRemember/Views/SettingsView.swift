import SwiftUI

struct SettingsView: View {
    @StateObject private var storage = Storage()
    @State private var isNotificationsEnabled = false
    @State private var selectedStartDate = Date() + 5 * 60
    @State private var repeatInterval = NotificationReapeatInterval.twoHours
    @State private var showSettingsAlert = false
    @State private var showScheduleAlert = false
    private let notificationService: NotificationServiceProtocol = NotificationService()
    
    var body: some View {
        NavigationStack {
            Form {
                Image("profileIcon")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Section(header: Text("Notification settings")) {
                    Toggle("Notifications", isOn: $isNotificationsEnabled.animation())
                    
                    if isNotificationsEnabled {
                        DatePicker("Start date:", selection: $selectedStartDate, in: (selectedStartDate)...)
                        
                        Picker("Reapeat interval", selection: $repeatInterval) {
                            Text(NotificationReapeatInterval.twoSeconds.name).tag(NotificationReapeatInterval.twoSeconds)
                            Text(NotificationReapeatInterval.oneMinute.name).tag(NotificationReapeatInterval.oneMinute)
                            Text(NotificationReapeatInterval.thirtyMinutes.name).tag(NotificationReapeatInterval.thirtyMinutes)
                            Text(NotificationReapeatInterval.oneHour.name).tag(NotificationReapeatInterval.oneHour)
                            Text(NotificationReapeatInterval.twoHours.name).tag(NotificationReapeatInterval.twoHours)
                            Text(NotificationReapeatInterval.oneDay.name).tag(NotificationReapeatInterval.oneDay)
                            Text(NotificationReapeatInterval.twoDays.name).tag(NotificationReapeatInterval.twoDays)
                        }
                        .pickerStyle(MenuPickerStyle())
                        
                        Button("Remebmer all words") {
                            scheduleAllWords()
                            showScheduleAlert = true
                        }.alert(isPresented:$showScheduleAlert){
                            Alert(
                                title: Text("You will receive notifications at set times"),
                                dismissButton: .default(Text("Ok"))
                            )
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .onAppear {
                checkNotificationsPermissions()
            }
            .alert(isPresented:$showSettingsAlert) {
                Alert(
                    title: Text("Go to settings & privacy to re-enable the permission!"),
                    dismissButton: .default(Text("Settings")) {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }
                )
            }
            .onChange(of: isNotificationsEnabled) { isEnabled in
                if !isEnabled {
                    notificationService.cancelAllNotifications()
                    print("Cancelled All Notifications")
                }
            }
            
            Text("Version \(AppVersionProvider.appVersion()).\(AppVersionProvider.appBuild())")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .accentColor(.blue)
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
                    isNotificationsEnabled = await notificationService.checkPlannedNotifications()
                }
            case .denied:
                showSettingsAlert = true
            }
        }
    }
    
    private func scheduleAllWords() {
        var date = selectedStartDate
        for collection in storage.getCollections() {
            for word in collection.words.shuffled() {
                let title = word.word
                let subtitle = word.meaning
                notificationService.scheduleNotification(title: title, subtitle: subtitle, date: date)
                date += TimeInterval(repeatInterval.rawValue)
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
