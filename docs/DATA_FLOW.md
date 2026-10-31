# Radhika — Data Flow Documentation

**Version**: 1.2.32 (v1.2.32+37)
**Last Verified**: October 2026

## 1. Overview

All health data (cycle entries, predictions, reminders, profile) is stored **locally** in AES-256 encrypted Hive boxes. No health data is transmitted to any server. The only external communication is Firebase Authentication (sign-in/sign-out tokens).

## 2. End-to-End Flows

### 2.1 Registration Flow

```
User → RegisterScreen
  → AuthNotifier.registerWithEmail(email, password)
    → AuthService.registerWithEmail()
      → FirebaseAuth.createUserWithEmailAndPassword()
      → sendEmailVerification() (non-fatal if fails)
    → StorageService.saveProfile(UserProfile)
    → AuthState updated (user, profile, isLoading=false)
  → _AuthGate detects authenticated → /privacy-policy-required
  → User accepts privacy policy → acceptPrivacyPolicy()
    → StorageService.saveProfile(profile with accepted=true)
  → Navigate to /home
```

**Error handling**: FirebaseAuthException → mapped to user-friendly message via `mapAuthErrorCode`. Generic exceptions → "Something went wrong."

### 2.2 Login Flow

```
User → LoginScreen
  → AuthNotifier.signInWithEmail(email, password)
    → AuthService.signInWithEmail()
      → FirebaseAuth.signInWithEmailAndPassword()
    → AuthState updated (user, profile loaded from Hive)
  → _AuthGate detects authenticated → /home (or /privacy-policy-required)
```

**Privacy gate**: If `profile.privacyPolicyAccepted != true`, navigates to `/privacy-policy-required` before `/home`.

### 2.3 Cycle Entry Flow

```
User → LogPeriodScreen
  → CycleNotifier.addCycleEntry(...)
    → Creates CycleEntry with UUID
    → StorageService.saveCycleEntry(entry) → Hive encrypted box
    → _loadCycles() → reads all entries for user, sorts by startDate desc
    → _syncLastPeriodStart() → updates UserProfile.lastPeriodStart if changed
    → _updatePrediction()
      → CyclePredictionService.predictNextCycle()
      → StorageService.savePrediction()
      → Trim old predictions (keep last 10)
      → _rescheduleReminders() → NotificationService.zonedSchedule()
    → CycleState updated (history, prediction, delaySuggestions)
  → UI rebuilds from CycleState
```

### 2.4 Reminder Flow

```
Settings → Toggle reminder preference
  → StorageService.saveReminderPreferences(userId, prefs)
  → CycleNotifier._rescheduleReminders()
    → NotificationService.reschedulePeriodReminders()
      → cancelPeriodReminders() (cancel old scheduled)
      → For each enabled preference:
        → schedulePeriodReminder(daysBefore, predictedDate)
          → zonedSchedule with TZDateTime from reminderDate
```

At startup: `_rescheduleStartupReminders()` reads prefs + latest prediction and reschedules.

### 2.5 Data Export Flow

```
Settings → Export Data
  → StorageService.exportData(userId)
    → Reads profile, cycles, predictions, reminders, reminder prefs
    → JSON with indent 2 + exportDate + appVersion
  → Share.share(json) → OS share sheet
```

### 2.6 Account Deletion Flow

```
Settings → Delete Account
  → AuthNotifier.deleteAccount()
    → AuthService.deleteAccount() → FirebaseAuth.currentUser.delete()
    → StorageService.clearUserData(userId) → deletes all user entries from all boxes
    → CycleProvider invalidated
    → AuthState reset to unauthenticated
  → Navigate to /login
```

**Failure handling**: If Firebase deletion fails (e.g., requires-recent-login), local data is NOT deleted and user sees error message.

### 2.7 Sign Out Flow

```
Settings → Logout
  → AuthNotifier.signOut()
    → AuthService.signOut() → GoogleSignIn.signOut() + FirebaseAuth.signOut()
    → CycleProvider invalidated → CycleState reset
    → AuthState reset to unauthenticated
  → Navigate to /login
```

### 2.8 Password Reset Flow

```
Login → Forgot Password
  → AuthNotifier.sendPasswordReset(email)
    → AuthService.sendPasswordResetEmail()
      → FirebaseAuth.sendPasswordResetEmail()
  → Success: AuthState.isLoading = false (no error)
  → Failure: AuthState.error = mapped message
```

## 3. State Management Flow

```
┌─────────────┐     ┌──────────────┐     ┌──────────────┐
│  Firebase   │────▶│ AuthNotifier │────▶│  AuthState   │
│  Auth SDK   │     │  (Riverpod)  │     │  (user,      │
└─────────────┘     └──────────────┘     │   profile,   │
                          │               │   loading,   │
                          ▼               │   error)     │
                   ┌──────────────┐       └──────────────┘
                   │ StorageService│              │
                   │  (Hive)      │              ▼
                   └──────────────┘       ┌──────────────┐
                          │               │  HomeScreen  │
                          ▼               │  (watches    │
                   ┌──────────────┐       │   authProvider)│
                   │CycleNotifier │──────▶└──────────────┘
                   │  (Riverpod)  │
                   └──────────────┘
                          │
                          ▼
                   ┌──────────────┐
                   │ CycleState   │
                   │ (history,    │
                   │  prediction, │
                   │  suggestions)│
                   └──────────────┘
```

## 4. Data Storage Flow

### Encrypted Hive Boxes

```
flutter_secure_storage (OS Keychain)
  └── hive_encryption_key (base64-encoded 32-byte key)
        └── HiveAesCipher
              ├── profile_box_enc  → UserProfile
              ├── cycles_box_enc   → CycleEntry
              ├── predictions_box_enc → CyclePrediction
              ├── reminders_box_enc  → Reminder
              └── settings_box_enc   → String (key-value)
```

### Migration Flow (one-time, per box)

```
On init():
  1. Check migration flag in secure storage
  2. If flag == '1': delete plaintext box, return
  3. If plaintext box doesn't exist: write flag, return
  4. Open plaintext box, copy entries to encrypted box
  5. Write migration flag, delete plaintext box
  6. On any error: log and continue (fail-open for migration)
```

## 5. Error Handling Flow

```
Service call → try/catch
  → FirebaseAuthException → _mapFirebaseError(code) → user-friendly message
  → Generic exception → debugPrint detail + friendly fallback message
  → State updated with error field
  → UI shows SnackBar or inline error
```

All service calls are wrapped in try/catch. No unhandled exceptions reach the UI.

## 6. Security Boundaries

| Boundary | Enforcement |
|----------|-------------|
| Health data at rest | AES-256-GCM (HiveAesCipher, device-bound key) |
| Health data in transit | None (data never leaves device) |
| Auth tokens | Firebase SDK (OS keychain on iOS, encrypted prefs on Android) |
| API keys | Firebase console restrictions (package + SHA-1) |
| Network | HTTPS only (usesCleartextTraffic=false) |
| Content security | network_security_config.xml (domain-config) |

---

*See also: `docs/ARCHITECTURE.md`, `docs/DATABASE.md`, `docs/API_REFERENCE.md`*