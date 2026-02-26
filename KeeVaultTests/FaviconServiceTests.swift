import XCTest
@testable import KeeVault

final class FaviconServiceTests: XCTestCase {
    private let showWebsiteIconsKey = "KeeVault.showWebsiteIcons"

    private var sharedDefaults: UserDefaults {
        UserDefaults(suiteName: SharedVaultStore.appGroupID) ?? .standard
    }

    override func tearDown() {
        sharedDefaults.removeObject(forKey: showWebsiteIconsKey)
        FaviconService.clearCache()
        super.tearDown()
    }

    // MARK: - Domain Extraction

    func testExtractDomainFromHTTPS() {
        XCTAssertEqual(FaviconService.extractDomain(from: "https://www.google.com/search?q=test"), "www.google.com")
    }

    func testExtractDomainFromHTTP() {
        XCTAssertEqual(FaviconService.extractDomain(from: "http://example.org/path"), "example.org")
    }

    func testExtractDomainWithoutScheme() {
        XCTAssertEqual(FaviconService.extractDomain(from: "github.com/user/repo"), "github.com")
    }

    func testExtractDomainLowercased() {
        XCTAssertEqual(FaviconService.extractDomain(from: "https://GitHub.COM"), "github.com")
    }

    func testExtractDomainFromEmptyString() {
        XCTAssertNil(FaviconService.extractDomain(from: ""))
    }

    func testExtractDomainFromWhitespace() {
        XCTAssertNil(FaviconService.extractDomain(from: "   "))
    }

    func testExtractDomainRejectsLocalhost() {
        XCTAssertNil(FaviconService.extractDomain(from: "http://localhost:8080"))
    }

    func testExtractDomainRejectsIPAddress() {
        XCTAssertNil(FaviconService.extractDomain(from: "http://192.168.1.1"))
    }

    func testExtractDomainWithPort() {
        XCTAssertEqual(FaviconService.extractDomain(from: "https://example.com:443/path"), "example.com")
    }

    func testExtractDomainWithSubdomain() {
        XCTAssertEqual(FaviconService.extractDomain(from: "https://mail.google.com"), "mail.google.com")
    }

    // MARK: - Cache Key

    func testCacheKeyIsSHA256Hex() {
        let key = FaviconService.cacheKey(for: "example.com")
        // SHA256 hex string is 64 characters
        XCTAssertEqual(key.count, 64)
        // All hex characters
        XCTAssertTrue(key.allSatisfy { $0.isHexDigit })
    }

    func testCacheKeyDeterministic() {
        let key1 = FaviconService.cacheKey(for: "google.com")
        let key2 = FaviconService.cacheKey(for: "google.com")
        XCTAssertEqual(key1, key2)
    }

    func testCacheKeyDifferentDomains() {
        let key1 = FaviconService.cacheKey(for: "google.com")
        let key2 = FaviconService.cacheKey(for: "github.com")
        XCTAssertNotEqual(key1, key2)
    }

    // MARK: - Disk Cache

    func testCachedImageReturnsNilForMissing() {
        XCTAssertNil(FaviconService.cachedImage(for: "nonexistent.com"))
    }

    func testClearCacheRemovesDirectory() {
        // Create cache directory with a file
        let fm = FileManager.default
        let dir = FaviconService.cacheDirectory
        try? fm.createDirectory(at: dir, withIntermediateDirectories: true)
        let testFile = dir.appendingPathComponent("test")
        try? Data("test".utf8).write(to: testFile)
        XCTAssertTrue(fm.fileExists(atPath: testFile.path))

        FaviconService.clearCache()
        XCTAssertFalse(fm.fileExists(atPath: dir.path))
    }

    func testCacheDirectoryInAppGroup() {
        let dir = FaviconService.cacheDirectory
        XCTAssertTrue(dir.path.contains("favicons"))
    }

    // MARK: - Settings

    func testShowWebsiteIconsDefaultsToFalse() {
        sharedDefaults.removeObject(forKey: showWebsiteIconsKey)
        XCTAssertFalse(SettingsService.showWebsiteIcons)
    }

    func testShowWebsiteIconsPersists() {
        SettingsService.showWebsiteIcons = true
        XCTAssertTrue(SettingsService.showWebsiteIcons)

        SettingsService.showWebsiteIcons = false
        XCTAssertFalse(SettingsService.showWebsiteIcons)
    }
}
