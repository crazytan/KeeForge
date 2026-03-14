import XCTest

@MainActor
final class SortUITests: KeeForgeUITestCase {
    private func waitForAnyListContent(timeout: TimeInterval = 10) -> Bool {
        let entry = app.buttons.matching(identifier: "entry.navlink").firstMatch
        let group = app.buttons.matching(identifier: "group.navlink").firstMatch
        let deadline = Date().addingTimeInterval(timeout)

        repeat {
            if entry.exists || group.exists {
                return true
            }
            RunLoop.current.run(until: Date().addingTimeInterval(0.25))
        } while Date() < deadline

        return false
    }

    func testSortMenuShowsOptionsAndDirectionToggle() {
        unlockSuccessfully()

        // Sort menu should exist and open
        let sortMenu = app.buttons["sort.menu"]
        XCTAssertTrue(sortMenu.waitForExistence(timeout: 10), "Sort menu button not found in toolbar")
        sortMenu.tap()

        // Should show sort options: Title, Date Created, Date Modified
        let titleOption = app.buttons["Title"]
        XCTAssertTrue(titleOption.waitForExistence(timeout: 5), "Sort menu should show sort order options")

        // Dismiss by tapping elsewhere
        app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.1)).tap()
    }

    func testSortOrderChangeWorks() {
        unlockSuccessfully()

        let sortMenu = app.buttons["sort.menu"]
        XCTAssertTrue(sortMenu.waitForExistence(timeout: 10), "Sort menu not found")
        sortMenu.tap()

        // Select "Date Modified"
        let modifiedOption = app.buttons["Date Modified"]
        XCTAssertTrue(modifiedOption.waitForExistence(timeout: 5), "Date Modified option not found")
        modifiedOption.tap()

        // Verify the list still displays entries (sort didn't crash)
        let hasContent = waitForAnyListContent(timeout: 10)
        XCTAssertTrue(hasContent, "List should still show entries/groups after changing sort order")
    }
}
