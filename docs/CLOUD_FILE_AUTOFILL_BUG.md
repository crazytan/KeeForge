# Cloud File AutoFill Bug

## Problem

When a .kdbx database is opened from a cloud drive (Google Drive, OneDrive, Dropbox) via the iOS document picker, AutoFill and Face ID unlock fail.

### Symptoms
1. **AutoFill:** "Couldn't communicate with a helper application" error when tapping a QuickType suggestion
2. **Face ID unlock:** Fails with same error — can't access the database file
3. **Password unlock in main app:** Works fine (document picker's security scope is still active)

### Root Cause (hypothesis)
The main app creates a security-scoped bookmark for the cloud file URL via `DocumentPickerService.saveBookmark()`. This bookmark is stored in the App Group shared UserDefaults (`SharedVaultStore`).

The AutoFill extension runs in a separate process/sandbox. When it tries to resolve the bookmark via `SharedVaultStore.loadBookmarkedURL()`, the security-scoped bookmark for a cloud-hosted file may not be resolvable from the extension's sandbox — the extension doesn't have the same file provider entitlements.

Local files (e.g., from Files app → On My iPhone) work because their bookmarks are file-system-level and resolvable cross-process.

### Why the extension needs file access
- `ASCredentialIdentityStore` (QuickType bar) is populated when the user unlocks in the main app — this works without file access
- But when the user **taps** a QuickType suggestion, the extension must decrypt the .kdbx to retrieve the actual password/passkey
- Decryption requires reading the file → needs file access → fails for cloud bookmarks

## Proposed Fix (needs validation)
Copy the .kdbx file into the App Group container (`group.com.keevault.shared`) when selected from a cloud provider, instead of just bookmarking the remote URL. Both the main app and extension can always access App Group storage.

### Concerns to validate
1. **Staleness:** If the user updates the .kdbx on their desktop and syncs via cloud, the local copy in the App Group container becomes stale. Need a refresh mechanism.
2. **File size:** .kdbx files are typically small (<10MB), so storage isn't a concern, but should confirm.
3. **Is the bookmark the actual problem?** Could be an entitlement issue, file provider permission, or something else entirely. Need to confirm by testing if the bookmark resolves in the extension.
4. **Alternative approaches:**
   - Could we cache decrypted credentials in the keychain instead of re-reading the file?
   - Does Apple provide a way for extensions to access file provider URLs?
   - Could we use `NSFileCoordinator` in the extension to access cloud files?
5. **Local files:** Do local file bookmarks (e.g., Files app → On My iPhone) work correctly in the extension? If so, the fix should only apply to cloud-sourced files.

## Affected Code
- `SharedVaultStore.swift` — bookmark save/load
- `DocumentPickerService.swift` — bookmark creation
- `DatabaseViewModel.selectFile()` — file selection flow  
- `AutoFillExtension/CredentialProviderViewController.swift` — reads bookmark to decrypt

## Status
- **Reported:** 2026-03-08
- **Reproduced:** Yes, with Google Drive .kdbx
- **Fix:** Pending research
