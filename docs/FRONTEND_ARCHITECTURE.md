# Radhika — Frontend Architecture

**Version**: 1.2.32 (v1.2.32+37)
**Last Verified**: October 2026

## 1. Framework and Entry Points

- **Framework**: Flutter 3.47.3 / Dart 3.13.3
- **Entry point**: `lib/main.dart` → `main()` → `runApp(ProviderScope(child: RadhikaApp()))`
- **App widget**: `lib/app.dart` → `RadhikaApp` (ConsumerWidget) wrapping `MaterialApp` with named routes
- **State management**: Riverpod 2.x (`StateNotifierProvider`, `Provider`, `ref.watch`/`ref.read`/`ref.listen`)
- **Routing**: Named routes via `MaterialApp.routes` map (no GoRouter despite README mention)

## 2. Directory Layout

```
lib/
├── app.dart                    # MaterialApp, route table, theme wiring
├── main.dart                   # Service init (Firebase, Storage, Notifications, reminders)
├── core/
│   ├── constants/app_constants.dart   # App name, version, privacy policy, cycle constants
│   ├── theme/app_theme.dart           # Material 3 light/dark/high-contrast themes
│   ├── theme/app_tokens.dart          # Spacing, typography, color tokens
│   └── utils/validators.dart          # Input validation, regex patterns
├── data/models/secure_model_factory.dart  # Fail-closed deserialization factory
├── models/                     # Hive-annotated domain models + generated adapters
├── providers/                  # Riverpod StateNotifier providers
├── screens/                    # UI screens (widget trees)
├── services/                   # Business logic, storage, auth, notifications
├── widgets/                    # Reusable UI components
└── core/assistant/             # (not present — no AI/assistant module)
```

## 3. State Management

### Providers

| Provider | Type | Purpose |
|----------|------|---------|
| `authServiceProvider` | `Provider<AuthService>` | Firebase Auth wrapper |
| `authProvider` | `StateNotifierProvider<AuthNotifier, AuthState>` | Auth state (user, profile, loading, error) |
| `storageServiceProvider` | `Provider<StorageService>` | Hive encrypted storage singleton |
| `cycleProvider` | `StateNotifierProvider<CycleNotifier, CycleState>` | Cycle entries, predictions, reminders |
| `cyclePredictionServiceProvider` | `Provider<CyclePredictionService>` | Prediction computation |
| `themeProvider` | `StateNotifierProvider<ThemeNotifier, ThemeState>` | Theme mode + font size |
| `storageServiceProvider` | `Provider` | Hive storage singleton |

### State Flow

```
Firebase Auth Stream → AuthNotifier._onAuthChange → AuthState
  → CycleNotifier.setUserId → _loadCycles → CycleState
  → HomeScreen watches cycleProvider
```

## 4. Navigation Structure

Named routes defined in `app.dart`:

| Route | Screen | Auth Required |
|-------|--------|---------------|
| `/` | SplashScreen | No |
| `/login` | LoginScreen | No |
| `/register` | RegisterScreen | No |
| `/forgot-password` | ForgotPasswordScreen | No |
| `/home` | HomeScreen | Yes |
| `/calendar` | CalendarScreen | Yes |
| `/cycle-detail` | CycleDetailScreen | Yes |
| `/log-period` | LogPeriodScreen | Yes |
| `/log-symptom` | LogSymptomScreen | Yes |
| `/education` | EducationScreen | Yes |
| `/recommendations` | RecommendationsScreen | Yes |
| `/pad-guide` | PadGuideScreen | Yes |
| `/tampon-guide` | TamponGuideScreen | Yes |
| `/cup-guide` | CupGuideScreen | Yes |
| `/reports` | ReportsScreen | Yes |
| `/settings` | SettingsScreen | Yes |
| `/privacy-policy` | PrivacyPolicyScreen | No |
| `/privacy-policy-required` | PrivacyPolicyScreen(isRequired: true) | Yes |
| `/profile` | ProfileScreen | Yes |

Splash screen gates navigation: listens to `authStateChanges`, waits for auth delivery, then routes to `/home` (or `/privacy-policy-required` if privacy not accepted) or `/login`.

## 5. Theme System

- **Light/Dark/High-contrast** themes via `AppTheme.light()` / `dark()` / `highContrast()`
- Theme mode persisted in Hive settings box (`theme_mode` key)
- Font size scaling via `MediaQuery.textScaler` (0.8–1.5 range)
- `ThemeNotifier` (Riverpod) manages theme mode + font size with persistence
- Material Design 3 (`useMaterial3: true`)

## 6. Form Handling & Validation

- `Form` + `GlobalKey<FormState>` pattern on all input screens
- Validators in `lib/core/utils/validators.dart`
- AppConstants provides min/max bounds (age 10-120, cycle 20-45, period 2-10)
- Password min length: 8

## 7. Local Storage

- **Hive 2.x** encrypted boxes (AES-256-GCM via `HiveAesCipher`)
- Key material in `flutter_secure_storage` (Android encrypted SharedPreferences)
- 5 boxes: profile, cycles, predictions, reminders, settings
- One-time migration from plaintext to encrypted boxes
- `StorageService` singleton with fail-closed key management

## 8. Accessibility

- Semantics labels on all interactive elements
- WCAG 2.1 AA contrast verified (theme_accessibility_test.dart)
- TalkBack/VoiceOver walkthrough completed (all 8 screens)
- Keyboard navigation (TAB/ENTER) verified
- 2.0x font scale tested (0 RenderFlex overflow)
- 48dp minimum touch targets

## 9. Error & Loading States

- `AppLoading` widget for async loading
- `EmptyState` widget for empty data
- `SnackBar` for transient errors
- `try/catch` around all service calls with `debugPrint` logging
- Fail-closed patterns in consent, storage, and auth

## 10. Key Dependencies (Frontend)

| Package | Version | Purpose |
|---------|---------|---------|
| flutter_riverpod | ^2.6.1 | State management |
| firebase_core | ^3.12.1 | Firebase init |
| firebase_auth | ^5.5.1 | Authentication |
| hive / hive_flutter | ^2.2.3 / ^1.1.0 | Local encrypted storage |
| flutter_secure_storage | ^9.2.4 | Key material storage |
| intl | ^0.20.2 | Date formatting |
| fl_chart | ^0.70.2 | Charts |
| table_calendar | ^3.2.0 | Calendar widget |
| flutter_local_notifications | ^18.0.1 | Reminders |
| share_plus | ^10.1.4 | Data export sharing |
| path_provider | ^2.1.5 | File paths |
| google_mobile_ads | ^9.1.0 | AdMob |
| google_sign_in | ^6.3.0 | Google OAuth |
| package_info_plus | ^9.0.1 | Runtime version |
| flutter_timezone | ^5.1.0 | Timezone for reminders |
| timezone | ^0.10.1 | Timezone data |

---

*See also: `docs/ARCHITECTURE.md`, `docs/DATABASE.md`, `docs/API_REFERENCE.md`*