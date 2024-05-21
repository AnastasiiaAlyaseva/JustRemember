
import Foundation

struct Accessibility {
    struct HomeView {
        static let settingsViewButton = "SettingsViewButtonIdentifier"
    }
    
    struct SettingsView {
        static let settingsViewIdentifier = "SettingsViewIdentifier"
        static let appearanceIdentifier = "AppearanceIdentifier"
        static let notificationsToggleIdentifier = "NotificationsToggleIdentifier"
        static let doNotDisturbToggleIdentifier = "DoNotDisturbToggleIdentifier"
        static let rememberRandomWordsIdentifier = "RememberRandomWordsIdentifier.Button"
        static let doNotDisturbStartDatePickerIdentifier = "DoNotDisturbStartDatePickerIdentifier"
        static let doNotDisturbStopDatePickerIdentifier = "DoNotDisturbStopDatePickerIdentifier"
        static let notificationsStartDatePickerIdentifier = "NotificationsStartDatePickerIdentifier"
        static let notificationRepeatIntervalPickerIdentifier = "NotificationRepeatIntervalPickerIdentifier"
    }
    
    struct TopicsView {
        static let topicsViewIdentifier = "TopicsViewIdentifier"
    }
    
    struct WordDescriptionView {
        static let wordImageIdentifier = "WordImageIdentifier"
        static let wordTitleIdentifier = "WordTitleIdentifier"
        static let wordSubtitleIdentifier = "WordSubtitleIdentifier"
    }
    
    struct AppearanceView {
        static let darkMode = "DarkModeIdentifier.Button"
        static let lightMode = "LightModeIdentifier.Button"
        static let systemMode = "SameAsDeviceSetting.Button"
        static let imageViewIdentifier = "Checkmark"
    }
}

struct TestConstatns {
    static let settingsScreenTitle = "Settings"
    static let appearanceScreenTitle = "Appearance"
    static let topicsScreenTitle = "Topics"
    static let springboardIdentifie = "com.apple.springboard"
    static let notificationPermissionButton = "Allow"
    static let remainingNotificationsCount = "64 notifications remaining"
}
