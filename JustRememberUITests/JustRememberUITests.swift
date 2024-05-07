

import XCTest

final class JustRememberUITests: XCTestCase {
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
    }
    
    func testNavigateToSettingsView() throws {
        let app = XCUIApplication()
        app.launch()
        
        // given
        let profileButton = app.buttons["profileIcon"]
        let settingsViewScreen = app.navigationBars["Settings"]
        
        // then
        XCTAssertTrue(profileButton.exists)
        profileButton.tap()
        XCTAssertTrue(settingsViewScreen.exists)
    }
    
    func testSetAppearance() throws {
        let app = XCUIApplication()
        app.launch()
        
        // given
        let profileButton = app.buttons["profileIcon"]
        let appearanceSettings = app.buttons["Appearance"]
        let appearanceSelection  = app.buttons["Dark Mode"]
        let appearanceViewScreen = app.navigationBars["Appearance"]
        
        // then
        XCTAssertTrue(profileButton.exists)
        profileButton.tap()
        XCTAssertTrue(appearanceSettings.exists)
        appearanceSettings.tap()
        XCTAssertTrue(appearanceViewScreen.exists)
        XCTAssertTrue(appearanceSelection.exists)
        XCTAssertTrue(appearanceSelection.isEnabled)
        appearanceSelection.tap()
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
