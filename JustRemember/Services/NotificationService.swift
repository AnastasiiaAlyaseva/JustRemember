import SwiftUI
import UserNotifications

protocol NotificationServiceProtocol {
    
    func checkStatus(completion: @escaping (NotificationStatus) -> ())
    func requestPermission(completion: @escaping (Bool) -> ())
    func countRemainingNotifications() async -> Int
    func scheduleNotification(title: String, subtitle: String, date: Date)
    func scheduleRepeatingNotification(title: String, subtitle: String, reapeatInterval: TimeInterval)
    func cancelAllNotifications()

}

final class NotificationService: NSObject, NotificationServiceProtocol, UNUserNotificationCenterDelegate {
    private let currentNotification = UNUserNotificationCenter.current()
    
    override init() {
        super.init()
        currentNotification.delegate = self
    }
    
    func checkStatus(completion: @escaping (NotificationStatus) -> ()) {
        currentNotification.getNotificationSettings(completionHandler: { (settings) in
           if settings.authorizationStatus == .notDetermined {
               print("Notification permission is yet to be been asked go for it!")
               completion(NotificationStatus.notDetermined)
           } else if settings.authorizationStatus == .denied {
               print("Notification permission was denied previously, go to settings & privacy to re-enable the permission")
               completion(NotificationStatus.denied)
           } else if settings.authorizationStatus == .authorized {
               print("Notification permission already granted")
               completion(NotificationStatus.autorized)
           }
        })
    }
    
    func requestPermission(completion: @escaping (Bool) -> ()) {
        currentNotification.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Granted permission of notifications!")
                completion(true)
            } else if let error = error {
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
    
    func countRemainingNotifications() async -> Int {
        let pendingRequests = await currentNotification.pendingNotificationRequests()
        let count = pendingRequests.count
        print("Remaining notifications count: \(count)")
        return count
    }
    
    func scheduleNotification(title: String, subtitle: String, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = subtitle
        content.sound = UNNotificationSound.default
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        currentNotification.add(request) { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    func scheduleRepeatingNotification(title: String, subtitle: String, reapeatInterval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: reapeatInterval, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        currentNotification.add(request)
    }
    
    func cancelAllNotifications() {
        currentNotification.removeAllPendingNotificationRequests()
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.banner, .sound])
    }
    
}
