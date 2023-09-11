import Foundation

// Int = seconds
enum NotificationReapeatInterval: Int, Hashable, CaseIterable {
    #if DEBUG
    case twoSeconds     = 2
    #endif
    case oneMinute      = 60
    case thirtyMinutes  = 1800
    case oneHour        = 3600
    case twoHours       = 7200
    case fiveHours      = 18000
    case oneDay         = 86400
    case twoDays        = 172800
    
    var name: String {
        switch self {
        #if DEBUG
        case .twoSeconds:
            return "2 seconds"
        #endif
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
        case .twoDays:
            return "2 days"
        }
    }
}
