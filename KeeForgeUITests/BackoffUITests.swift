import XCTest

@MainActor
final class BackoffUITests: KeeForgeUITestCase {

    func testBackoffMessageAppearsAfterRepeatedFailures() {
        // First 3 attempts are "free" (no delay), 4th triggers backoff
        // Each Argon2 unlock takes ~4s, so keep attempts minimal
        for attempt in 1...4 {
            unlock(password: "wrong-\(attempt)")

            let errorLabel = app.staticTexts["unlock.error.label"]
            XCTAssertTrue(
                errorLabel.waitForExistence(timeout: 15),
                "Error label should appear on attempt \(attempt)"
            )
        }

        // After 4 wrong attempts, the 5th should show backoff
        unlock(password: "wrong-5")
        let errorLabel = app.staticTexts["unlock.error.label"]
        XCTAssertTrue(errorLabel.waitForExistence(timeout: 15))

        let errorText = errorLabel.label
        let hasBackoff = errorText.contains("Too many") || errorText.contains("Try again")
        XCTAssertTrue(hasBackoff, "Error should indicate lockout after 4+ failures: got '\(errorText)'")
    }
}
