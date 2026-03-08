import XCTest

final class LockUnlockUITests: KeeForgeUITestCase {

    func testLockButtonReturnsToUnlockScreen() {
        unlockSuccessfully()

        let lockButton = app.buttons["lock.button"]
        XCTAssertTrue(lockButton.waitForExistence(timeout: 5), "Lock button not found")
        lockButton.tap()

        // Should return to unlock screen
        let passwordField = app.secureTextFields["unlock.password.field"]
        XCTAssertTrue(passwordField.waitForExistence(timeout: 10), "Password field did not appear after locking")
    }

    func testMultipleWrongPasswordsShowErrors() {
        // Test exponential backoff behavior (v1.4.0 feature)
        // After 3+ wrong attempts, the app enforces a delay
        for attempt in 1...4 {
            unlock(password: "wrong-password-\(attempt)")

            let errorLabel = app.staticTexts["unlock.error.label"]
            XCTAssertTrue(errorLabel.waitForExistence(timeout: 10), "Error should appear on attempt \(attempt)")

            // Brief pause to let any lockout timer start
            sleep(1)
        }

        // After multiple failures, should still be on unlock screen
        let passwordField = app.secureTextFields["unlock.password.field"]
        XCTAssertTrue(passwordField.exists, "Password field should still be visible after failed attempts")
    }

    func testCanUnlockAfterFailedAttempts() {
        // Fail once, then succeed
        unlock(password: "wrong-password")
        let errorLabel = app.staticTexts["unlock.error.label"]
        XCTAssertTrue(errorLabel.waitForExistence(timeout: 10), "Error should appear for wrong password")

        // Clear the field and enter correct password
        let passwordField = app.secureTextFields["unlock.password.field"]
        XCTAssertTrue(passwordField.waitForExistence(timeout: 5))
        passwordField.tap()
        // Triple-tap to select all, then type over it
        passwordField.tap()
        passwordField.doubleTap()
        sleep(1)
        passwordField.typeText("testpassword123")
        app.buttons["unlock.button"].tap()

        sleep(3)
        XCTAssertTrue(app.buttons["lock.button"].waitForExistence(timeout: 20), "Should unlock after failed attempt")
    }
}
