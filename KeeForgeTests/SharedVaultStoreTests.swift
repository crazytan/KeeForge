import XCTest
@testable import KeeForge

final class SharedVaultStoreTests: XCTestCase {
    override func setUp() {
        super.setUp()
        SharedVaultStore.clearBookmark()
    }

    override func tearDown() {
        SharedVaultStore.clearBookmark()
        super.tearDown()
    }

    func testSharedVaultStoreSaveLoadAndClearBookmark() throws {
        let url = try makeTemporaryFileURL(name: "shared-store-test.kdbx")

        try SharedVaultStore.saveBookmark(for: url)
        let loaded = try XCTUnwrap(SharedVaultStore.loadBookmarkedURL())
        XCTAssertEqual(loaded.path, url.path)

        SharedVaultStore.clearBookmark()
        XCTAssertNil(SharedVaultStore.loadBookmarkedURL())
    }

    func testDocumentPickerServiceDelegatesSaveLoadAndClear() throws {
        let url = try makeTemporaryFileURL(name: "doc-picker-test.kdbx")

        try DocumentPickerService.saveBookmark(for: url)
        let loaded = try XCTUnwrap(DocumentPickerService.loadBookmarkedURL())
        XCTAssertEqual(loaded.path, url.path)

        DocumentPickerService.clearBookmark()
        XCTAssertNil(DocumentPickerService.loadBookmarkedURL())
    }

    func testCacheDatabaseCopyWritesLoadableSharedCopy() throws {
        let sourceData = Data("cached database".utf8)
        let url = try makeTemporaryFileURL(name: "cache-test.kdbx", contents: sourceData)

        try SharedVaultStore.cacheDatabaseCopy(sourceData, sourceURL: url)

        let cachedURL = try XCTUnwrap(SharedVaultStore.loadCachedDatabaseURL())
        XCTAssertEqual(cachedURL.lastPathComponent, url.lastPathComponent)
        XCTAssertEqual(try Data(contentsOf: cachedURL), sourceData)
    }

    func testLoadDatabaseKeychainPathUsesStoredFilenameWithoutCache() throws {
        let url = try makeTemporaryFileURL(name: "keychain-path-test.kdbx")

        try SharedVaultStore.saveBookmark(for: url)

        let keychainPath = try XCTUnwrap(SharedVaultStore.loadDatabaseKeychainPath())
        XCTAssertEqual((keychainPath as NSString).lastPathComponent, url.lastPathComponent)
    }

    func testClearBookmarkRemovesCachedDatabaseCopy() throws {
        let sourceData = Data("cached database".utf8)
        let url = try makeTemporaryFileURL(name: "clear-cache-test.kdbx", contents: sourceData)

        try SharedVaultStore.saveBookmark(for: url)
        try SharedVaultStore.cacheDatabaseCopy(sourceData, sourceURL: url)
        XCTAssertNotNil(SharedVaultStore.loadCachedDatabaseURL())

        SharedVaultStore.clearBookmark()

        XCTAssertNil(SharedVaultStore.loadBookmarkedURL())
        XCTAssertNil(SharedVaultStore.loadCachedDatabaseURL())
        XCTAssertFalse(FileManager.default.fileExists(atPath: SharedVaultStore.databaseCacheDirectory.path))
    }

    private func makeTemporaryFileURL(name: String, contents: Data = Data("fixture".utf8)) throws -> URL {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathComponent(name)
        try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
        try contents.write(to: url)
        return url
    }
}
