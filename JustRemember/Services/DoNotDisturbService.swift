
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
        
        guard let startDate = startDate, let stopDate = stopDate else {
            self.range = nil
            self.mode = .inactive
            return
        }
        
        let startTime = calendar.dateComponents([.hour, .minute], from: startDate)
        let stopTime = calendar.dateComponents([.hour, .minute], from: stopDate)
        
        guard let start: Date = calendar.date(from: startTime),
              let stop: Date = calendar.date(from: stopTime) else {
            self.range = nil
            self.mode = .inactive
            return
        }
        
        if start == stop {
            self.range = nil
            self.mode = .inactive
        } else if start > stop {
            self.range = stop...start
            self.mode = .night
        } else {
            self.range = start...stop
            self.mode = .day
        }
    }
    
    private func isDoNotDisturbActive(date: Date) -> Bool {
        guard let range = range else { return false }
        
        let dateTime = calendar.dateComponents([.hour, .minute], from: date)
        guard let date = calendar.date(from: dateTime) else { return false }
        
        switch mode {
        case .day:
            return range.contains(date)
        case .night:
            return !range.contains(date)
        case .inactive:
            return false
        }
        
    }
    
    func adjustNotificationDateIfNeeded(date: Date) -> Date {
        guard let _ = startDate, let stopDate = stopDate else { return date }
        
        if isDoNotDisturbActive(date: date) {
            // day: set time
            // night: next day + set time
            // autocalculation via nextDate()
            if stopDate == date { return date }
            let stopTime = calendar.dateComponents([.hour, .minute], from: stopDate)
            guard let nextDate = calendar.nextDate(after: date, matching: stopTime, matchingPolicy: .nextTime) else { return date }
            return nextDate
        }
        
        return date
    }
}
