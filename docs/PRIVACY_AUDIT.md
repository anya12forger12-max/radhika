# Radhika — Privacy Audit

**Version**: 1.2.32 (v1.2.32+37)
**Last Verified**: October 2026

## A. Personal-Data Inventory

| Category | Collected? | Storage | Encrypted? | Shared? | Retention |
|---|---|---|---|---|---|
| Email address | Yes (Firebase Auth) | Firebase Auth (cloud) | Firebase-managed | No | Until account deletion |
| User ID (UID) | Yes (Firebase Auth) | Firebase Auth + local Hive | Firebase-managed | No | Until account deletion |
| Menstrual cycle dates | Yes (local only) | Hive `cycles_box` | AES-256 | No | Until user deletes |
| Flow intensity | Yes (local only) | Hive `cycles_box` | AES-256 | No | Until user deletes |
| Symptoms | Yes (local only) | Hive `cycles_box` | AES-256 | No | Until user deletes |
| Cycle predictions | Yes (local only) | Hive `predictions_box` | AES-256 | No | Until user deletes |
| Reminders | Yes (local only) | Hive `reminders_box` | AES-256 | No | Until user deletes |
| User profile | Yes (local only) | Hive `profile_box` | AES-256 | No | Until user deletes |
| Theme/font prefs | Yes (local only) | Hive `settings_box` | AES-256 | No | Until user deletes |
| Notification prefs | Yes (local only) | Hive `settings_box` | AES-256 | No | Until user deletes |
| Ad consent state | Yes (local only) | SharedPreferences | No (non-sensitive) | No | Until cleared |
| Analytics events | No | N/A | N/A | N/A | N/A |
| Payment info | No | N/A | N/A | N/A | N/A |
| AI conversations | No | N/A | N/A | N/A | N/A |
| Search history | No | N/A | N/A | N/A | N/A |
| Device identifiers | No (not collected by app) | N/A | N/A | N/A | N/A |

## B. Data-Flow Summary

```
User Input (cycle data, symptoms)
  ↓
Flutter UI (in-memory)
  ↓
StorageService (Hive encrypted boxes, AES-256)
  ↓
Local device storage (app documents directory)
  ↓
NO cloud transmission (health data stays local)

Authentication flow:
  User credentials → Firebase Auth (TLS) → Firebase servers
  (Only auth tokens, no health data)

Advertising flow:
  AdMob SDK → Google ad servers (public ad unit ID only)
  NO health data in ad requests (const AdRequest())
  Consent gated by UMP (fail-closed)

Crash reporting:
  Crashlytics → Firebase (stack traces + device info only)
  NO health data in crash reports (debugPrint guarded by kDebugMode)
```

## C. Sensitive Health-Data Protection

| Data Type | Storage | Encryption | Shared? | Notification? | Crash Report? |
|---|---|---|---|---|---|
| Cycle dates | Hive (encrypted) | AES-256 | No | No (generic reminder) | No |
| Flow intensity | Hive (encrypted) | AES-256 | No | No | No |
| Symptoms | Hive (encrypted) | AES-256 | No | No | No |
| Predictions | Hive (encrypted) | AES-256 | No | No | No |
| User profile | Hive (encrypted) | AES-256 | No | No | No |

- **Notification content**: Generic ("Period reminder", "Log symptoms") — no cycle details in notification body
- **Crash reports**: Only stack traces + device info; `debugPrint` guarded by `kDebugMode` (production logs go to Crashlytics only, which does not include health data)
- **Ad requests**: `const AdRequest()` — no custom targeting, no health data

## D. Third-Party Data Sharing

| Service | Data Sent | Purpose | Consent Required? |
|---|---|---|---|
| Firebase Auth | Email, password (TLS) | Authentication | Implicit (account creation) |
| Firebase Crashlytics | Stack traces, device info | Crash reporting | Implicit (part of app) |
| Google AdMob | Public ad unit ID only | Advertising | UMP consent (fail-closed) |
| Google Sign-In | OAuth token | Authentication | User-initiated |

**No health data is shared with any third party.**

## E. Encryption Status

| Component | Encryption | Key Management |
|---|---|---|
| Hive boxes | AES-256 (HiveAesCipher) | Key generated via `Hive.generateSecureKey()`, stored in `flutter_secure_storage` (platform keystore) |
| flutter_secure_storage | Platform keystore | Android Keystore / iOS Keychain |
| Network (Firebase Auth) | TLS 1.2+ | Firebase-managed certificates |
| Network (AdMob) | TLS 1.2+ | Google-managed certificates |
| Backups | AES-256 (encrypted envelope) | Device-bound key (not in backup file) |

## F. Data Access and Deletion

| Operation | Implementation | Status |
|---|---|---|
| View personal data | Profile screen shows user info | ✅ Implemented |
| Correct data | Edit profile, log new entries | ✅ Implemented |
| Export data | CSV/JSON export from Reports screen | ✅ Implemented |
| Delete all data | "Delete All Data" in Settings (clears all Hive boxes) | ✅ Implemented |
| Account deletion | Firebase Auth `deleteAccount()` | ✅ Implemented |
| Revoke consent | UMP consent can be reset via device settings | ✅ Supported |

**Limitation**: Hive box deletion clears data but may leave residual data in OS-level storage (Android app data directory). Full secure deletion would require `flutter_secure_storage` key deletion + box file deletion.

## G. Privacy-Safe Notifications

- Notification titles/bodies are generic ("Period reminder", "Log symptoms")
- No cycle dates, symptoms, or health details in notification content
- Notification permission requested only when user enables reminders
- Notification IDs are fixed (1001-1004), no user-identifying info

## H. Logs and Monitoring

- `debugPrint` calls are guarded by `kDebugMode` (dev-only)
- Crashlytics records stack traces + device info (no health data)
- No analytics events collected (no Firebase Analytics SDK)
- No user identifiers in crash reports beyond device info

## I. Minors and Age-Appropriate Privacy

- No age verification or collection
- No parental consent mechanism
- App is available to all ages (health education)
- Privacy policy covers general data handling
- **Gap**: No age-gating or parental consent for minors (may be required in some jurisdictions)

## J. Privacy Threat Model

| Threat | Likelihood | Impact | Mitigation | Verification |
|---|---|---|---|---|
| Unauthorized account access | Low | High | Firebase Auth + email verification | Code review |
| Cross-user data exposure | Very Low | High | No shared data; local-only storage | Code review |
| Data leakage via crash reports | Low | Medium | debugPrint guarded; Crashlytics no health data | Code review |
| Data leakage via AdMob | Low | Medium | const AdRequest(); no custom targeting | Code review |
| Insecure backup | Low | Medium | AES-256 encrypted envelope, device-bound key | Code review |
| Notification exposure | Low | Low | Generic notification content | Code review |
| Residual data after deletion | Medium | Low | Hive box clear; OS-level residual possible | Documented limitation |

## K. Legal Compliance Assessment

### Potentially Applicable
- **India DPDP Act 2023**: App collects email (Firebase Auth) and health data (local). Health data is sensitive personal data. Local-only storage reduces exposure but consent and deletion rights must be clearly communicated.
- **GDPR (if EU users)**: Health data is special category data. Requires explicit consent, right to erasure, data portability. App provides export and deletion.
- **CCPA (if California users)**: Right to know, delete, opt-out. App provides deletion and export.

### Gaps Requiring Legal Review
1. No explicit health-data consent flow (beyond general privacy policy acceptance)
2. No data portability in standard format (CSV/JSON export exists but not machine-readable schema)
3. No age verification or parental consent mechanism
4. No data retention policy document
5. No third-party data processing agreements documented

## L. Final Privacy Verification

| Data Category | Purpose | Storage | Encryption | Shared? | Retention | Deletion | Evidence |
|---|---|---|---|---|---|---|---|
| Email | Auth | Firebase Auth (cloud) | Firebase-managed | No | Until deletion | Account deletion | Code review |
| Cycle data | Tracking | Hive (local) | AES-256 | No | Until user deletes | Delete all data | Code review |
| Symptoms | Tracking | Hive (local) | AES-256 | No | Until user deletes | Delete all data | Code review |
| Predictions | Tracking | Hive (local) | AES-256 | No | Until user deletes | Delete all data | Code review |
| Profile | Settings | Hive (local) | AES-256 | No | Until user deletes | Delete all data | Code review |
| Reminders | Notifications | Hive (local) | AES-256 | No | Until user deletes | Delete all data | Code review |
| Ad consent | Consent state | SharedPreferences | No (non-sensitive) | No | Until cleared | Clear data | Code review |

## Final Classification

**IMPROVEMENTS IMPLEMENTED — LEGAL REVIEW REQUIRED**

Technical privacy controls are verified (local encrypted storage, no health data sharing, fail-closed consent, generic notifications, no analytics). Legal compliance with DPDP/GDPR/CCPA requires qualified legal review of consent flows, data retention policies, and age-appropriate safeguards.
