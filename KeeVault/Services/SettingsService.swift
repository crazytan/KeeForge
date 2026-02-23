import Foundation

enum SettingsService {
    // MARK: - Keys

    private enum Key {
        static let autoLockTimeout = "KeeVault.autoLockTimeout"
        static let clipboardTimeout = "KeeVault.clipboardTimeout"
    }

    // MARK: - Auto-Lock Timeout

    enum AutoLockTimeout: String, CaseIterable, Sendable {
        case immediately = "Immediately"
        case thirtySeconds = "30 Seconds"
        case oneMinute = "1 Minute"
        case fiveMinutes = "5 Minutes"
        case never = "Never"

        var seconds: TimeInterval? {
            switch self {
            case .immediately: 0
            case .thirtySeconds: 30
            case .oneMinute: 60
            case .fiveMinutes: 300
            case .never: nil
            }
        }
    }

    // MARK: - Clipboard Timeout

    enum ClipboardTimeout: String, CaseIterable, Sendable {
        case tenSeconds = "10 Seconds"
        case thirtySeconds = "30 Seconds"
        case oneMinute = "1 Minute"
        case never = "Never"

        var seconds: TimeInterval? {
            switch self {
            case .tenSeconds: 10
            case .thirtySeconds: 30
            case .oneMinute: 60
            case .never: nil
            }
        }
    }

    // MARK: - Accessors

    static var autoLockTimeout: AutoLockTimeout {
        get {
            guard let raw = UserDefaults.standard.string(forKey: Key.autoLockTimeout) else {
                return .immediately
            }
            return AutoLockTimeout(rawValue: raw) ?? .immediately
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: Key.autoLockTimeout)
        }
    }

    static var clipboardTimeout: ClipboardTimeout {
        get {
            guard let raw = UserDefaults.standard.string(forKey: Key.clipboardTimeout) else {
                return .thirtySeconds
            }
            return ClipboardTimeout(rawValue: raw) ?? .thirtySeconds
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: Key.clipboardTimeout)
        }
    }
}
