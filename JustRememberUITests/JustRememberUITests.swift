

import XCTest

final class JustRememberUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()
    }
    
    func testNavigateToSettingsView() throws {
        // given
        let profileButton = app.buttons[Accessibility.HomeView.settingsViewButton]
        let settingsViewScreen = app.collectionViews[Accessibility.SettingsView.settingsViewIdentifier]
        let settingsViewScreenTitle = app.navigationBars["Settings"]
        
        // then
        XCTAssertTrue(profileButton.exists)
        profileButton.tap()
        XCTAssertTrue(settingsViewScreen.exists)
        XCTAssertTrue(settingsViewScreenTitle.exists)
    }

    func testSetAppearance() throws {
        // given
        let profileButton = app.buttons[Accessibility.HomeView.settingsViewButton]
        let appearanceSettings = app.buttons[Accessibility.SettingsView.appearanceIdentifier]
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
        let startViewScreenTitle = app.navigationBars["Topics"]
        XCTAssertTrue(startViewScreenTitle.exists)
        
        let elementsQuery = app.scrollViews.otherElements
        let topicIdentifier = elementsQuery.buttons.firstMatch
        let exists = NSPredicate(format: "exists == 1")
        expectation(for: exists, evaluatedWith: topicIdentifier, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        topicIdentifier.tap()
        
        let wordIdentifier = elementsQuery.buttons.firstMatch
        let topicsView = app.scrollViews[Accessibility.TopicsView.topicsViewIdentifier].firstMatch
        XCTAssertTrue(topicsView.exists)
        XCTAssertTrue(wordIdentifier.exists)
        wordIdentifier.tap()
        
        let imageWordsView = app.images[Accessibility.WordDescriptionView.wordImageIdentifier]
        let wordTitle = app.staticTexts[Accessibility.WordDescriptionView.wordTitleIdentifier]
        let wordSubtitle = app.staticTexts[Accessibility.WordDescriptionView.wordSubtitleIdentifier]
        XCTAssertTrue(imageWordsView.exists)
        XCTAssertTrue(wordTitle.exists)
        XCTAssertTrue(wordSubtitle.exists)
    }
}
