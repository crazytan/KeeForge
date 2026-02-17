# KeeVault

Free, native iOS KeePassXC-compatible password manager. Version 1 is read-only.

## What It Is

- Opens and decrypts `.kdbx` (KDBX 4.x) databases
- Browses groups and entries
- Supports TOTP display/copy
- AutoFill extension for system-wide password autofill
- Face ID / Touch ID unlock
- Targets iOS 17+ with SwiftUI and Swift 6

## Build

1. Open `KeeVault.xcodeproj` in Xcode 16+
2. Select an iOS 17+ simulator or device
3. Build and run

## Usage

1. Pick a `.kdbx` file from Files/iCloud
2. Enter master password to unlock
3. Browse groups and entries
4. Copy fields (username/password/TOTP), open URLs, and search entries

## AutoFill Extension

KeeVault includes an AutoFill Credential Provider extension for system-wide password autofill. The extension uses `CredentialMatcher` — a shared matching engine in `KeeVault/Services/` — to find relevant credentials by comparing service identifiers (domains/URLs) against entry URLs and titles. Matching supports subdomains, URL-type identifiers, and case-insensitive comparison.

## Test Status

| Suite | Count | Status |
|-------|-------|--------|
| Unit tests | 43 | ✅ |
| UI tests | 5 | ✅ |

Includes 18 dedicated `CredentialMatcher` tests covering host extraction, search term generation, and entry matching (exact domain, subdomain, URL-type, case insensitivity, edge cases).

## Project Structure

```
KeeVault/
├── App/              # App entry point
├── Models/           # KDBX parser, crypto, data models
├── Services/         # Keychain, Biometric, Clipboard, DocumentPicker, CredentialMatcher
├── ViewModels/       # DatabaseViewModel, TOTPViewModel
├── Views/            # SwiftUI views
└── argon2/           # Bundled libargon2 C sources

AutoFillExtension/    # AutoFill Credential Provider extension
KeeVaultTests/        # Unit tests (including CredentialMatcherTests)
KeeVaultUITests/      # UI tests
TestFixtures/         # Test .kdbx files
```

## Docs

- `STATUS.md` — current project state + recent changes
- `AGENTS.md` — architecture notes for AI coding agents

## License

MIT
