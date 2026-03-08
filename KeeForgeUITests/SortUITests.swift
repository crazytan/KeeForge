import XCTest

final class SortUITests: KeeForgeUITestCase {

    func testSortMenuExists() {
        unlockSuccessfully()

        let sortMenu = app.buttons["sort.menu"]
        XCTAssertTrue(sortMenu.waitForExistence(timeout: 5), "Sort menu button not found in toolbar")
    }
}
