# Radhika — Troubleshooting Guide

**Version**: 1.2.32 (v1.2.32+37)
**Last Verified**: October 2026

## 1. Build & Environment Issues

### Flutter analyze reports issues in `firebase/rules-testing/node_modules/`

**Symptom**: `flutter analyze` reports errors in `firebase/rules-testing/node_modules/firebase-tools/templates/...`

**Cause**: The `firebase/` directory is not excluded in `analysis_options.yaml`. The firebase-tools node_modules contain Dart templates that don't compile with the current SDK.

**Resolution**: Run `flutter analyze lib/ test/` instead of `flutter analyze` (whole project). The CI pipeline uses this scoped command.

### Flutter test count differs from documented baseline

**Symptom**: `flutter test` reports a different number than the documented 91/91.

**Cause**: Test count changes when tests are added/modified. The baseline is updated per release.

**Resolution**: Verify all tests pass (`All tests passed!`), not a specific count. Check `git log` for recent test changes.

### `flutter pub get` fails with dependency resolution errors

**Symptom**: `flutter pub get` fails with version conflicts.

**Cause**: Dependency constraints in `pubspec.yaml` may be incompatible with installed Flutter SDK.

**Resolution**: Ensure Flutter 3.47.x is installed. Run `flutter pub get` with `--offline` if network is unavailable. Check `flutter doctor` for SDK issues.

## 2. Authentication Issues

### "Invalid email or password" on correct credentials

**Symptom**: Sign-in fails with "Invalid email or password" for valid credentials.

**Cause**: Firebase Auth error mapping collapses `user-not-found`, `wrong-password`, and `invalid-credential` into one message (intentional, for security).

**Resolution**: Verify credentials are correct. Check Firebase console for account status. If account was deleted, re-register.

### Google Sign-In fails or cancelled

**Symptom**: Google Sign-In shows "Google sign-in was cancelled" or fails silently.

**Cause**: `google_sign_in` requires platform-specific configuration (SHA-1 fingerprint in Firebase console). Debug builds from non-registered machines fail.

**Resolution**: Ensure the device's debug SHA-1 (`CB:79:DD:5C:3F:F4:E1:2B:9E:0D:62:28:A6:A6:D5:CB:F8:4E:73:02`) is in the Firebase API key restrictions. For release builds, use the release key SHA-1.

### "Session expired. Please sign in again"

**Symptom**: User is logged out unexpectedly.

**Cause**: Firebase Auth ID token expired and refresh failed (network issue or account disabled).

**Resolution**: Sign in again. Check network connectivity. Verify account is not disabled in Firebase console.

## 3. Data & Storage Issues

### Hive box open failure on startup

**Symptom**: App crashes or shows "Failed to migrate Hive box" in debug logs.

**Cause**: Corrupted Hive box or invalid encryption key.

**Resolution**: The app attempts migration from plaintext to encrypted boxes. If migration fails, it logs and continues. If the encrypted box itself is corrupted, the app may fail to open it. Clear app data (Settings → Apps → Radhika → Clear Storage) as last resort — this deletes all local data.

### "Stored Hive encryption key has invalid length"

**Symptom**: App fails to initialize storage.

**Cause**: The encryption key in `flutter_secure_storage` was corrupted or tampered with.

**Resolution**: Clear app data to regenerate the key. All local health data will be lost. This is a security feature — a tampered key cannot be used to decrypt data.

### Data export produces empty or incomplete JSON

**Symptom**: Exported JSON missing cycles or profile.

**Cause**: No data logged yet, or user not authenticated.

**Resolution**: Ensure you're logged in and have logged at least one cycle entry. Export includes profile, cycles, predictions, reminders, and reminder preferences.

## 4. Notification Issues

### Reminders not firing

**Symptom**: Period reminders don't appear at the scheduled time.

**Cause**: `POST_NOTIFICATIONS` permission not granted, or device battery optimization kills the app.

**Resolution**: Grant notification permission in Settings → Apps → Radhika → Notifications. Disable battery optimization for Radhika. Verify reminder toggles are enabled in Settings.

### Timezone incorrect

**Symptom**: Reminders fire at wrong time.

**Cause**: Device timezone not detected correctly.

**Resolution**: The app uses `flutter_timezone` to detect the local timezone. If detection fails, it falls back to UTC. Check device timezone settings. Restart the app after changing timezone.

## 5. Ad & Consent Issues

### Ads not showing

**Symptom**: No banner ads appear on Home screen.

**Cause**: UMP consent not granted, or AdMob not initialized.

**Resolution**: Ads are fail-closed — if consent is not definitively granted, ads stay off. This is by design. Verify the app has network access. Check AdMob console for ad unit status.

### Consent dialog appears repeatedly

**Symptom**: UMP consent form shown on every app launch.

**Cause**: Consent status not persisted by the SDK, or the form was dismissed without a decision.

**Resolution**: The app rate-limits form presentation (10-minute cooldown). If the user dismisses the form, it will re-appear after the cooldown. Complete the consent flow to persist the decision.

## 6. Build & Release Issues

### Release APK not signed with release key

**Symptom**: `apksigner verify` shows debug signing.

**Cause**: `RELEASE_KEYSTORE_B64` secret not set in CI, or `android/key.properties` not present locally.

**Resolution**: Ensure CI secrets are configured. For local builds, place `android/key.properties` with the correct keystore path and passwords. See `/home/anya/secure-android/ROTATION-HANDOFF.md`.

### `processDebugGoogleServices` fails: "No matching client found"

**Symptom**: Build fails with "No matching client found for package name 'com.radhika.app' in google-services.json."

**Cause**: `google-services.json` is untracked from source (security hardening). The CI secret `GOOGLE_SERVICES_JSON` must be set, or a local copy must be present.

**Resolution**: For CI, ensure `GOOGLE_SERVICES_JSON` secret is configured. For local builds, obtain the file from Firebase console (Project Settings → General → Your apps → Download google-services.json) and place it at `android/app/google-services.json`.

### Firebase Deploy fails with 403

**Symptom**: `firebase deploy --only firestore:rules` fails with permission error.

**Cause**: `FIREBASE_TOKEN` secret expired or insufficient permissions.

**Resolution**: Regenerate the Firebase token: `firebase login:ci`. Update the `FIREBASE_TOKEN` secret in GitHub. Verify the token has Firestore Rules deploy permission.

## 7. Emulator & Device Testing

### Emulator won't boot or is unresponsive

**Symptom**: `emulator` command hangs or AVD crashes.

**Cause**: Insufficient host memory, or stale AVD state.

**Resolution**: Relaunch with `start-emu.sh` (if available). Use only one emulator at a time. Ensure at least 4GB free RAM. Kill stale processes: `adb emu kill`.

### `adb install` fails with INSTALL_FAILED_UPDATE_INCOMPATIBLE

**Symptom**: Cannot install release APK over existing debug build.

**Cause**: Signature mismatch — debug and release builds use different signing keys.

**Resolution**: Uninstall the existing app first: `adb uninstall com.radhika.app`, then install the new APK. Use `adb install -r` only when signatures match.

### Flutter `input text` garbles or duplicates

**Symptom**: Text typed via `adb shell input text` appears garbled or duplicated.

**Cause**: Emulator keyboard handling quirk — `input text` appends rather than replaces.

**Resolution**: Use `adb shell input keycombination 113 29` (Ctrl+A) to select all before typing. Or force-stop the app and re-enter the field. Verify field contents via `uiautomator dump` (EditText bullets show character count).

---

*See also: `docs/OPERATIONS_AND_TROUBLESHOOTING.md`, `docs/BUILD_AND_RELEASE.md`*