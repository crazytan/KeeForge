import XCTest
@testable import KeeForge

@MainActor
final class ReviewPromptServiceTests: XCTestCase {
    private let suiteName = "ReviewPromptServiceTests"
    private var testDefaults: UserDefaults!

    override func setUp() {
        super.setUp()
        testDefaults = UserDefaults(suiteName: suiteName)!
        ReviewPromptService.defaults = testDefaults
        ReviewPromptService.resetForTesting()
        ReviewPromptService.minimumActions = 10
    }

    override func tearDown() {
        ReviewPromptService.resetForTesting()
        ReviewPromptService.defaults = .standard
        UserDefaults.standard.removePersistentDomain(forName: suiteName)
        super.tearDown()
    }

    // MARK: - Action counting

    func testActionCountStartsAtZero() {
        XCTAssertEqual(ReviewPromptService.actionCount, 0)
    }

    func testRecordMeaningfulActionIncrementsCount() {
        ReviewPromptService.recordMeaningfulAction()
        XCTAssertEqual(ReviewPromptService.actionCount, 1)

        ReviewPromptService.recordMeaningfulAction()
        XCTAssertEqual(ReviewPromptService.actionCount, 2)
    }

    // MARK: - shouldPrompt logic

    func testShouldNotPromptBelowThreshold() {
        ReviewPromptService.actionCount = 9
        XCTAssertFalse(ReviewPromptService.shouldPrompt())
    }

    func testShouldPromptAtThreshold() {
        ReviewPromptService.actionCount = 10
        XCTAssertTrue(ReviewPromptService.shouldPrompt())
    }

    func testShouldPromptAboveThreshold() {
        ReviewPromptService.actionCount = 25
        XCTAssertTrue(ReviewPromptService.shouldPrompt())
    }

    func testShouldNotPromptIfAlreadyPrompted() {
        ReviewPromptService.actionCount = 20
        ReviewPromptService.hasPrompted = true
        XCTAssertFalse(ReviewPromptService.shouldPrompt())
    }

    func testOnceEverSemantics() {
        // First time: should prompt
        ReviewPromptService.actionCount = 10
        XCTAssertTrue(ReviewPromptService.shouldPrompt())

        // Mark as prompted
        ReviewPromptService.hasPrompted = true

        // Never again, even with more actions
        ReviewPromptService.actionCount = 100
        XCTAssertFalse(ReviewPromptService.shouldPrompt())
    }

    // MARK: - Custom threshold

    func testCustomMinimumActionsThreshold() {
        ReviewPromptService.minimumActions = 5
        ReviewPromptService.actionCount = 4
        XCTAssertFalse(ReviewPromptService.shouldPrompt())

        ReviewPromptService.actionCount = 5
        XCTAssertTrue(ReviewPromptService.shouldPrompt())
    }

    // MARK: - hasPrompted

    func testHasPromptedStartsFalse() {
        XCTAssertFalse(ReviewPromptService.hasPrompted)
    }

    // MARK: - resetForTesting

    func testResetClearsAllState() {
        ReviewPromptService.actionCount = 42
        ReviewPromptService.hasPrompted = true

        ReviewPromptService.resetForTesting()

        XCTAssertEqual(ReviewPromptService.actionCount, 0)
        XCTAssertFalse(ReviewPromptService.hasPrompted)
    }
}
