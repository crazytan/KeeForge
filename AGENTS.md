# AGENTS.md

Important context for AI coding agents working on KeeVault.

## Project Snapshot

- iOS password manager for KeePassXC/KDBX
- Swift 6 + SwiftUI (iOS 17+)
- Architecture: MVVM with Observation (`@Observable`)
- v1 scope: read-only database access

## Stable Core (Handle Carefully)

Core logic in `KeeVault/Models/` is implemented and should not be refactored unless fixing a real bug:

- `KDBXParser.swift` (KDBX 4.x parsing/decryption/integrity/XML)
- `KDBXCrypto.swift` (AES, ChaCha20, Argon2 bridge, HMAC, gzip)
- `Entry.swift` and `Group.swift` models
- `TOTPGenerator.swift` (RFC 6238)
- `CArgon2Bridge/argon2_bridge.h`

## Architecture & Conventions

- Use `@Observable`, not `ObservableObject`/`@Published`
- Use `NavigationStack` + `NavigationPath`, not `NavigationView`
- Use SwiftUI `.fileImporter`, not UIKit document picker wrappers
- Keep crypto/parsing off the main thread (`Task` background work)
- Follow Swift 6 strict concurrency (`Sendable` correctness)
- Avoid force unwraps outside tests
- Prefer `guard` for early exits
- No unnecessary third-party dependencies

## Security Expectations

- Store derived/composite key in Keychain with biometric access control
- Never store raw master password
- Auto-lock when app backgrounds
- Clear sensitive in-memory state on lock/background
- Clipboard entries auto-expire (30s)
- No analytics, telemetry, or network calls

## Feature Boundaries (v1)

Included:
- KDBX 4.x read/decrypt
- Group/entry browsing
- Search (title/username/url/notes)
- TOTP display + copy
- Face ID unlock after first password unlock
- AutoFill credential provider extension

Not included:
- Create/edit/delete entries or groups
- Attachments
- Keyfile support
- Hardware key/YubiKey support
- Multiple databases

## Testing Notes

- Validate with real KeePassXC `.kdbx` fixtures
- Include nested groups, URLs, notes, protected fields, and TOTP
- Test Face ID in simulator: `Features > Face ID > Enrolled`
- Test AutoFill via iOS Settings password autofill flow

