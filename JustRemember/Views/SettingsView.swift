import SwiftUI

struct SettingsView: View {
    let storage: Storage
    
    private let notificationService: NotificationServiceProtocol = NotificationService()
    
    private let calendar = Calendar.current
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
                            .accessibilityIdentifier(Accessibility.SettingsView.notificationsToggleIdentifier)
                        
                        if isNotificationsEnabled {
                            
                            if notificationCount > 0 {
                                Text("\(notificationCount) notifications remaining")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            } else {
                                DatePicker("Start date:", selection: $notificationsStartDate, in: Date()...)
                                    .accessibilityIdentifier(Accessibility.SettingsView.notificationsStartDatePickerIdentifier)
                                Picker("Reapeat interval", selection: $notificationRepeatInterval) {
                                    ForEach(NotificationReapeatInterval.allCases, id:\.self) { interval in
                                        Text(interval.name).tag(interval)
                                    }
                                }.accessibilityIdentifier(Accessibility.SettingsView.notificationRepeatIntervalPickerIdentifier)
                                    .pickerStyle(MenuPickerStyle())
                                    .accentColor(.label)
                                
                                Button("Remember random words") {
                                    scheduleAllWords()
                                    Task {
                                        let notificationCount = await notificationService.countRemainingNotifications()
                                        if notificationCount == 0 {
                                            errorScheduleNotificationAlert = true
                                        }
                                        self.notificationCount = notificationCount
                                    }
                                }
                                .accessibilityIdentifier(Accessibility.SettingsView.rememberRandomWordsIdentifier)
                                .alert(isPresented:$errorScheduleNotificationAlert) {
                                    return Alert(
                                        title: Text("Oops!\n Check system permissions or time of notifications."),
                                        dismissButton: .default(Text("Ok"))
                                    )
                                }
                            }
                        }
                    }
                
                Section(header: Text("Do not disturb"),
                        footer: Text(isDoNotDisturbEnabled ? doNotDisturbHintText(startDate: doNotDisturbStartDate, stopDate: doNotDisturbStopDate) : "")
                    .font(.footnote)
                    .foregroundColor(.gray))
                {
                    Toggle("Do not disturb", isOn: $isDoNotDisturbEnabled.animation())
                        .accessibilityIdentifier(Accessibility.SettingsView.doNotDisturbToggleIdentifier)
                    
                    if isDoNotDisturbEnabled {
                        DatePicker("From", selection: $doNotDisturbStartDate, displayedComponents: .hourAndMinute)
                            .accessibilityIdentifier(Accessibility.SettingsView.doNotDisturbStartDatePickerIdentifier)
                        DatePicker("To", selection: $doNotDisturbStopDate, displayedComponents: .hourAndMinute)
                            .accessibilityIdentifier(Accessibility.SettingsView.doNotDisturbStopDatePickerIdentifier)
                    }
                }.disabled(notificationCount > 0)
                
                Section(header: Text("Appearance")) {
                    NavigationLink("Appearance", destination: AppearanceView())
                }
                .accessibilityIdentifier(Accessibility.SettingsView.appearanceIdentifier)
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
        .accessibilityIdentifier(Accessibility.SettingsView.settingsViewIdentifier)
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
        var currentNotificationDate = notificationsStartDate
        var allWords: [Word] = []
        for collection in storage.collections {
            allWords += collection.words
        }
        let randomWords = allWords.shuffled().prefix(AppConstatns.maxCountNotification)
        for word in randomWords {
            let title = word.word
            let subtitle = word.meaning
            
            if isDoNotDisturbEnabled {
                let doNotDisturbMode = DoNotDisturbService(startDate: doNotDisturbStartDate, stopDate: doNotDisturbStopDate)
                currentNotificationDate = doNotDisturbMode.adjustNotificationDateIfNeeded(date: currentNotificationDate)
            }
            
            // uncomment for testing
             print("title=\(title) currentNotificationDate=\(currentNotificationDate.formatted())")
            
            notificationService.scheduleNotification(title: title, subtitle: subtitle, date: currentNotificationDate)
            currentNotificationDate += TimeInterval(notificationRepeatInterval.rawValue)
        }
    }
    
    //    private func adjustCurrentNotificationDateIfNeeded(date: Date, doNotDisturbMode: DoNotDisturbMode, doNotDisturbStopDate: Date) -> Date {
    //
    //        switch doNotDisturbMode {
    //        case .day, .night:
    //            // day: set time
    //            // night: next day + set time
    //            // autocalculation via nextDate()
    //            let stopTime = calendar.dateComponents([.hour, .minute], from: doNotDisturbStopDate)
    //            guard let nextDate = calendar.nextDate(after: date, matching: stopTime, matchingPolicy: .nextTime) else { return date }
    //            return nextDate
    //
    //        case .inactive:
    //            return date
    //        }
    //    }
    
    //    private func checkDoNotDisturbMode(startDate: Date, stopDate: Date, notificationDate: Date) -> DoNotDisturbMode {
    //        var doNotDisturbMode: DoNotDisturbMode = .inactive
    //
    //        let startTime = calendar.dateComponents([.hour, .minute], from: startDate)
    //        let stopTime = calendar.dateComponents([.hour, .minute], from: stopDate)
    //        let dateTime = calendar.dateComponents([.hour, .minute], from: notificationDate)
    //
    //        guard let start: Date = calendar.date(from: startTime),
    //              let stop: Date = calendar.date(from: stopTime),
    //              let date: Date = calendar.date(from: dateTime) else
    //        {
    //            print("Cannot create date from components")
    //            return doNotDisturbMode
    //        }
    //
    //        if start > stop{
    //            let nightRange = stop...start
    //            let isDoNotDisturbActive = !nightRange.contains(date)
    //
    //            if isDoNotDisturbActive {
    //                doNotDisturbMode = .night
    //            }
    //        } else {
    //            let dayRange = start...stop
    //            let isDoNotDisturbActive = dayRange.contains(date)
    //
    //            if isDoNotDisturbActive {
    //                doNotDisturbMode = .day
    //            }
    //        }
    //
    //        return doNotDisturbMode
    //    }
    //
    //    private func checkDoNotDisturbMode(startDate: Date, stopDate: Date) -> DoNotDisturbMode {
    //        var doNotDisturbMode: DoNotDisturbMode = .inactive
    //
    //        let startTime = calendar.dateComponents([.hour, .minute], from: startDate)
    //        let stopTime = calendar.dateComponents([.hour, .minute], from: stopDate)
    //
    //        guard let start: Date = calendar.date(from: startTime),
    //              let stop: Date = calendar.date(from: stopTime) else
    //        {
    //            print("Cannot create date from components")
    //            return doNotDisturbMode
    //        }
    //
    //        if start > stop {
    //            doNotDisturbMode = .night
    //        } else {
    //            doNotDisturbMode = .day
    //        }
    //
    //        return doNotDisturbMode
    //    }
    
    private func doNotDisturbHintText(startDate: Date, stopDate: Date) -> String {
        let startTime = startDate.formatted(date: .omitted, time: .shortened)
        let stopTime = stopDate.formatted(date: .omitted, time: .shortened)
        let mode = DoNotDisturbService(startDate: startDate, stopDate: stopDate).mode
        let tail = (mode == .night) ? "next day" : ""
        let message = "Every day\n\(startTime) - \(stopTime) \(tail)"
        return message
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(storage: Storage())
    }
}

