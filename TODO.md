# TODO.md

## Now

1. Finalize app target wiring in `KeeVault.xcodeproj`
2. Verify all existing model/crypto sources are linked correctly
3. Confirm `CArgon2Bridge/argon2_bridge.h` and `libargon2` integration
4. Ensure required `Info.plist` privacy keys are present

## Next

1. Build services in `KeeVault/Services/`
2. `KeychainService`: derived key storage with biometric access control
3. `BiometricService`: Face ID/Touch ID availability + auth flow
4. `ClipboardService`: copy with 30-second auto-clear
5. `DocumentPickerService`: `.kdbx` selection + security-scoped bookmarks

## UI & State

1. Implement `DatabaseViewModel` state machine (locked/unlocking/unlocked/error)
2. Implement `TOTPViewModel` timer and period-boundary refresh
3. Build views: `UnlockView`, `GroupListView`, `EntryListView`, `EntryDetailView`, `SearchView`
4. Add app lifecycle locking behavior in `KeeVaultApp.swift`

## AutoFill

1. Create/finish `AutoFillExtension` credential provider target
2. Add unlock flow (password + biometrics)
3. Implement domain/service matching and quick search
4. Return credentials through extension context

## Polish & Hardening

1. Empty states (no file, no results, no entries)
2. Haptics on copy actions
3. App switcher/screenshot protection while backgrounded
4. End-to-end validation with realistic `.kdbx` fixtures
5. Add focused tests for parsing, unlock flow, and search behavior

## Backlog (Post-v1)

1. Entry/group create/edit/delete
2. Attachments
3. Keyfile support
4. Hardware key support (YubiKey, etc.)
5. Multiple database management

