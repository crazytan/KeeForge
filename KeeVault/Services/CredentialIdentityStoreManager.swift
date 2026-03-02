@preconcurrency import AuthenticationServices
import OSLog

enum CredentialIdentityStoreManager: Sendable {
    private static let logger = Logger(subsystem: "KeeVault", category: "CredentialIdentityStore")

    static func populate(with entries: [KPEntry]) {
        Task {
            let store = ASCredentialIdentityStore.shared
            let state = await store.state()
            guard state.isEnabled else {
                logger.info("Identity store is not enabled; skipping populate")
                return
            }

            let identities = entries.compactMap(passwordIdentity(for:))
            guard !identities.isEmpty else {
                logger.info("No credential identities to populate")
                return
            }

            do {
                try await store.replaceCredentialIdentities(identities)
                logger.info("Populated identity store with \(identities.count) identities")
            } catch {
                logger.error("Failed to replace credential identities: \(error.localizedDescription)")
            }
        }
    }

    static func clearStore() {
        Task {
            let store = ASCredentialIdentityStore.shared
            let state = await store.state()
            guard state.isEnabled else { return }

            do {
                try await store.removeAllCredentialIdentities()
                logger.info("Cleared all credential identities")
            } catch {
                logger.error("Failed to clear credential identities: \(error.localizedDescription)")
            }
        }
    }

    static func removeIdentities(for entries: [KPEntry]) {
        Task {
            let store = ASCredentialIdentityStore.shared
            let state = await store.state()
            guard state.isEnabled else { return }

            let identities = entries.compactMap(passwordIdentity(for:))
            guard !identities.isEmpty else { return }

            do {
                try await store.removeCredentialIdentities(identities)
            } catch {
                logger.error("Failed to remove credential identities: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Internal (visible to tests via @testable import)

    static func passwordIdentity(for entry: KPEntry) -> ASPasswordCredentialIdentity? {
        let username = entry.username.isEmpty ? entry.title : entry.username
        guard !username.isEmpty else { return nil }
        guard entry.hasPassword else { return nil }

        let allURLs = [entry.url] + entry.additionalURLs
        let domain = allURLs.lazy.compactMap(domainFromURLString).first
        guard let domain else { return nil }

        let serviceIdentifier = ASCredentialServiceIdentifier(identifier: domain, type: .domain)
        return ASPasswordCredentialIdentity(
            serviceIdentifier: serviceIdentifier,
            user: username,
            recordIdentifier: entry.id.uuidString
        )
    }

    static func domainFromURLString(_ urlString: String) -> String? {
        guard !urlString.isEmpty else { return nil }

        if let host = URL(string: urlString)?.host {
            return host
        }

        return URL(string: "https://\(urlString)")?.host
    }
}
