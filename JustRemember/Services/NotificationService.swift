import SwiftUI
import UserNotifications

protocol NotificationServiceProtocol {
    
    func checkStatus(completion: @escaping (NotificationStatus) -> ())
    func requestPermission(completion: @escaping (Bool) -> ())
    func checkPlannedNotifications() async -> Bool
    func sendNotification(title: String, subtitle: String, date: Date)
    func sendRepeatingNotification(title: String, subtitle: String, reapeatInterval: TimeInterval)
    func cancelAllNotifications()

}

final class NotificationService: NotificationServiceProtocol {
    private let currentNotification = UNUserNotificationCenter.current()
    
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
    
    func checkPlannedNotifications() async -> Bool {
        let pendingRequest = await currentNotification.pendingNotificationRequests()
        print("Pending: \(pendingRequest.count)")
        return pendingRequest.count > 0
    }
    
    func sendNotification(title: String, subtitle: String, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = subtitle
        content.sound = UNNotificationSound.default
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        currentNotification.add(request)
    }
    
    func sendRepeatingNotification(title: String, subtitle: String, reapeatInterval: TimeInterval) {
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
    
    
}
