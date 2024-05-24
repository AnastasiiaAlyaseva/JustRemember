
import SwiftUI

protocol DoNotDisturbServiceProtocol {
    
    var mode: DoNotDisturbMode { get }
    func adjustNotificationDateIfNeeded(date: Date) -> Date
    
}

final class DoNotDisturbService: DoNotDisturbServiceProtocol {
    let mode: DoNotDisturbMode
    
    private let startDate: Date?
    private let stopDate: Date?
    private let range: ClosedRange<Date>?
    
    private let calendar = Calendar.current
    
    init(startDate: Date? = nil, stopDate: Date? = nil) {
        self.startDate = startDate
        self.stopDate = stopDate
        
        if let startDate = startDate, let stopDate = stopDate {
            if startDate == stopDate {
                self.range = nil
                self.mode = .inactive
            }
            else if startDate > stopDate {
                self.range = stopDate...startDate
                self.mode = .night
            } else {
                self.range = startDate...stopDate
                self.mode = .day
            }
        } else {
            self.range = nil
            self.mode = .inactive
        }
    }

    private func isDoNotDisturbActive(date: Date) -> Bool {
        guard let range = range else { return false }
        return !range.contains(date)
        
    }

    func adjustNotificationDateIfNeeded(date: Date) -> Date {
        guard let _ = startDate, let stopDate = stopDate else { return date }

        if isDoNotDisturbActive(date: date) {
            let stopTime = calendar.dateComponents([.hour, .minute], from: stopDate)
            guard let nextDate = calendar.nextDate(after: date, matching: stopTime, matchingPolicy: .nextTime) else { return date }
            return nextDate
        }
        
        return date
    }
}
