import XCTest

final class SortOrderChangeUITests: KeeForgeUITestCase {

    func testSortByModifiedDateViaMenu() {
        unlockSuccessfully()

        let sortMenu = app.buttons["sort.menu"]
        XCTAssertTrue(sortMenu.waitForExistence(timeout: 5), "Sort menu not found")
        sortMenu.tap()

        // Select "Modified Date"
        let modifiedOption = app.buttons["Modified Date"]
        if modifiedOption.waitForExistence(timeout: 3) {
            modifiedOption.tap()
        }

        // Verify the list still displays entries (sort didn't crash)
        sleep(1)
        let hasContent = app.buttons.matching(identifier: "entry.navlink").firstMatch.waitForExistence(timeout: 5)
            || app.buttons.matching(identifier: "group.navlink").firstMatch.waitForExistence(timeout: 5)
        XCTAssertTrue(hasContent, "List should still show entries/groups after changing sort order")
    }

    func testSortByCreatedDateViaMenu() {
        unlockSuccessfully()

        let sortMenu = app.buttons["sort.menu"]
        XCTAssertTrue(sortMenu.waitForExistence(timeout: 5), "Sort menu not found")
        sortMenu.tap()

        let createdOption = app.buttons["Created Date"]
        if createdOption.waitForExistence(timeout: 3) {
            createdOption.tap()
        }

        sleep(1)
        let hasContent = app.buttons.matching(identifier: "entry.navlink").firstMatch.waitForExistence(timeout: 5)
            || app.buttons.matching(identifier: "group.navlink").firstMatch.waitForExistence(timeout: 5)
        XCTAssertTrue(hasContent, "List should still show entries/groups after sorting by created date")
    }
}
