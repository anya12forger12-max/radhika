# Radhika — Incident Response Playbook

## Overview

Radhika is a local-first Flutter application with Firebase Authentication only.
All health data is stored locally in encrypted Hive boxes. There is no backend
database or custom API server. This playbook covers incident types relevant to
this architecture.

## Monitoring Stack

| Component | Service | Purpose |
|---|---|---|
| Crash reporting | Firebase Crashlytics | Fatal + non-fatal errors, startup failures |
| Error logging | `debugPrint` (dev only) | Development diagnostics |
| Startup timing | `Stopwatch` in `main.dart` | Logged to debug console in debug builds |
| Hardcoded secret guard | `test/hardcoded_secret_source_test.dart` | CI regression guard |

## Severity Model

### Critical
- Confirmed exposure of sensitive user information
- Widespread application startup failure (crash on launch)
- Firebase Auth misconfiguration allowing unauthorized access
- Data corruption in encrypted Hive storage

### High
- Major feature unavailable (e.g., period tracking, reminders)
- Repeated crashes affecting substantial user base
- Authentication failures for many users
- Encrypted storage key loss (irreversible data loss)

### Medium
- Repeated failures in limited workflow (e.g., specific screen)
- Elevated startup time
- Failing integration (e.g., AdMob, notifications) with viable alternative

### Low
- Isolated noncritical errors
- Minor diagnostic issues
- Cosmetic defects not blocking essential workflows

## Incident Procedures

### 1. Application Startup Failure
1. Check Firebase Crashlytics console for crash reports
2. Identify affected version (build number in crash report)
3. Check if Firebase project config is correct (API key restrictions)
4. Reproduce on emulator with debug build
5. Fix, test, bump version, release

### 2. Authentication Incident
1. Check Firebase Auth console for error rates
2. Verify API key restrictions (SHA-1 fingerprint match)
3. Check if release keystore changed (would break Firebase Auth)
4. Verify `google-services.json` is correct for the build
5. Test sign-in flow on emulator with release APK

### 3. Database/Storage Failure
1. Check Hive box integrity (corrupt boxes are auto-deleted and recreated)
2. Verify encryption key in flutter_secure_storage
3. Check disk space on device
4. Test data migration (plaintext → encrypted)
5. Verify `_openBoxSafely` error handling in `storage_service.dart`

### 4. Failed Third-Party Integration
1. **AdMob**: Check consent flow (`AdConsentService`), verify APP_ID in manifest
2. **Notifications**: Check permission status, timezone data, plugin init
3. **Crashlytics**: Verify collection enabled, check Firebase console

### 5. Incorrect Application Release
1. Identify the bad release tag and commit
2. Check if assets were uploaded (round-29 trap: releases can publish with 0 assets)
3. Verify APK signature matches release key (SHA-1 `7db5348e…`)
4. If needed: clobber-replace assets with correct build
5. Always verify: `gh release view <tag> --json assets`

### 6. Suspected Security/Privacy Incident
1. Check git history for committed secrets (`git log --all --full-history -- <file>`)
2. Run `test/hardcoded_secret_source_test.dart`
3. Verify `google-services.json` is untracked
4. Check Firebase API key restrictions
5. Review crash logs for sensitive data leakage
6. If secret exposed: rotate immediately, update CI secrets

### 7. Monitoring System Outage
1. Crashlytics outage does not affect app functionality (errors logged locally)
2. Verify app still works (Crashlytics init is in try/catch)
3. Check Firebase console status page
4. No user-facing impact (monitoring is transparent to users)

## Diagnostic Commands

```bash
# Check app version
flutter run --version 2>/dev/null; cat pubspec.yaml | grep version

# Run tests
flutter analyze lib/ test/
flutter test

# Build debug APK
flutter build apk --debug

# Check git status
git status --short
git log --oneline -5

# Verify release
gh release view <tag> --json assets --jq '.assets[] | "\(.name) \(.size)"'

# Check for secrets in tracked files
git grep -n "AIzaSy\|sk-\|BEGIN.*PRIVATE KEY" -- '*.dart' '*.json' '*.xml' '*.plist' '*.env'
```

## Alert Thresholds

| Alert | Condition | Severity | Response |
|---|---|---|---|
| Crash rate spike | > 1% of sessions crash | Critical | Investigate immediately |
| Startup failure | App fails to initialize Firebase | High | Check Firebase config |
| Auth failure rate | > 5% of sign-in attempts fail | High | Check API key restrictions |
| Storage error | Hive box open failure | Medium | Check device storage/encryption |
| Missing release assets | Release published with 0 assets | Medium | Re-upload assets |

## Privacy Controls

- **No health data in crash reports**: Crashlytics collects only stack traces and device info
- **No PII in logs**: `debugPrint` guarded by `kDebugMode`; production logs go to Crashlytics only
- **No analytics telemetry**: No usage analytics beyond Crashlytics crash reporting
- **No network requests for health data**: All data stays local
- **Retention**: Crashlytics data retained per Firebase default policy (90 days)

## Known Monitoring Limitations

1. No structured logging in production (only Crashlytics)
2. No startup time benchmarking in CI
3. No memory leak detection
4. No automated alerting (Firebase console only)
5. No device-side performance profiling
6. No real-time dashboard for crash rates

## Operational Ownership

- **Repository**: https://github.com/anya12forger12-max/radhika.git
- **CI/CD**: GitHub Actions (play-store-release.yml on v* tags)
- **Crash reporting**: Firebase Crashlytics console
- **Release signing**: GitHub secrets (RELEASE_KEYSTORE_B64, etc.)
- **Firebase project**: radhika-app-5d885
