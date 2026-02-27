import Foundation
import CryptoKit

/// Holds a secret re-encrypted with the per-session AES-GCM key.
/// The original plaintext is only recoverable by calling `decrypt(using:)`.
struct EncryptedValue: Sendable, Hashable {
    /// AES-GCM sealed box: nonce (12) + ciphertext + tag (16), or empty for `.empty`.
    let sealedData: Data
    /// Whether the original plaintext was non-empty.
    let hasValue: Bool

    /// Sentinel for fields where the original plaintext was empty.
    static let empty = EncryptedValue(sealedData: Data(), hasValue: false)

    /// Encrypt a plaintext string with the given session key.
    /// Returns `.empty` if the plaintext is empty.
    static func encrypt(_ plaintext: String, using key: SymmetricKey) throws -> EncryptedValue {
        guard !plaintext.isEmpty else { return .empty }
        let data = Data(plaintext.utf8)
        let sealed = try AES.GCM.seal(data, using: key)
        guard let combined = sealed.combined else {
            throw CryptoKitError.underlyingCoreCryptoError(error: -1)
        }
        return EncryptedValue(sealedData: combined, hasValue: true)
    }

    /// Decrypt to a temporary String. Returns "" if this is `.empty`.
    func decrypt(using key: SymmetricKey) throws -> String {
        guard hasValue else { return "" }
        let box = try AES.GCM.SealedBox(combined: sealedData)
        let plaintext = try AES.GCM.open(box, using: key)
        return String(data: plaintext, encoding: .utf8) ?? ""
    }
}
