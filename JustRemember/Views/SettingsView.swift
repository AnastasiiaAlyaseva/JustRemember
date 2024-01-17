import SwiftUI

struct SettingsView: View {
    let storage: Storage
    private let notificationService: NotificationServiceProtocol = NotificationService()
    private static let fiveMinutes: TimeInterval = 5 * 60
    private static let threeHours: TimeInterval = 3 * 60 * 60
    
    @State private var isNotificationsEnabled = false
    @State private var notificationsStartDate = Date() + fiveMinutes
    @State private var notificationRepeatInterval = NotificationReapeatInterval.oneDay
    @State private var notificationCount: Int = 0
    
    @State private var noNotificationPermissionsAlert = false
    @State private var errorScheduleNotificationAlert = false
    
    @State private var isDoNotDisturbEnabled = false
    @State private var doNotDisturbStartDate = Date()
    @State private var doNotDisturbStopDate = Date() + threeHours
    
    
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
                                DatePicker("Start date:", selection: $notificationsStartDate, in: Date()...)
                                
                                Picker("Reapeat interval", selection: $notificationRepeatInterval) {
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
                                            errorScheduleNotificationAlert = true
                                        }
                                        self.notificationCount = notificationCount
                                    }
                                }
                                .alert(isPresented:$errorScheduleNotificationAlert) {
                                    return Alert(
                                        title: Text("Oops!\n Check system permissions or time of notifications."),
                                        dismissButton: .default(Text("Ok"))
                                    )
                                }
                            }
                        }
                    }
                Section(header: Text("Do not disturb")) {
                    Toggle("Do not disturb", isOn: $isDoNotDisturbEnabled.animation())
                    
                    if isDoNotDisturbEnabled {
                        DatePicker("From", selection: $doNotDisturbStartDate, displayedComponents: .hourAndMinute)
                        DatePicker("To", selection: $doNotDisturbStopDate, displayedComponents: .hourAndMinute)
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
            .alert(isPresented:$noNotificationPermissionsAlert) {
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
                noNotificationPermissionsAlert = true
            }
        }
    }
    
    private func scheduleAllWords() {
        var date = notificationsStartDate
        //        print(date)
        var allWords: [Word] = []
        for collection in storage.collections {
            allWords += collection.words
        }
        
        for word in allWords.shuffled() {
            let title = word.word
            let subtitle = word.meaning
            if isDoNotDisturbEnabled {
                // fix bug with infinite loop in case of DND active "whole" day
                while isDNDActive(startDate: doNotDisturbStartDate, stopDate: doNotDisturbStopDate, notificationDate: date) {
                    date += TimeInterval(notificationRepeatInterval.rawValue)
                }
                notificationService.scheduleNotification(title: title, subtitle: subtitle, date: date)
                date += TimeInterval(notificationRepeatInterval.rawValue)
            } else {
                notificationService.scheduleNotification(title: title, subtitle: subtitle, date: date)
                date += TimeInterval(notificationRepeatInterval.rawValue)
            }
        }
    }
    
    private func isDNDActive(startDate: Date, stopDate: Date, notificationDate: Date) -> Bool {
        
        let calendar = Calendar.current
        let startTime = calendar.dateComponents([.hour, .minute], from: startDate)
        let stopTime = calendar.dateComponents([.hour, .minute], from: stopDate)
        let dateTime = calendar.dateComponents([.hour, .minute], from: notificationDate)
        
        guard let start: Date = calendar.date(from: startTime),
              let stop: Date = calendar.date(from: stopTime),
              let date: Date = calendar.date(from: dateTime) else
        {
            print("Cannot create date from components")
            return false
        }
        var result: Bool
        
        if start > stop{
            let nightRange = stop...start
            result = !nightRange.contains(date)
        } else {
            let dayRange = start...stop
            result = dayRange.contains(date)
        }
        return result
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(storage: Storage())
    }
}

