# Radhika

A cross-platform menstrual-cycle tracker that keeps health entries in encrypted on-device storage and uses Firebase only for sign-in.

Radhika is a Flutter app (version 1.2.32+37) for logging periods and symptoms, exploring cycle patterns, getting estimate-based predictions, and reading educational content. Cycle data lives in AES-encrypted Hive boxes whose key is kept in the platform keystore via `flutter_secure_storage`; Firebase Authentication handles accounts, while there is no Firestore dependency in this app.

## Features

- **Cycle and symptom logging** — start/end dates, flow intensity, spotting, pain level, mood, energy, sleep, exercise, water intake, free-text notes, and a symptom-only entry mode.
- **Calendar and history** — month view with cycle markers, a chronological history with favorites, and per-entry detail screens.
- **Estimates, not diagnoses** — average cycle/period length, next-period estimate, fertile-window and ovulation estimates, a confidence score derived from history size and variance, and a delay flag. See [`docs/SECURITY_ARCHITECTURE.md`](docs/SECURITY_ARCHITECTURE.md) and [`docs/DATA_FLOW.md`](docs/DATA_FLOW.md) for how the data is used.
- **Local reminders** — configurable notifications three, two, and one day before a period, or on the day, at a chosen time; also supports medication and symptom-logging reminders through `flutter_local_notifications`.
- **Education and recommendations** — static lessons on menstruation basics, pads, tampons, cups, wellness, and pain management, plus phase-aware recommendation screens.
- **Reports and export** — cycle statistics, symptom frequency and flow charts via `fl_chart`, and CSV/JSON export through `share_plus`.
- **Preferences and access** — light/dark/system themes, font scaling, reminder preferences, privacy-policy gate, Firebase email/password and Google sign-in, password reset, and account deletion.
- **Accessibility-minded UI** — semantic labels, text scaling, touch-target sizing, and theme contrast work are covered in [`docs/FEATURE_INVENTORY.md`](docs/FEATURE_INVENTORY.md) and [`test/unit/theme_accessibility_test.dart`](test/unit/theme_accessibility_test.dart).
- **Ad support with consent** — an AdMob banner is shown only after the UMP consent service reaches an allowed state.

## Quick start

Requirements: a Flutter SDK matching `sdk: ^3.12.2` in [`pubspec.yaml`](pubspec.yaml), plus a Firebase project with Email/Password and Google sign-in enabled.

```bash
git clone https://github.com/anya12forger12-max/radhika.git
cd radhika

flutter pub get
flutter run

# Checks and release artifacts
flutter test
flutter analyze
flutter build apk --release
flutter build appbundle --release
```

Add your own Firebase platform configuration (`google-services.json` / `GoogleService-Info.plist`) before building against your project. [`install.sh`](install.sh) runs `flutter pub get`; web builds use [`vercel_build.sh`](vercel_build.sh) and [`vercel.json`](vercel.json). Integration coverage includes [`integration_test/app_smoke_test.dart`](integration_test/app_smoke_test.dart), and published Android artifacts, if any, are listed in [GitHub Releases](https://github.com/anya12forger12-max/radhika/releases).

## Project structure

```text
lib/
├── main.dart / app.dart          # bootstrap and app shell
├── core/                         # constants, theme, utilities
├── data/models/                  # encrypted Hive model factories
├── models/                       # cycle entries, predictions, reminders, profile
├── providers/                    # auth, cycle, and theme state (Riverpod)
├── screens/                      # auth, tracking, calendar, education, reports, settings
├── services/                     # storage, prediction, notifications, ads, auth
└── widgets/                      # shared widgets and ad banner
docs/                             # architecture, privacy, security, and audit notes
test/ integration_test/           # unit, widget, and smoke tests
```

## Privacy and data flow

Cycle, symptom, and preference data is stored in app-private encrypted Hive boxes; the encryption key is generated on-device and stored through `flutter_secure_storage`. Authentication traffic goes to Firebase, crash diagnostics go to Crashlytics, and ads are served by AdMob after consent. No health data is sent to a Firestore backend by this codebase. Read [PRIVACY.md](PRIVACY.md), [PRIVACY_POLICY.md](PRIVACY_POLICY.md), and [TERMS_AND_CONDITIONS.md](TERMS_AND_CONDITIONS.md) for the full policy.

## Medical disclaimer

> Radhika provides general cycle information and tracking tools. It is **not** a medical device and does not diagnose, treat, or replace professional medical advice. Predictions are estimates based on your logs. Consult a qualified healthcare provider for medical concerns.

## License and credits

MIT License, Copyright (c) 2026 Radhika — see [`LICENSE`](LICENSE).

More documentation: [SECURITY.md](SECURITY.md), [CONTRIBUTING.md](CONTRIBUTING.md), [ONBOARDING.md](ONBOARDING.md), [CHANGELOG.md](CHANGELOG.md), and the [documentation index](docs).
