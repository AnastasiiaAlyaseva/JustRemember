

import XCTest
@testable import JustRemember

final class DoNotDisturbServiceTests: XCTestCase {
    
    var doNotDisturbService: DoNotDisturbServiceProtocol = DoNotDisturbService() //remove
    let calendar = Calendar.current
    
    // MARK: - Mode
    // x = mode
    
    // ------ x ------
    func testInactivMode() throws {
        let doNotDisturbService: DoNotDisturbServiceProtocol = DoNotDisturbService()
        let mode = doNotDisturbService.mode
        XCTAssertEqual(mode, .inactive, "Expected mode to be inactive")
    }
    
    // ---- 8.00 -- x -- 20.00 ----
    func testDayMode() throws {
        guard let start: Date = today(hour: 8, minute: 0),
              let stop: Date = today(hour: 20, minute: 0) else
        {
            XCTFail("Failed to create start or stop date for day mode")
            return
        }
        
        let doNotDisturbService: DoNotDisturbServiceProtocol = DoNotDisturbService(startDate: start, stopDate: stop)
        let mode = doNotDisturbService.mode
        XCTAssertEqual(mode, .day, "Expected mode to be day")
    }
    
    // ---- 20.00 -- x -- 8.00 (tomorrow) ----
    func testNightMode() throws {
        guard let start: Date = today(hour: 20, minute: 0),
              let stop: Date = tomorrow(hour: 8, minute: 0) else
        {
            XCTFail("Failed to create start or stop date for night mode")
            return
        }
        
        doNotDisturbService = DoNotDisturbService(startDate: start, stopDate: stop)
        let mode = doNotDisturbService.mode
        XCTAssertEqual(mode, .night, "Expected mode to be night")
    }
    
    // ---- 8.00 == x == 8.00 ----
    func testStartTimeEqualesStopTime() throws {
        guard let start: Date =  today(hour: 8, minute: 0),
              let stop: Date = today(hour: 8, minute: 0) else
        {
            XCTFail("Failed to create start or stop date when start time equals stop time")
            return
        }
        doNotDisturbService = DoNotDisturbService(startDate: start, stopDate: stop)
        let mode = doNotDisturbService.mode
        XCTAssertEqual(mode, .inactive, "Should be inactive when start time equals stop time")
    }
    
    // ---- 8.00 -- x -- 8.01 ----
    func testSetsDayModeForShortDuration() throws {
        guard let start: Date = today(hour: 8, minute: 0),
              let stop: Date = today(hour: 8, minute: 1) else
        {
            XCTFail("Failed to create start or stop date for day mode")
            return
        }
        
        doNotDisturbService = DoNotDisturbService(startDate: start, stopDate: stop)
        let mode = doNotDisturbService.mode
        XCTAssertEqual(mode, .day, "Expected mode to be day")
    }
    
    // ---- 8.01 -- x -- 8.00 (tomorrow) ----
    func testSetModeIsNightDuringSpecifiedTime() throws {
        let startTime = DateComponents(hour: 8, minute: 1)
        let stopTime = DateComponents(hour: 8, minute: 0)
        
        guard let start: Date = calendar.date(from: startTime),
              let stop: Date = calendar.date(from: stopTime) else
        {
            XCTFail("Failed to create start or stop date for night mode")
            return
        }
        
        doNotDisturbService = DoNotDisturbService(startDate: start, stopDate: stop)
        let mode = doNotDisturbService.mode
        XCTAssertEqual(mode, .night, "Expected mode to be night")
    }
    
    // MARK: - DoNotDisturb Day Mode
    // x = notification time
    
    // ---- 8.00 -- x -- 20.00 ----
    func testNotificationDateInDoNotDisturbRange() throws {
        let start = today(hour: 8, minute: 0)
        let stop = today(hour: 20, minute: 0)
        let notificationDate = today(hour: 10, minute: 0)
        
        guard let start, let stop, let notificationDate else {
            XCTFail("Failed to create start, stop, notification date for active adjustment test")
            return
        }
        
        doNotDisturbService = DoNotDisturbService(startDate: start, stopDate: stop)
        let adjustedDate = doNotDisturbService.adjustNotificationDateIfNeeded(date: notificationDate)
        XCTAssertEqual(adjustedDate, stop, "Expected notification date to remain unchanged")
    }
    
    // -- x -- 8.00 ---- 20.00 ----
    func testNotificationDateBeforeStartTimeDoNotDisturbRange() throws {
        let startTime = DateComponents(hour: 8, minute: 0)
        let stopTime = DateComponents(hour: 20, minute: 0)
        let notificationTime = DateComponents(hour: 6, minute: 0)
        
        guard let start: Date = calendar.date(from: startTime),
              let stop: Date = calendar.date(from: stopTime),
              let notificationDate: Date = calendar.date(from: notificationTime) else
        {
            XCTFail("Failed to create start, stop, notification date for inactive adjustment test")
            return
        }
        
        doNotDisturbService = DoNotDisturbService(startDate: start, stopDate: stop)
        let adjustedDate = doNotDisturbService.adjustNotificationDateIfNeeded(date: notificationDate)
        XCTAssertEqual(adjustedDate, notificationDate, "Expected notification date to be adjusted")
    }
    
    // ---- 8.00 ---- 20.00 -- x --
    func testNotificationDateAfterStopTimeDoNotDisturbRange() throws {
        let startTime = DateComponents(hour: 8, minute: 0)
        let stopTime = DateComponents(hour: 20, minute: 0)
        let notificationTime = DateComponents(hour: 23, minute: 0)
        
        guard let start: Date = calendar.date(from: startTime),
              let stop: Date = calendar.date(from: stopTime),
              let notificationDate: Date = calendar.date(from: notificationTime) else
        {
            XCTFail("Failed to create start, stop, notification date for inactive adjustment test")
            return
        }
        
        doNotDisturbService = DoNotDisturbService(startDate: start, stopDate: stop)
        let adjustedDate = doNotDisturbService.adjustNotificationDateIfNeeded(date: notificationDate)
        XCTAssertEqual(adjustedDate, notificationDate, "Expected notification date to be adjusted")
    }
    
    // ---- 8.00 == x ---- 20.00 ----
    func testNotificationDateEqualesStartTime() throws {
        let startTime = DateComponents(hour: 8, minute: 0)
        let stopTime = DateComponents(hour: 20, minute: 0)
        let notificationTime = DateComponents(hour: 8, minute: 0)
        
        guard let start: Date = calendar.date(from: startTime),
              let stop: Date = calendar.date(from: stopTime),
              let notificationDate: Date = calendar.date(from: notificationTime) else
        {
            XCTFail("Failed to create start, stop, notification date for inactive adjustment test")
            return
        }
        
        doNotDisturbService = DoNotDisturbService(startDate: start, stopDate: stop)
        let adjustedDate = doNotDisturbService.adjustNotificationDateIfNeeded(date: notificationDate)
        XCTAssertEqual(adjustedDate, notificationDate)
    }
    
    // ---- 8.00 ---- 20.00 == x ----
    func testNotificationDateEqualesStopTime() throws {
//        let startTime = DateComponents(hour: 8, minute: 0)
//        let stopTime = DateComponents(hour: 20, minute: 0)
//        let notificationTime = DateComponents(hour: 20, minute: 0)
//        
//        guard let start: Date = calendar.date(from: startTime),
//              let stop: Date = calendar.date(from: stopTime),
//              let notificationDate: Date = calendar.date(from: notificationTime) else
//        {
//            XCTFail("Failed to create start, stop, notification date for inactive adjustment test")
//            return
//        }
        
        guard let start: Date = today(hour: 8, minute: 0),
              let stop: Date = today(hour: 20, minute: 0),
              let notificationDate: Date = today(hour: 20, minute: 0) else
        {
            XCTFail("Failed to create start, stop, notification date for inactive adjustment test")
            return
        }
        
        doNotDisturbService = DoNotDisturbService(startDate: start, stopDate: stop)
        let adjustedDate = doNotDisturbService.adjustNotificationDateIfNeeded(date: notificationDate)
        XCTAssertEqual(adjustedDate, notificationDate)
    }
    
    // -- x -- 8.00 ---- 20.00 ----
    func testAdjustNotificationTimeWithHoursAndMinutes() throws {
        let startTime = DateComponents(year: 2024, month: 5,day: 23, hour: 8, minute: 0, second: 0)
        let stopTime = DateComponents(year: 2024, month: 5,day: 23, hour: 20, minute: 0, second: 0)
        let notificationTime = DateComponents(year: 2024, month: 5,day: 23, hour: 6, minute: 0, second: 0)
        
        guard let start: Date = calendar.date(from: startTime),
              let stop: Date = calendar.date(from: stopTime),
              let notificationDate: Date = calendar.date(from: notificationTime) else
        {
            XCTFail("Failed to create dates from adjusted DateComponents")
            return
        }
        
        doNotDisturbService = DoNotDisturbService(startDate: start, stopDate: stop)
        let adjustedDate = doNotDisturbService.adjustNotificationDateIfNeeded(date: notificationDate)
        
        XCTAssertEqual(adjustedDate, notificationDate, "Expected notification date to be adjusted within DoNotDisturb range")
    }
    
    // MARK: - DoNotDisturb Night Mode
    // x = notification time
    
    // ---- 20.00 -- x -- 8.00 ----
    func testNotificationWithinNightModeRange() throws {
        guard let start: Date = today(hour: 20, minute: 0),
              let stop: Date = tomorrow(hour: 8, minute: 0),
              let notificationDate: Date = today(hour: 23, minute: 0) else
        {
            XCTFail("Failed to create start, stop or notification date for night mode test")
            return
        }
        
        doNotDisturbService = DoNotDisturbService(startDate: start, stopDate: stop)
        let adjustedDate = doNotDisturbService.adjustNotificationDateIfNeeded(date: notificationDate)
        XCTAssertEqual(adjustedDate, stop, "Expected notification date to remain unchanged within night mode")
    }
    
    // -- x -- 20.00 ---- 8.00 ----
    func testNotificationBeforeNightMode() throws {
        guard let start: Date = today(hour: 20, minute: 0),
              let stop: Date = tomorrow(hour: 8, minute: 0),
              let notificationDate: Date = today(hour: 18, minute: 0) else
        {
            XCTFail("Failed to create start, stop or notification date for night mode test")
            return
        }
        
        doNotDisturbService = DoNotDisturbService(startDate: start, stopDate: stop)
        let adjustedDate = doNotDisturbService.adjustNotificationDateIfNeeded(date: notificationDate)
        XCTAssertEqual(adjustedDate, notificationDate, "Expected notification date to remain unchanged before night mode")
    }
    
    // ---- 20.00 ---- 8.00 -- x --
    func testNotificationAfterNightMode() throws {
        guard let start: Date = today(hour: 20, minute: 0),
              let stop: Date = tomorrow(hour: 8, minute: 0),
              let notificationDate: Date = tomorrow(hour: 10, minute: 0) else
        {
            XCTFail("Failed to create start, stop or notification date for night mode test")
            return
        }
        
        doNotDisturbService = DoNotDisturbService(startDate: start, stopDate: stop)
        let adjustedDate = doNotDisturbService.adjustNotificationDateIfNeeded(date: notificationDate)
        XCTAssertEqual(adjustedDate, notificationDate, "Expected notification date to remain unchanged after night mode")
    }
    
    // MARK: - Helpers
    
    private func todayComponents(hour: Int, minute: Int) -> DateComponents {
        let today = Date()
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: today)
        dateComponents.hour = hour
        dateComponents.minute = minute
        return dateComponents
    }
    
    private func today(hour: Int, minute: Int) -> Date? {
        let dateComponents = todayComponents(hour: hour, minute: minute)
        return calendar.date(from: dateComponents)
    }
    
    private func tomorrowComponents(hour: Int, minute: Int) -> DateComponents? {
        let today = Date()
        guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: today) else {
            XCTFail("no tomorrow date")
            return nil
        }
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: tomorrow)
        dateComponents.hour = hour
        dateComponents.minute = minute
        return dateComponents
    }
    
    private func tomorrow(hour: Int, minute: Int) -> Date? {
        guard let dateComponents = tomorrowComponents(hour: hour, minute: minute) else {
            XCTFail("no tomorrow dateComponents")
            return nil
        }
        return calendar.date(from: dateComponents)
    }
}
