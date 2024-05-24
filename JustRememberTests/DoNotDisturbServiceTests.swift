

import XCTest
@testable import JustRemember

final class DoNotDisturbServiceTests: XCTestCase {
    
    var doNotDisturbService: DoNotDisturbServiceProtocol = DoNotDisturbService()
    let calendar = Calendar.current
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testInactivMode() throws {
        let mode = doNotDisturbService.mode
        XCTAssertEqual(mode, .inactive, "Expected mode to be inactive")
    }
    
    func testDayMode() throws {
        let startTime = DateComponents(hour: 8, minute: 0)
        let stopTime = DateComponents(hour: 20, minute: 0)
        
        guard let start: Date = calendar.date(from: startTime),
              let stop: Date = calendar.date(from: stopTime) else
        {
            XCTFail("Failed to create start or stop date for day mode")
            return
        }
        
        doNotDisturbService = DoNotDisturbService(startDate: start, stopDate: stop)
        let mode = doNotDisturbService.mode
        XCTAssertEqual(mode, .day, "Expected mode to be day")
    }
    
    func testNightMode() throws {
        let startTime = DateComponents(hour: 20, minute: 0)
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
    
    func testStartTimeEqualesStopTime() throws {
        let startTime = DateComponents(hour: 8, minute: 0)
        let stopTime = DateComponents(hour: 8, minute: 0)
        
        guard let start: Date = calendar.date(from: startTime),
              let stop: Date = calendar.date(from: stopTime) else
        {
            XCTFail("Failed to create start or stop date when start time equals stop time")
            return
        }
        doNotDisturbService = DoNotDisturbService(startDate: start, stopDate: stop)
        let mode = doNotDisturbService.mode
        XCTAssertEqual(mode, .inactive, "Should be inactive when start time equals stop time")
    }
    
    func testSetsDayModeForShortDuration() throws {
        let startTime = DateComponents(hour: 8, minute: 0)
        let stopTime = DateComponents(hour: 8, minute: 1)
        
        guard let start: Date = calendar.date(from: startTime),
              let stop: Date = calendar.date(from: stopTime) else
        {
            XCTFail("Failed to create start or stop date for day mode")
            return
        }
        
        doNotDisturbService = DoNotDisturbService(startDate: start, stopDate: stop)
        let mode = doNotDisturbService.mode
        XCTAssertEqual(mode, .day, "Expected mode to be day")
    }
    
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
    
    func testNotificationDateInDoNotDisturbRange() throws {
        let startTime = DateComponents(hour: 8, minute: 0)
        let stopTime = DateComponents(hour: 20, minute: 0)
        let notificationTime = DateComponents(hour: 10, minute: 0)
        
        guard let start: Date = calendar.date(from: startTime),
              let stop: Date = calendar.date(from: stopTime),
              let notificationDate: Date = calendar.date(from: notificationTime) else
        {
            XCTFail("Failed to create start, stop, notification date for active adjustment test")
            return
        }
        
        doNotDisturbService = DoNotDisturbService(startDate: start, stopDate: stop)
        let adjustedDate = doNotDisturbService.adjustNotificationDateIfNeeded(date: notificationDate)
        XCTAssertEqual(adjustedDate, stop, "Expected notification date to remain unchanged")
    }
    
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
        
        let adjustedDate = doNotDisturbService.adjustNotificationDateIfNeeded(date: notificationDate)
        XCTAssertEqual(adjustedDate, notificationDate)
    }
    
    func testNotificationDateEqualesStopTime() throws {
        let startTime = DateComponents(hour: 8, minute: 0)
        let stopTime = DateComponents(hour: 20, minute: 0)
        let notificationTime = DateComponents(hour: 20, minute: 0)
        
        guard let start: Date = calendar.date(from: startTime),
              let stop: Date = calendar.date(from: stopTime),
              let notificationDate: Date = calendar.date(from: notificationTime) else
        {
            XCTFail("Failed to create start, stop, notification date for inactive adjustment test")
            return
        }
        
        let adjustedDate = doNotDisturbService.adjustNotificationDateIfNeeded(date: notificationDate)
        XCTAssertEqual(adjustedDate, notificationDate)
    }
    
    func testAdjustNotificationTimeWithHoursAndMinutes() throws {
        let startTime = DateComponents(year: 2024, month: 5,day: 23, hour: 8, minute: 0, second: 0)
        let stopTime = DateComponents(year: 2024, month: 5,day: 23, hour: 20, minute: 0, second: 0)
        let notificationTime = DateComponents(year: 2024, month: 5,day: 23, hour: 6, minute: 0, second: 0)
        
        guard let startHour = startTime.hour,
              let startMinute = startTime.minute,
              let stopHour = stopTime.hour,
              let stopMinute = stopTime.minute,
              let notificationHour = notificationTime.hour,
              let notificationMinute = notificationTime.minute else
        {
            XCTFail("Failed to extract components from DateComponents")
            return
        }
        
        let adjustedStartTime = DateComponents(hour: startHour, minute: startMinute)
        let adjustedStopTime = DateComponents(hour: stopHour, minute: stopMinute)
        let adjustedNotificationTime = DateComponents(hour: notificationHour, minute: notificationMinute)
        
        guard let start: Date = calendar.date(from: adjustedStartTime),
              let stop: Date = calendar.date(from: adjustedStopTime),
              let notificationDate: Date = calendar.date(from: adjustedNotificationTime) else
        {
            XCTFail("Failed to create dates from adjusted DateComponents")
            return
        }
        
        doNotDisturbService = DoNotDisturbService(startDate: start, stopDate: stop)
        let adjustedDate = doNotDisturbService.adjustNotificationDateIfNeeded(date: notificationDate)
        
        XCTAssertEqual(adjustedDate, notificationDate, "Expected notification date to be adjusted within DoNotDisturb range")
    }
    
}
