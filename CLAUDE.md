# CLAUDE.md — Instructions for AI Coding Agents

## Project

KeeVault is a free iOS KeePassXC-compatible password manager (read-only v1). Native Swift/SwiftUI.

## What's Done

The core KDBX parsing layer is complete and lives in `KeeVault/Models/`:

- `KDBXParser.swift` — Full KDBX 4.x parser (header, key derivation, decryption, HMAC verification, XML parsing)
- `KDBXCrypto.swift` — AES-256-CBC, ChaCha20-Poly1305, ChaCha20 stream, Argon2 bridge, HMAC-SHA256, GZip
- `Entry.swift` — `KPEntry` model with TOTP config
- `Group.swift` — `KPGroup` model (tree structure)
- `TOTPGenerator.swift` — RFC 6238 TOTP with Base32, SHA1/256/512
- `CArgon2Bridge/argon2_bridge.h` — C header bridging to libargon2

**Do NOT modify these files** unless fixing a bug. They are tested and working.

## What Needs to Be Built

### Phase 1: Xcode Project Setup
1. Create `KeeVault.xcodeproj` targeting iOS 17+, Swift 6
2. Add all existing source files to the main target
3. Configure bridging header for `CArgon2Bridge/argon2_bridge.h`
4. Link `libargon2` — either:
   - Bundle the argon2 C source files directly (preferred, no external deps), OR
   - Use SPM package for argon2
5. Add `Info.plist` with required keys (Face ID usage description, etc.)
6. Verify the project builds with existing Models

### Phase 2: Services Layer
Create in `KeeVault/Services/`:

**KeychainService.swift**
- Store/retrieve derived database key with biometric protection
- Use `kSecAttrAccessControl` with `.biometryCurrentSet`
- Store the composite key (post-password-hash), not the raw password

**BiometricService.swift**
- Check biometric availability (LAContext)
- Authenticate with Face ID/Touch ID
- Handle fallback to password

**ClipboardService.swift**
- Copy to clipboard with auto-clear after 30 seconds
- Use `UIPasteboard.general` with expiration

**DocumentPickerService.swift**
- Present `.fileImporter` for `.kdbx` files
- Create security-scoped bookmarks for persistent access
- Store bookmark data in UserDefaults

### Phase 3: ViewModels
Create in `KeeVault/ViewModels/`:

**DatabaseViewModel.swift**
- `@Observable` class (iOS 17 Observation framework)
- States: locked, unlocking, unlocked, error
- Hold the parsed `KPGroup` root
- Handle: open file, unlock with password, lock, Face ID unlock
- Search filtering across all entries
- Track current navigation path

**TOTPViewModel.swift**
- Live-updating TOTP codes (Timer-based)
- Seconds remaining countdown
- Auto-refresh on period boundary

### Phase 4: SwiftUI Views
Create in `KeeVault/Views/`:

**KeeVaultApp.swift** (in `App/`)
- `@main` entry point
- Scene with `WindowGroup`
- Root: `UnlockView` when locked, `GroupListView` when unlocked
- Handle `scenePhase` changes for auto-lock

**UnlockView.swift**
- File picker button (if no file selected)
- Password text field (SecureField)
- "Unlock" button
- Face ID button (if available and previously unlocked)
- Error display
- Clean, centered layout

**GroupListView.swift**
- `NavigationStack` with `List`
- Show subgroups as folders (NavigationLink → GroupListView recursively)
- Show entries below groups (NavigationLink → EntryDetailView)
- Show entry count per group
- Toolbar: search, lock button

**EntryListView.swift**
- Flat list of entries (for search results)
- Entry row: icon, title, username subtitle
- TOTP badge if entry has TOTP

**EntryDetailView.swift**
- Title + icon at top
- Fields as rows: Username, Password (hidden by default, tap to reveal), URL, Notes
- Copy button on each field
- TOTP section with live code + countdown ring
- Open URL button
- Tap field to copy with haptic feedback

**SearchView.swift**
- Search bar at top
- Filter entries as user types (title, username, URL, notes)
- Results in EntryListView format
- Can be integrated into GroupListView toolbar

### Phase 5: AutoFill Extension
Create `AutoFillExtension/` target:
- `CredentialProviderViewController` subclass of `ASCredentialProviderViewController`
- Present simplified unlock UI (password + Face ID)
- Match entries by service identifier (domain matching)
- Return credentials via `extensionContext`
- Add `AutoFill Credential Provider` entitlement

### Phase 6: Polish
- App icon (SF Symbol based or custom)
- Launch screen
- Screenshot protection (`UIWindow` overlay on `.background` scene phase)
- Haptic feedback on copy actions
- Empty states (no file, no entries, no search results)

## Architecture Notes

- Use iOS 17 `@Observable` macro (NOT `ObservableObject`/`@Published`)
- Use `NavigationStack` with `NavigationPath` (NOT `NavigationView`)
- Use `.fileImporter` modifier (NOT `UIDocumentPickerViewController` wrapper)
- All crypto is synchronous — run `KDBXParser.parse()` on a background thread via `Task { }`
- Entry/Group models are already `Sendable`

## Testing

- Test with a real `.kdbx` file created in KeePassXC
- Include entries with: passwords, TOTP, URLs, notes, nested groups
- Test Face ID in simulator (Features → Face ID → Enrolled)
- Test AutoFill via Settings → Passwords → AutoFill Passwords

## Conventions

- Swift 6 strict concurrency
- No force unwraps except in tests
- Use `guard` for early returns
- SF Symbols for all icons (no custom images in v1)
- No third-party dependencies
