

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
        let profileButton = app.buttons["SettingsViewButtonIdentifier"]
        let settingsViewScreen = app.collectionViews["SettingsViewIdentifier"]
        let settingsViewScreenTitle = app.navigationBars["Settings"]
        
        // then
        XCTAssertTrue(profileButton.exists)
        profileButton.tap()
        XCTAssertTrue(settingsViewScreen.exists)
        XCTAssertTrue(settingsViewScreenTitle.exists)
    }
    
    func testSetAppearance() throws {
        let app = XCUIApplication()
        app.launch()
        
        // given
        let profileButton = app.buttons["SettingsViewButtonIdentifier"]
        let appearanceSettings = app.buttons["AppearanceIdentifier"]
        let appearanceSelection  = app.buttons["Dark Mode"]
        let appearanceViewScreenTitle = app.navigationBars["Appearance"]
        
        // then
        XCTAssertTrue(profileButton.exists)
        profileButton.tap()
        XCTAssertTrue(appearanceSettings.exists)
        appearanceSettings.tap()
        XCTAssertTrue(appearanceViewScreenTitle.exists)
        XCTAssertTrue(appearanceSelection.exists)
        XCTAssertTrue(appearanceSelection.isEnabled)
        appearanceSelection.tap()
    }
    
    func testNavigationToWordDescription() throws {
        let app = XCUIApplication()
        app.launch()
        
        let startViewScreenTitle = app.navigationBars["Topics"]
        XCTAssertTrue(startViewScreenTitle.exists)
        
        let elementsQuery = app.scrollViews.otherElements
        let topicIdentifier = elementsQuery.buttons.firstMatch
        let exists = NSPredicate(format: "exists == 1")
        expectation(for: exists, evaluatedWith: topicIdentifier, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        topicIdentifier.tap()
        
        let wordIdentifier = elementsQuery.buttons.firstMatch
        let topicsView = app.scrollViews["TopicsViewIdentifier"].firstMatch
        XCTAssertTrue(topicsView.exists)
        XCTAssertTrue(wordIdentifier.exists)
        wordIdentifier.tap()
        
        let imageWordsView = app.images["ImageIdentifier"]
        let wordTitle = app.staticTexts["WordTitleIdentifier"]
        let wordSubtitle = app.staticTexts["WordSubtitleIdentifier"]
        XCTAssertTrue(imageWordsView.exists)
        XCTAssertTrue(wordTitle.exists)
        XCTAssertTrue(wordSubtitle.exists)
    }
}
