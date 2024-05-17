

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
        let appearanceViewScreenTitle = app.navigationBars["Appearance"]
        let appearanceSelectionCellLightMode  = app.buttons[Accessibility.AppearanceView.lightMode]
        let appearanceSelectionCellDarkMode  = app.buttons[Accessibility.AppearanceView.darkMode]
        let appearanceSelectionCellSystemMode  = app.buttons[Accessibility.AppearanceView.systemMode]
        let settingsViewScreen = app.collectionViews[Accessibility.SettingsView.settingsViewIdentifier]
        let imageViewIdentifier = Accessibility.AppearanceView.imageViewIdentifier
        
        // then
        XCTAssertTrue(profileButton.exists)
        profileButton.tap()
        XCTAssertTrue(settingsViewScreen.exists)
        XCTAssertTrue(appearanceSettings.exists)
        appearanceSettings.tap()
        XCTAssertTrue(appearanceViewScreenTitle.exists)
        XCTAssertTrue(appearanceSelectionCellDarkMode.exists)
        XCTAssertTrue(appearanceSelectionCellDarkMode.isEnabled)
        XCTAssertTrue(appearanceSelectionCellLightMode.exists)
        XCTAssertTrue(appearanceSelectionCellLightMode.isEnabled)
        XCTAssertTrue(appearanceSelectionCellSystemMode.exists)
        XCTAssertTrue(appearanceSelectionCellSystemMode.isEnabled)
        
        appearanceSelectionCellDarkMode.tap()
        XCTAssertTrue(appearanceSelectionCellDarkMode.images[imageViewIdentifier].exists)
        XCTAssertFalse(appearanceSelectionCellLightMode.images[imageViewIdentifier].exists)
        XCTAssertFalse(appearanceSelectionCellSystemMode.images[imageViewIdentifier].exists)
        
        appearanceSelectionCellLightMode.tap()
        XCTAssertTrue(appearanceSelectionCellLightMode.images[imageViewIdentifier].exists)
        XCTAssertFalse(appearanceSelectionCellDarkMode.images[imageViewIdentifier].exists)
        XCTAssertFalse(appearanceSelectionCellSystemMode.images[imageViewIdentifier].exists)
        
        appearanceSelectionCellSystemMode.tap()
        XCTAssertTrue(appearanceSelectionCellSystemMode.images[imageViewIdentifier].exists)
        XCTAssertFalse(appearanceSelectionCellDarkMode.images[imageViewIdentifier].exists)
        XCTAssertFalse(appearanceSelectionCellLightMode.images[imageViewIdentifier].exists)
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
        
        let wordElement = elementsQuery.buttons.firstMatch
        let topicsView = app.scrollViews[Accessibility.TopicsView.topicsViewIdentifier].firstMatch
        XCTAssertTrue(topicsView.exists)
        XCTAssertTrue(wordElement.exists)
        wordElement.tap()
        
        let imageWordsView = app.images[Accessibility.WordDescriptionView.wordImageIdentifier]
        let wordTitle = app.staticTexts[Accessibility.WordDescriptionView.wordTitleIdentifier]
        let wordSubtitle = app.staticTexts[Accessibility.WordDescriptionView.wordSubtitleIdentifier]
        XCTAssertTrue(imageWordsView.exists)
        XCTAssertTrue(wordTitle.exists)
        XCTAssertTrue(wordSubtitle.exists)
    }
    func testScheduleNotification() throws {
        // given
        let profileButton = app.buttons[Accessibility.HomeView.settingsViewButton]
        let settingsViewScreen = app.collectionViews[Accessibility.SettingsView.settingsViewIdentifier]
        
        XCTAssertTrue(profileButton.exists)
        profileButton.tap()
        XCTAssertTrue(settingsViewScreen.exists)
        
        let notificationsToggle = app.switches["NotificationsIdentifier"]
        XCTAssertTrue(notificationsToggle.exists)
        XCTAssertTrue(notificationsToggle.isEnabled)
        notificationsToggle.switches.firstMatch.tap()
        XCTAssertTrue(notificationsToggle.value as? String == "1")
        
        let doNotDisturbToggle = app.switches["DoNotDisturbIdentifier"]
        XCTAssertTrue(doNotDisturbToggle.exists)
        XCTAssertTrue(doNotDisturbToggle.isEnabled)
        doNotDisturbToggle.switches.firstMatch.tap()
        XCTAssertTrue(doNotDisturbToggle.value as? String == "1")
        
        let scheduleButton = app.buttons["Remember random words"]
        XCTAssertTrue(scheduleButton.exists)
        XCTAssertTrue(scheduleButton.isEnabled)
        scheduleButton.tap()
       
    }
}
