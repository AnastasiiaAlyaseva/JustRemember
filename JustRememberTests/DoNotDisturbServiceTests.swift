

import XCTest
@testable import JustRemember

final class DoNotDisturbServiceTests: XCTestCase {
    
    let doNotDisturbService: DoNotDisturbServiceProtocol = DoNotDisturbService()
    let calendar = Calendar.current
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testDayMode() throws {
        let startTime = DateComponents(hour: 8, minute: 0)
        let stopTime = DateComponents(hour: 20, minute: 0)
        
        guard let start: Date = calendar.date(from: startTime),
              let stop: Date = calendar.date(from: stopTime) else
        {
            XCTFail("Failed")
            return
        }
        
        let doNotDisterb = DoNotDisturbService(startDate: start, stopDate: stop)
        let mode = doNotDisturbService.mode
        XCTAssertEqual(mode, .day, "Should be day")
    }
    
    func testNightMode() throws {
        let startTime = DateComponents(hour: 20, minute: 0)
        let stopTime = DateComponents(hour: 8, minute: 0)
        
        guard let start: Date = calendar.date(from: startTime),
              let stop: Date = calendar.date(from: stopTime) else
        {
            XCTFail("Failed")
            return
        }
        
        let doNotDisterb = DoNotDisturbService(startDate: start, stopDate: stop)
        let mode = doNotDisturbService.mode
        XCTAssertEqual(mode, .night, "Should be night")
    }
    
    func testInactivMode() throws {
        let mode = doNotDisturbService.mode
        XCTAssertEqual(mode, .inactive, "Should be inactive")
    }
    
    func testStartTimeEqualesStopTime() throws {
        let startTime = DateComponents(hour: 8, minute: 0)
        let stopTime = DateComponents(hour: 8, minute: 0)
        
        guard let start: Date = calendar.date(from: startTime),
              let stop: Date = calendar.date(from: stopTime) else
        {
            XCTFail("Failed")
            return
        }
        let doNotDisterb = DoNotDisturbService(startDate: start, stopDate: stop)
        let mode = doNotDisturbService.mode
        XCTAssertEqual(mode, .night, "Should be inactive")
    }
    
}
