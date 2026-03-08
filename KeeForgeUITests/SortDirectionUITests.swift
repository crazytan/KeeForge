import XCTest

final class SortDirectionUITests: KeeForgeUITestCase {

    func testSortMenuExists() {
        unlockSuccessfully()

        let sortMenu = app.buttons["sort.menu"]
        XCTAssertTrue(sortMenu.waitForExistence(timeout: 5), "Sort menu button not found in toolbar")
    }

    func testSortMenuOpensAndShowsOptions() {
        unlockSuccessfully()

        let sortMenu = app.buttons["sort.menu"]
        XCTAssertTrue(sortMenu.waitForExistence(timeout: 5), "Sort menu not found")
        sortMenu.tap()

        // Should show sort options: Title, Created Date, Modified Date
        let titleOption = app.buttons["Title"]
        let hasOptions = titleOption.waitForExistence(timeout: 3)
        XCTAssertTrue(hasOptions, "Sort menu should show sort order options")

        // Dismiss by tapping elsewhere
        app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.1)).tap()
    }
}
