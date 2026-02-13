# KeeVault

A free, native iOS KeePassXC-compatible password manager. Read-only in v1.

## Why

There's no great free KeePass client on iOS. Strongbox charges $50/year, KeePassium has a subscription too. KeeVault is free, open-source, and does the basics right: open your `.kdbx` file, browse entries, copy passwords, autofill with Face ID.

## Tech Stack

- **Language:** Swift 6 (strict concurrency)
- **UI:** SwiftUI, iOS 17+
- **Architecture:** MVVM
- **Dependencies:** None (pure Apple frameworks + bundled libargon2)

## Status

| Component | Status |
|-----------|--------|
| KDBX 4.x parser | ✅ Done |
| Crypto (AES/ChaCha20/Argon2) | ✅ Done |
| TOTP generation | ✅ Done |
| Data models (Entry/Group) | ✅ Done |
| Xcode project | ❌ Not started |
| SwiftUI views | ❌ Not started |
| ViewModels | ❌ Not started |
| Services (Keychain/Bio/Clipboard) | ❌ Not started |
| AutoFill extension | ❌ Not started |
| Face ID integration | ❌ Not started |

## Building

1. Open `KeeVault.xcodeproj` in Xcode 16+
2. Select a simulator or device (iOS 17+)
3. Build & Run

## Project Structure

```
KeeVault/
├── KeeVault/
│   ├── App/                    # App entry point
│   │   └── KeeVaultApp.swift
│   ├── Models/                 # Core logic (KDBX parsing, crypto, TOTP)
│   │   ├── KDBXParser.swift    ✅
│   │   ├── KDBXCrypto.swift    ✅
│   │   ├── Entry.swift         ✅
│   │   ├── Group.swift         ✅
│   │   └── TOTPGenerator.swift ✅
│   ├── Views/                  # SwiftUI views
│   │   ├── UnlockView.swift
│   │   ├── GroupListView.swift
│   │   ├── EntryListView.swift
│   │   ├── EntryDetailView.swift
│   │   └── SearchView.swift
│   ├── ViewModels/
│   │   ├── DatabaseViewModel.swift
│   │   └── TOTPViewModel.swift
│   ├── Services/
│   │   ├── KeychainService.swift
│   │   ├── BiometricService.swift
│   │   ├── ClipboardService.swift
│   │   └── DocumentPickerService.swift
│   ├── CArgon2Bridge/          # C bridging header for libargon2
│   │   └── argon2_bridge.h     ✅
│   ├── Resources/
│   │   └── Assets.xcassets/
│   └── Extensions/
├── AutoFillExtension/          # Credential Provider extension
├── Tests/
├── README.md
├── REQUIREMENTS.md
└── CLAUDE.md
```

## License

MIT
