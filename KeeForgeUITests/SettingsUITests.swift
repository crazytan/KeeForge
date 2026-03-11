import XCTest

@MainActor
final class SettingsUITests: KeeForgeUITestCase {

    private func openSettings() {
        let settingsButton = app.buttons["settings.button"]
        XCTAssertTrue(settingsButton.waitForExistence(timeout: 10), "Settings button not found")
        settingsButton.tap()
    }

    private func settingsForm() -> XCUIElement {
        let candidates: [XCUIElement] = [
            app.collectionViews.firstMatch,
            app.tables.firstMatch,
            app.scrollViews.firstMatch,
        ]

        for candidate in candidates where candidate.exists {
            return candidate
        }

        return app.collectionViews.firstMatch
    }

    private func revealInSettings(_ element: XCUIElement, maxSwipes: Int = 8) {
        XCTAssertTrue(
            revealElement(element, in: settingsForm(), direction: .up, maxSwipes: maxSwipes),
            "Could not reveal '\(element.label)' in Settings"
        )
    }

    func testSettingsPageContent() {
        unlockSuccessfully()
        openSettings()

        XCTAssertTrue(app.navigationBars["Settings"].waitForExistence(timeout: 10), "Settings nav bar not found")

        let aboutHeader = app.staticTexts["About"]
        revealInSettings(aboutHeader, maxSwipes: 6)

        let sortDirection = app.staticTexts["Sort Direction"]
        revealInSettings(sortDirection, maxSwipes: 4)

        let feedbackLink = app.descendants(matching: .any).matching(NSPredicate(format: "label == 'Send Feedback'")).firstMatch
        revealInSettings(feedbackLink, maxSwipes: 2)

        let tipJarHeader = app.staticTexts["Tip Jar"]
        revealInSettings(tipJarHeader, maxSwipes: 4)
    }

    func testTipJarContent() {
        unlockSuccessfully()
        openSettings()

        let tipJarHeader = app.staticTexts["Tip Jar"]
        revealInSettings(tipJarHeader, maxSwipes: 8)

        let smallTip = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Small' OR label CONTAINS[c] '$1.99' OR label CONTAINS[c] 'tip'")).firstMatch
        let notAvailable = app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] 'not available' OR label CONTAINS[c] 'unavailable'")).firstMatch
        let hasTipContent = revealElement(smallTip, in: settingsForm(), direction: .up, maxSwipes: 2)
            || revealElement(notAvailable, in: settingsForm(), direction: .up, maxSwipes: 2)
        XCTAssertTrue(hasTipContent, "Tip Jar should show tip buttons or 'not available' fallback")

        let description = app.staticTexts.matching(NSPredicate(
            format: "label CONTAINS[c] 'support' OR label CONTAINS[c] 'tip' OR label CONTAINS[c] 'free'"
        )).firstMatch
        revealInSettings(description, maxSwipes: 2)
    }
}
