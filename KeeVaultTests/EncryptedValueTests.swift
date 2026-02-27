import CryptoKit
import XCTest
@testable import KeeVault

final class EncryptedValueTests: XCTestCase {
    private let testKey = SymmetricKey(size: .bits256)

    func testRoundTripEncryptDecrypt() throws {
        let original = "hunter2"
        let encrypted = try EncryptedValue.encrypt(original, using: testKey)
        let decrypted = try encrypted.decrypt(using: testKey)
        XCTAssertEqual(decrypted, original)
    }

    func testEmptyStringProducesEmpty() throws {
        let encrypted = try EncryptedValue.encrypt("", using: testKey)
        XCTAssertEqual(encrypted.hasValue, false)
        XCTAssertEqual(encrypted.sealedData, Data())
    }

    func testEmptyDecryptsToEmptyString() throws {
        let decrypted = try EncryptedValue.empty.decrypt(using: testKey)
        XCTAssertEqual(decrypted, "")
    }

    func testHasValueTrueForNonEmpty() throws {
        let encrypted = try EncryptedValue.encrypt("secret", using: testKey)
        XCTAssertTrue(encrypted.hasValue)
    }

    func testHasValueFalseForEmpty() {
        XCTAssertFalse(EncryptedValue.empty.hasValue)
    }

    func testDecryptWithWrongKeyThrows() throws {
        let encrypted = try EncryptedValue.encrypt("secret", using: testKey)
        let wrongKey = SymmetricKey(size: .bits256)
        XCTAssertThrowsError(try encrypted.decrypt(using: wrongKey))
    }

    func testUnicodeRoundTrip() throws {
        let original = "pässwörd!@#¥ 🔑 日本語"
        let encrypted = try EncryptedValue.encrypt(original, using: testKey)
        let decrypted = try encrypted.decrypt(using: testKey)
        XCTAssertEqual(decrypted, original)
    }

    func testEachEncryptProducesDifferentCiphertext() throws {
        let a = try EncryptedValue.encrypt("same", using: testKey)
        let b = try EncryptedValue.encrypt("same", using: testKey)
        // Different random nonces mean different sealed data
        XCTAssertNotEqual(a.sealedData, b.sealedData)
        // But both decrypt to the same value
        XCTAssertEqual(try a.decrypt(using: testKey), try b.decrypt(using: testKey))
    }
}
