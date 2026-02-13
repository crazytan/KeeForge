# KeeVault — Requirements

## Overview

Free, native iOS KeePassXC-compatible password manager. Read-only in v1. Modeled after Strongbox UX.

## Tech Stack

- **Language:** Swift 6 (strict concurrency)
- **UI:** SwiftUI (iOS 17+)
- **Architecture:** MVVM
- **Package Manager:** Swift Package Manager
- **Dependencies:** None — pure Apple frameworks + bundled libargon2

## Core Requirements

### KDBX 4.x Support ✅
- Parse and decrypt KDBX 4.x databases
- Argon2d/Argon2id key derivation (via bundled C libargon2)
- AES-256-CBC and ChaCha20-Poly1305 outer encryption
- ChaCha20 inner random stream for protected values
- HMAC-SHA256 block integrity verification
- GZip decompression of inner payload
- XML parsing into Entry/Group tree

### Entry Display
- Browse groups/folders (tree navigation)
- View entry fields: title, username, password (tap to reveal), URL, notes
- Copy username/password/URL to clipboard (auto-clear after 30s)
- Open URL in Safari
- Search across all entries (title, username, URL, notes)

### TOTP (Time-based One-Time Passwords) ✅
- Read KeePassXC TOTP fields: `otp` attribute, `TimeOtp-Secret-Base32`, legacy `TOTP Seed`
- Display live 6/8-digit codes with countdown timer
- SHA1/SHA256/SHA512 algorithm support
- Copy TOTP code to clipboard

### AutoFill Extension
- iOS Credential Provider extension (ASCredentialProviderViewController)
- Match entries by URL/domain
- Face ID gated
- Quick search within AutoFill popup

### Authentication
- Master password entry on first unlock
- Face ID for subsequent unlocks (store derived key in iOS Keychain with biometric protection)
- Auto-lock when app backgrounds

### File Access
- iOS Document Picker (via SwiftUI `.fileImporter`)
- Supports: On My iPhone, iCloud Drive, any installed file provider
- Security-scoped bookmark for re-access without re-picking
- Remember last opened file

### Security
- Auto-lock on app background (clear sensitive data from memory)
- Clipboard auto-clear after 30 seconds
- Screenshot protection (hide content in app switcher)
- No analytics, no telemetry, no network calls

## NOT in v1

- Create/edit/delete entries or groups
- Attachments
- Keyfile support
- YubiKey/hardware key support
- Multiple database support

## UX Reference

- **Strongbox** (iOS) — clean list UI, inline TOTP, group navigation, search
- Native iOS feel, standard NavigationStack patterns
- Dark mode support (automatic via system setting)
- SF Symbols for all icons
- Pull-to-refresh not needed (read-only)

## App Store Metadata

- **Name:** KeeVault
- **Subtitle:** KeePass Password Manager
- **Keywords:** keepass, keepassxc, kdbx, password, manager, vault, totp, autofill, free
- **Category:** Utilities
- **Price:** Free
