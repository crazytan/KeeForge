import XCTest
@testable import KeeForge
import CryptoKit

final class VerifyKeyfileTests: XCTestCase {
    func testDemoKeyfileUnlock() throws {
        let bundle = Bundle(for: VerifyKeyfileTests.self)
        let dbURL = try XCTUnwrap(bundle.url(forResource: "demo-keyfile", withExtension: "kdbx"))
        let keyURL = try XCTUnwrap(bundle.url(forResource: "demo-keyfile", withExtension: "key"))
        let dbData = try Data(contentsOf: dbURL)
        let keyData = try Data(contentsOf: keyURL)
        let sessionKey = SymmetricKey(size: .bits256)

        // Try with nil password (key file only)
        do {
            let root = try KDBXParser.parse(data: dbData, password: nil, keyFileData: keyData, sessionKey: sessionKey)
            print("nil password: Root group: \(root.name), entries: \(root.allEntries.count)")
            return
        } catch {
            print("nil password failed: \(error)")
        }

        // Try common passwords
        for pw in ["password", "demo", "test", "keyfile", "demo-keyfile", "123456"] {
            do {
                let root = try KDBXParser.parse(data: dbData, password: pw, keyFileData: keyData, sessionKey: sessionKey)
                print("password '\(pw)' WORKED: Root group: \(root.name), entries: \(root.allEntries.count)")
                return
            } catch {
                print("password '\(pw)' failed: \(error)")
            }
        }

        XCTFail("Could not unlock demo-keyfile.kdbx with any password combination")
    }
}
