# Radhika — Security Architecture

**Version**: 1.2.32 (v1.2.32+37)
**Last Verified**: October 2026

## 1. Security Model Overview

Radhika follows a **defense-in-depth** model with multiple layers:

1. **No backend** — health data never leaves the device
2. **Firebase Auth-only** — authentication delegated to Firebase
3. **Local encryption** — AES-256-GCM for all health data at rest
4. **Fail-closed patterns** — consent, storage, and auth errors default to safe state
5. **Minimal permissions** — only required Android permissions declared

## 2. Authentication & Authorization

### 2.1 Authentication Provider

- **Provider**: Firebase Authentication (`firebase_auth: ^5.5.1`)
- **Methods**: Email/password, Google Sign-In
- **Session**: Firebase SDK manages tokens (ID token + refresh token) in OS keychain
- **No custom auth**: All credential handling delegated to Firebase SDK

### 2.2 Authorization Model

- **No role-based access control** in the app (single-user, local data)
- **Firebase Auth custom claims** used in Firestore/Storage rules (admin gate)
- **Client-side**: `isAuthenticated` check via `authProvider`
- **No server-side authorization** (no backend; data is local)

### 2.3 Auth State Management

- `AuthNotifier` (Riverpod StateNotifier) wraps Firebase Auth stream
- `AuthState` carries: `user` (AsyncValue<User?>), `profile`, `isLoading`, `error`
- `_onAuthChange` carries `isLoading` through to prevent double-submit
- Privacy policy gate: `needsPrivacyPolicy` checks `profile.privacyPolicyAccepted`

## 3. Data Protection

### 3.1 At-Rest Encryption

- **Cipher**: `HiveAesCipher` (AES-256-GCM)
- **Key generation**: `Hive.generateSecureKey()` (32 bytes, CSPRNG)
- **Key storage**: `flutter_secure_storage` → Android encrypted SharedPreferences / iOS Keychain
- **Key lifecycle**: Generated once on first run, persisted, verified on read
- **Fail-closed**: `_getOrCreateCipher()` rethrows on storage failure; no plaintext fallback

### 3.2 Migration Safety

- One-time migration from plaintext Hive boxes to encrypted counterparts
- Migration marker in secure storage prevents re-migration
- Migration failures logged but don't crash (box opens encrypted regardless)

### 3.3 Data Deletion

- `clearUserData(userId)` deletes all entries for that user from all 5 boxes
- `deleteAccount()` deletes Firebase Auth record + local data
- `clearAll()` wipes all boxes (used for "Delete All Data")

## 4. Network Security

### 4.1 Transport

- `android:usesCleartextTraffic="false"` in AndroidManifest
- All Firebase traffic over HTTPS (SDK-enforced)
- AdMob traffic over HTTPS
- `network_security_config.xml` restricts to `*.radhika.app` domain

### 4.2 Certificate Pinning

- Not implemented (relies on system CA store + Firebase SDK)
- `network_security_config.xml` exists but is not wired into AndroidManifest (redundant with `usesCleartextTraffic=false`)

## 5. Secrets Management

### 5.1 In-Source Secrets

- **No hardcoded credentials** in `lib/` or `test/` (verified via grep + `hardcoded_secret_source_test.dart`)
- `google-services.json` untracked from source (Phase 4 remediation)
- AdMob app ID in AndroidManifest (public by design, not a secret)
- API key in `google-services.json` is a public identifier (restricted via Firebase console)

### 5.2 Keystore

- Release key: `anya-release-key-v2.jks` (RSA-4096, alias `anya-release`)
- Location: `/home/anya/secure-android/` (outside repository)
- Passwords: `/home/anya/secure-android/PASSWORDS.txt` (mode 600)
- CI signing: `RELEASE_KEYSTORE_B64` + `RELEASE_STORE_PASSWORD` + `RELEASE_KEY_PASSWORD` + `RELEASE_KEY_ALIAS` secrets
- Old keystore quarantined (not deleted) at `compromised/`

### 5.3 API Key Restrictions

- Each of 3 app projects has one restricted Android key
- `androidKeyRestrictions.allowedApplications` = own package + both SHA-1 fingerprints (release + debug)
- 27-service `apiTargets` allowlist
- Browser keys (unused) deleted; web project keys allowlisted to real origins

## 6. Input Validation

- `validators.dart` provides regex-based validation
- Age: 10-120, cycle length: 20-45, period length: 2-10
- Password: min 8 characters
- Email: standard email regex
- `secure_model_factory.dart`: allowlisted deserialization (fail-closed on unknown types)
- `safeEnumFromIndex`: bounds-checked enum resolution (throws on out-of-range)

## 7. Privacy Controls

- Health data stored locally only (Hive encrypted)
- No health data transmitted to Firebase (Auth-only)
- Privacy policy gate mandatory before app access
- Explicit consent checkbox on login/register
- AdMob consent via UMP (fail-closed)
- Data export via Share (user-initiated)
- Account deletion available in settings

## 8. Consent Management (UMP/AdMob)

- `AdConsentService` implements GDPR consent flow
- Fail-closed: errors → ads off
- Dual-clock cooldown (monotonic + suspension credit)
- Form presentation rate-limited (10-minute cooldown)
- Only definitive ALLOW cached for session

## 9. Vulnerability Status

- 0 open Dependabot alerts (fleet-wide)
- No hardcoded secrets in `lib/` or `test/`
- `hardcoded_secret_source_test.dart` guards against regression
- Firestore/Storage rules hardened (claims-based admin, role-field rejection, predictions read-only)

## 10. Known Security Limitations

1. **Debug SHA-1** added to API key restrictions — debug builds from other machines fail Firebase Auth (by design)
2. **No certificate pinning** — relies on system CA store
3. **network_security_config.xml** not wired into AndroidManifest (redundant with `usesCleartextTraffic=false`)
4. **No rate limiting** on client side (Firebase Auth has server-side rate limiting)
5. **No biometric/PIN lock** on app (health data encrypted at rest but accessible if device unlocked)

---

*See also: `docs/SECURITY_AND_PRIVACY.md`, `docs/PRIVACY_POLICY_REVIEW.md`*