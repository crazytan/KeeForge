import XCTest

final class KeyFileUITests: KeeForgeUITestCase {

    private func findKeyFileSelect() -> XCUIElement? {
        // Try direct identifier first
        let direct = app.buttons["unlock.keyfile.select"]
        if direct.waitForExistence(timeout: 3) { return direct }

        // Scroll and retry
        app.swipeUp()
        if direct.waitForExistence(timeout: 3) { return direct }

        // Try matching by label "Select"
        let byLabel = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Select'")).firstMatch
        if byLabel.waitForExistence(timeout: 3) { return byLabel }

        return nil
    }

    func testKeyFileSelectButtonExists() {
        let passwordField = app.secureTextFields["unlock.password.field"]
        XCTAssertTrue(passwordField.waitForExistence(timeout: 10), "Password field not found")

        // Key file row should be visible on unlock screen
        let keyFileRow = app.descendants(matching: .any).matching(identifier: "unlock.keyfile.row").firstMatch
        if !keyFileRow.waitForExistence(timeout: 5) {
            app.swipeUp()
        }

        let selectButton = findKeyFileSelect()
        XCTAssertNotNil(selectButton, "Key file Select button not found")
    }

    func testKeyFileSelectOpensDocumentPicker() {
        let passwordField = app.secureTextFields["unlock.password.field"]
        XCTAssertTrue(passwordField.waitForExistence(timeout: 10), "Password field not found")

        guard let selectButton = findKeyFileSelect() else {
            XCTFail("Key file Select button not found")
            return
        }
        selectButton.tap()

        // Document picker should appear (presented as a sheet/modal)
        let documentPicker = app.navigationBars.matching(NSPredicate(format: "identifier CONTAINS[c] 'doc' OR label CONTAINS[c] 'Browse' OR label CONTAINS[c] 'Recents'")).firstMatch
        let pickerAppeared = documentPicker.waitForExistence(timeout: 5)

        // On simulator, the document picker may present differently — also check for any modal
        if !pickerAppeared {
            // Check if any new sheet/navigation appeared after tapping
            let browseButton = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'Browse'")).firstMatch
            let cancelButton = app.buttons["Cancel"]
            let hasModal = browseButton.waitForExistence(timeout: 3) || cancelButton.exists
            XCTAssertTrue(hasModal, "Document picker did not appear after tapping Select key file")
        }
    }
}
