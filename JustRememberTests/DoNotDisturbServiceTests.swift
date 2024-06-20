

import XCTest
@testable import JustRemember

final class DoNotDisturbServiceTests: XCTestCase {
    
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
        
        let doNotDisturbService = DoNotDisturbService(startDate: start, stopDate: stop)
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
        let doNotDisturbService = DoNotDisturbService(startDate: start, stopDate: stop)
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
        
        let doNotDisturbService = DoNotDisturbService(startDate: start, stopDate: stop)
        let mode = doNotDisturbService.mode
        XCTAssertEqual(mode, .day, "Expected mode to be day")
    }
    
    // ---- 8.01 -- x -- 8.00 (tomorrow) ----
    func testSetModeIsNightDuringSpecifiedTime() throws {
        guard let start: Date = today(hour: 8, minute: 1),
              let stop: Date = tomorrow(hour: 8, minute: 0) else
        {
            XCTFail("Failed to create start or stop date for night mode")
            return
        }
        
        let doNotDisturbService = DoNotDisturbService(startDate: start, stopDate: stop)
        let mode = doNotDisturbService.mode
        XCTAssertEqual(mode, .night, "Expected mode to be night")
    }
    
    // MARK: - DoNotDisturb Day Mode
    // x = notification time
    
    // ---- 8.00 -- x -- 20.00 ----
    // expect: 20.00
    func testNotificationDateInDoNotDisturbRange() throws {
        let start = today(hour: 8, minute: 0)
        let stop = today(hour: 20, minute: 0)
        let notificationDate = today(hour: 10, minute: 0)
        
        guard let start, let stop, let notificationDate else {
            XCTFail("Failed to create start, stop, notification date for active adjustment test")
            return
        }
        
        let doNotDisturbService = DoNotDisturbService(startDate: start, stopDate: stop)
        let adjustedDate = doNotDisturbService.adjustNotificationDateIfNeeded(date: notificationDate)
        XCTAssertEqual(adjustedDate, stop, "Expected notification date to remain unchanged")
    }
    
    // -- x -- 8.00 ---- 20.00 ----
    // expect: x
    func testNotificationDateBeforeStartTimeDoNotDisturbRange() throws {
        guard let start: Date = today(hour: 8, minute: 0),
              let stop: Date = today(hour: 20, minute: 0),
              let notificationDate: Date = today(hour: 6, minute: 0) else
        {
            XCTFail("Failed to create start, stop, notification date for inactive adjustment test")
            return
        }
        
        let doNotDisturbService = DoNotDisturbService(startDate: start, stopDate: stop)
        let adjustedDate = doNotDisturbService.adjustNotificationDateIfNeeded(date: notificationDate)
        XCTAssertEqual(adjustedDate, notificationDate, "Expected notification date to be adjusted")
    }
    
    // ---- 8.00 ---- 20.00 -- x --
    // expect: x
    func testNotificationDateAfterStopTimeDoNotDisturbRange() throws {
        guard let start: Date = today(hour: 8, minute: 0),
              let stop: Date = today(hour: 20, minute: 0),
              let notificationDate: Date = today(hour: 23, minute: 0) else
        {
            XCTFail("Failed to create start, stop, notification date for inactive adjustment test")
            return
        }
        
        let doNotDisturbService = DoNotDisturbService(startDate: start, stopDate: stop)
        let adjustedDate = doNotDisturbService.adjustNotificationDateIfNeeded(date: notificationDate)
        XCTAssertEqual(adjustedDate, notificationDate, "Expected notification date to be adjusted")
    }
    
    // ---- 8.00 == x ---- 20.00 ----
    // expect: 20.00
    func testNotificationDateEqualesStartTime() throws {
        guard let start: Date = today(hour: 8, minute: 0),
              let stop: Date = today(hour: 20, minute: 0),
              let notificationDate: Date = today(hour: 8, minute: 0)
        else
        {
            XCTFail("Failed to create start, stop, notification date for inactive adjustment test")
            return
        }
        
        let doNotDisturbService = DoNotDisturbService(startDate: start, stopDate: stop)
        let adjustedDate = doNotDisturbService.adjustNotificationDateIfNeeded(date: notificationDate)
        XCTAssertEqual(adjustedDate, stop)
    }
    
    // ---- 8.00 ---- 20.00 == x ----
    // expect: 20.00
    func testNotificationDateEqualesStopTime() throws {
        guard let start: Date = today(hour: 8, minute: 0),
              let stop: Date = today(hour: 20, minute: 0),
              let notificationDate: Date = today(hour: 20, minute: 0) else
        {
            XCTFail("Failed to create start, stop, notification date for inactive adjustment test")
            return
        }
        
        let doNotDisturbService = DoNotDisturbService(startDate: start, stopDate: stop)
        let adjustedDate = doNotDisturbService.adjustNotificationDateIfNeeded(date: notificationDate)
        XCTAssertEqual(adjustedDate, stop)
    }
    
    // MARK: - DoNotDisturb Night Mode
    // x = notification time
    
    // ---- 20.00 -- x -- 8.00 ----
    // expect: 8.00
    func testNotificationWithinNightModeRange() throws {
        guard let start: Date = today(hour: 20, minute: 0),
              let stop: Date = tomorrow(hour: 8, minute: 0),
              let notificationDate: Date = today(hour: 23, minute: 0) else
        {
            XCTFail("Failed to create start, stop or notification date for night mode test")
            return
        }
        
        let doNotDisturbService = DoNotDisturbService(startDate: start, stopDate: stop)
        let adjustedDate = doNotDisturbService.adjustNotificationDateIfNeeded(date: notificationDate)
        XCTAssertEqual(adjustedDate, stop, "Expected notification date to remain unchanged within night mode")
    }
    
    // -- x -- 20.00 ---- 8.00 ----
    // expect: x
    func testNotificationBeforeNightMode() throws {
        guard let start: Date = today(hour: 20, minute: 0),
              let stop: Date = tomorrow(hour: 8, minute: 0),
              let notificationDate: Date = today(hour: 18, minute: 0) else
        {
            XCTFail("Failed to create start, stop or notification date for night mode test")
            return
        }
        
        let doNotDisturbService = DoNotDisturbService(startDate: start, stopDate: stop)
        let adjustedDate = doNotDisturbService.adjustNotificationDateIfNeeded(date: notificationDate)
        XCTAssertEqual(adjustedDate, notificationDate, "Expected notification date to remain unchanged before night mode")
    }
    
    // ---- 20.00 ---- 8.00 -- x --
    // expect: x
    func testNotificationAfterNightMode() throws {
        guard let start: Date = today(hour: 20, minute: 0),
              let stop: Date = tomorrow(hour: 8, minute: 0),
              let notificationDate: Date = tomorrow(hour: 10, minute: 0) else
        {
            XCTFail("Failed to create start, stop or notification date for night mode test")
            return
        }
        
        let doNotDisturbService = DoNotDisturbService(startDate: start, stopDate: stop)
        let adjustedDate = doNotDisturbService.adjustNotificationDateIfNeeded(date: notificationDate)
        XCTAssertEqual(adjustedDate, notificationDate, "Expected notification date to remain unchanged after night mode")
    }
    
    // ---- 20.00 == x ---- 8.00
    // expect: 20.00
    func testNotificationDateEqualesStartTimeNightMode() throws {
        guard let start: Date = today(hour: 20, minute: 0),
              let stop: Date = tomorrow(hour: 8, minute: 0),
              let notificationDate: Date = today(hour: 20, minute: 0) else
        {
            XCTFail("Failed to create start, stop or notification date for night mode test")
            return
        }
        
        let doNotDisturbService = DoNotDisturbService(startDate: start, stopDate: stop)
        let adjustedDate = doNotDisturbService.adjustNotificationDateIfNeeded(date: notificationDate)
        XCTAssertEqual(adjustedDate, notificationDate)
    }
    
    // ---- 20.00 ~= x ---- 8.00
    // expect: 8.00
    func testNotificationDateOneMinuteDifferenceOfStartTimeNightMode() throws {
        guard let start: Date = today(hour: 20, minute: 0),
              let stop: Date = tomorrow(hour: 8, minute: 0),
              let notificationDate: Date = today(hour: 20, minute: 1) else
        {
            XCTFail("Failed to create start, stop or notification date for night mode test")
            return
        }
        
        let doNotDisturbService = DoNotDisturbService(startDate: start, stopDate: stop)
        let adjustedDate = doNotDisturbService.adjustNotificationDateIfNeeded(date: notificationDate)
        XCTAssertEqual(adjustedDate, stop)
    }
    
    // ---- 20.00 ---- 8.00 == x ----
    // expect: x
    func testNotificationDateEqualesStopTimeNightMode() throws {
        guard let start: Date = today(hour: 20, minute: 0),
              let stop: Date = tomorrow(hour: 8, minute: 0),
              let notificationDate: Date = tomorrow(hour: 8, minute: 0) else
        {
            XCTFail("Failed to create start, stop or notification date for night mode test")
            return
        }
        
        let doNotDisturbService = DoNotDisturbService(startDate: start, stopDate: stop)
        let adjustedDate = doNotDisturbService.adjustNotificationDateIfNeeded(date: notificationDate)
        XCTAssertEqual(adjustedDate, notificationDate)
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
