import Foundation

// Int = seconds
enum NotificationReapeatInterval: Int, Hashable {
    case twoSeconds     = 2
    case oneMinute      = 60
    case thirtyMinutes  = 1800
    case oneHour        = 3600
    case twoHours       = 7200
    case fiveHours      = 18000
    case oneDay         = 86400
    
    var name: String {
        switch self {
        case .twoSeconds:
            return "2 seconds"
        case .oneMinute:
            return "1 minute"
        case .thirtyMinutes:
            return "30 minutes"
        case .oneHour:
            return "1 hour"
        case .twoHours:
            return "2 hours"
        case .fiveHours:
            return "5 hours"
        case .oneDay:
            return "1 day"
        }
    }
}
