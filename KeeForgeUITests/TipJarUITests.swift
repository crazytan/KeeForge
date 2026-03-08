import XCTest

final class TipJarUITests: KeeForgeUITestCase {

    private func openSettings() {
        let settingsButton = app.buttons["settings.button"]
        XCTAssertTrue(settingsButton.waitForExistence(timeout: 5), "Settings button not found")
        settingsButton.tap()
    }

    private func scrollToTipJar() {
        let settingsForm = app.collectionViews.firstMatch.exists
            ? app.collectionViews.firstMatch
            : app.tables.firstMatch
        for _ in 0..<4 {
            settingsForm.swipeUp()
        }
    }

    func testTipJarShowsTipButtons() {
        unlockSuccessfully()
        openSettings()
        scrollToTipJar()

        // Tip Jar section should exist
        let tipJarHeader = app.staticTexts["Tip Jar"]
        XCTAssertTrue(tipJarHeader.waitForExistence(timeout: 5), "Tip Jar header not found")

        // Should show tip tier buttons or "not available" fallback
        // On simulator without StoreKit config, shows fallback text
        let smallTip = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Small' OR label CONTAINS[c] '$1.99' OR label CONTAINS[c] 'tip'")).firstMatch
        let notAvailable = app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] 'not available' OR label CONTAINS[c] 'unavailable'")).firstMatch

        let hasTipContent = smallTip.exists || notAvailable.exists
        XCTAssertTrue(hasTipContent, "Tip Jar should show tip buttons or 'not available' fallback")
    }

    func testTipJarHasDescription() {
        unlockSuccessfully()
        openSettings()
        scrollToTipJar()

        // Should show some descriptive text about tips
        let description = app.staticTexts.matching(NSPredicate(
            format: "label CONTAINS[c] 'support' OR label CONTAINS[c] 'tip' OR label CONTAINS[c] 'free'"
        )).firstMatch

        XCTAssertTrue(description.waitForExistence(timeout: 3), "Tip Jar should have a description")
    }
}
