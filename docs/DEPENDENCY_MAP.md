# Radhika — Dependency Map

**Version**: 1.2.32 (v1.2.32+37)
**Last Verified**: October 2026

## 1. Direct Dependencies (pubspec.yaml)

| Package | Version | Purpose | Used In |
|---|---|---|---|
| flutter | sdk | UI framework | All screens |
| flutter_riverpod | ^2.6.1 | State management | All providers, screens |
| firebase_core | ^3.12.1 | Firebase initialization | main.dart |
| firebase_auth | ^5.5.1 | Authentication | auth_provider, auth_service |
| firebase_crashlytics | ^4.3.10 | Crash reporting | main.dart |
| hive | ^2.2.3 | Local database | storage_service.dart |
| hive_flutter | ^1.1.0 | Hive Flutter integration | storage_service.dart |
| flutter_secure_storage | ^9.2.4 | Secure key storage | storage_service.dart |
| intl | ^0.20.2 | Internationalization | date formatting |
| fl_chart | ^0.70.2 | Charts | reports_screen.dart |
| flutter_local_notifications | ^18.0.1 | Notifications | notification_service.dart |
| share_plus | ^10.1.4 | Data export | reports_screen.dart |
| path_provider | ^2.1.5 | File paths | storage_service.dart |
| google_sign_in | ^6.3.0 | Google OAuth | auth_provider.dart |
| google_mobile_ads | ^9.1.0 | Advertising | ad_banner.dart, ad_consent_service.dart |
| flutter_timezone | ^5.1.0 | Timezone detection | notification_service.dart |
| timezone | ^0.10.1 | Timezone data | notification_service.dart |
| table_calendar | ^3.2.1 | Calendar widget | calendar_screen.dart |
| flutter_animate | ^4.5.2 | Animations | various screens |
| package_info_plus | ^9.0.1 | App version info | settings_screen.dart |
| hive_generator | ^2.0.1 | Code generation | build-time only |
| build_runner | ^2.4.13 | Code generation | build-time only |

## 2. Dev Dependencies

| Package | Version | Purpose |
|---|---|---|
| flutter_test | sdk | Unit/widget testing |
| integration_test | sdk | Integration testing |
| flutter_lints | ^4.0.0 | Linting rules |

## 3. Removed Dependencies (Dependency Sweep)

The following were removed in a dependency sweep (verified zero-import across lib/ and test/):

| Package | Reason Removed |
|---|---|
| cupertino_icons | Unused (Material icons used instead) |
| riverpod | Replaced by flutter_riverpod |
| cloud_firestore | Firebase-Auth-only app (no Firestore SDK) |
| permission_handler | Not used (permissions requested via platform channels) |
| flutter_svg | No SVG assets |
| cached_network_image | No network images |
| pdf | Reports use share_plus instead |
| printing | Reports use share_plus instead |
| csv | Reports use share_plus instead |
| shimmer | Not used |
| animate_do | Replaced by flutter_animate |

## 4. Android Native Dependencies

| Dependency | Source | Purpose |
|---|---|---|
| firebase-auth | Firebase BOM | Authentication |
| firebase-crashlytics | Firebase BOM | Crash reporting |
| google-services plugin | Gradle plugin | Firebase config processing |

## 5. Key Dependency Relationships

```
storage_service.dart
  ├── hive (Box, HiveAesCipher)
  ├── hive_flutter (Hive.initFlutter)
  ├── flutter_secure_storage (key storage)
  ├── path_provider (app documents dir)
  └── models/* (adapters)

auth_provider.dart
  ├── firebase_auth (FirebaseAuth)
  ├── google_sign_in (GoogleSignIn)
  └── storage_service (user profile)

notification_service.dart
  ├── flutter_local_notifications (plugin)
  ├── flutter_timezone (timezone detection)
  └── timezone (tz data)

app.dart
  ├── flutter/material (MaterialApp)
  ├── flutter_riverpod (ProviderScope)
  ├── app_theme (light/dark themes)
  └── theme_provider (initial theme)
```

## 6. Compatibility Requirements

| Requirement | Value |
|---|---|
| Dart SDK | ^3.12.2 |
| Flutter | 3.47.x (tested) |
| Android minSdk | 24 (Android 7.0) |
| Android targetSdk | 36 (Android 15) |
| Android compileSdk | 36 |
| iOS | Not actively tested |
