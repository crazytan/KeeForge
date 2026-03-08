import XCTest

final class SettingsUITests: KeeForgeUITestCase {

    private func openSettings() {
        let settingsButton = app.buttons["settings.button"]
        XCTAssertTrue(settingsButton.waitForExistence(timeout: 5), "Settings button not found")
        settingsButton.tap()
    }

    func testSettingsPageLoads() {
        unlockSuccessfully()
        openSettings()

        XCTAssertTrue(app.navigationBars["Settings"].waitForExistence(timeout: 5), "Settings nav bar not found")
        XCTAssertTrue(app.staticTexts["About"].waitForExistence(timeout: 3), "About section not found")
    }

    func testSortDirectionToggle() {
        unlockSuccessfully()
        openSettings()

        let settingsForm = app.collectionViews.firstMatch.exists ? app.collectionViews.firstMatch : app.tables.firstMatch
        settingsForm.swipeUp()

        let sortDirection = app.staticTexts["Sort Direction"]
        XCTAssertTrue(sortDirection.waitForExistence(timeout: 5), "Sort Direction picker not found")

        // Verify Ascending/Descending options exist in the picker
        let ascending = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Ascending'")).firstMatch
        let descending = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Descending'")).firstMatch
        let hasOptions = ascending.exists || descending.exists
        XCTAssertTrue(hasOptions, "Sort Direction should have Ascending/Descending options")
    }

    func testFeedbackButtonExists() {
        unlockSuccessfully()
        openSettings()

        let settingsForm = app.collectionViews.firstMatch.exists ? app.collectionViews.firstMatch : app.tables.firstMatch
        for _ in 0..<3 {
            settingsForm.swipeUp()
        }

        let feedbackLink = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Send Feedback'")).firstMatch
        XCTAssertTrue(feedbackLink.waitForExistence(timeout: 3), "Send Feedback link not found in About section")
    }

    func testTipJarSectionExists() {
        unlockSuccessfully()
        openSettings()

        let settingsForm = app.collectionViews.firstMatch.exists ? app.collectionViews.firstMatch : app.tables.firstMatch
        for _ in 0..<3 {
            settingsForm.swipeUp()
        }

        let tipJarHeader = app.staticTexts["Tip Jar"]
        XCTAssertTrue(tipJarHeader.waitForExistence(timeout: 5), "Tip Jar section header not found")
    }
}
