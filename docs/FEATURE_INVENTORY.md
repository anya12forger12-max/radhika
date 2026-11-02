# Radhika — Feature Inventory

**Version**: 1.2.32 (v1.2.32+37)
**Last Verified**: October 2026

## Core Features

### Authentication
| Feature | Status | Frontend | Backend | Database | Tests |
|---|---|---|---|---|---|
| Email/password sign-in | COMPLETE | LoginScreen | Firebase Auth | None (local) | auth_error_mapping_test.dart (13) |
| Email/password registration | COMPLETE | RegisterScreen | Firebase Auth | None (local) | auth_error_mapping_test.dart |
| Google Sign-In | COMPLETE | LoginScreen | Firebase Auth | None (local) | — |
| Password reset | COMPLETE | ForgotPasswordScreen | Firebase Auth | None (local) | — |
| Session persistence | COMPLETE | AuthService | Firebase Auth | None (local) | — |
| Account deletion | COMPLETE | ProfileScreen | Firebase Auth | Hive (local) | — |
| Privacy policy gate | COMPLETE | PrivacyPolicyScreen | None | Hive (settings) | — |

### Menstrual Tracking
| Feature | Status | Frontend | Backend | Database | Tests |
|---|---|---|---|---|---|
| Log period | COMPLETE | LogPeriodScreen | None | Hive (cycles_box) | widget_test.dart |
| Log symptoms | COMPLETE | LogSymptomScreen | None | Hive (cycles_box) | — |
| Cycle calendar | COMPLETE | CalendarScreen | None | Hive (cycles_box) | — |
| Cycle prediction | COMPLETE | CalendarScreen | None | Hive (predictions_box) | — |
| Cycle history | COMPLETE | HistoryScreen | None | Hive (cycles_box) | history_screen_test.dart |
| Delete all data | COMPLETE | SettingsScreen | None | Hive (all boxes) | — |

### Education
| Feature | Status | Frontend | Backend | Database | Tests |
|---|---|---|---|---|---|
| Menstruation basics | COMPLETE | EducationScreen | None | None (static) | content_inventory_test.dart |
| Pads guide | COMPLETE | PadGuideScreen | None | None (static) | content_inventory_test.dart |
| Tampons guide | COMPLETE | TamponGuideScreen | None | None (static) | content_inventory_test.dart |
| Cups guide | COMPLETE | CupGuideScreen | None | None (static) | content_inventory_test.dart |
| Health & Wellness | COMPLETE | EducationScreen | None | None (static) | content_inventory_test.dart |
| Pain Management | COMPLETE | EducationScreen | None | None (static) | content_inventory_test.dart |
| Recommendations | COMPLETE | RecommendationsScreen | None | Hive (cycles_box) | recommendation_service_test.dart (10) |

### Reports & Analytics
| Feature | Status | Frontend | Backend | Database | Tests |
|---|---|---|---|---|---|
| Cycle statistics | COMPLETE | ReportsScreen | None | Hive (cycles_box) | — |
| Data export (CSV/JSON) | COMPLETE | ReportsScreen | None | Hive (cycles_box) | — |
| Symptom frequency | COMPLETE | ReportsScreen | None | Hive (cycles_box) | — |
| Flow distribution | COMPLETE | ReportsScreen | None | Hive (cycles_box) | — |

### Settings & Preferences
| Feature | Status | Frontend | Backend | Database | Tests |
|---|---|---|---|---|---|
| Theme (light/dark/system) | COMPLETE | SettingsScreen | None | Hive (settings_box) | theme_accessibility_test.dart |
| Font size | COMPLETE | SettingsScreen | None | Hive (settings_box) | — |
| Reminder preferences | COMPLETE | SettingsScreen | None | Hive (reminders_box) | — |
| Notification scheduling | COMPLETE | NotificationService | None | Hive (reminders_box) | — |
| Account deletion | COMPLETE | ProfileScreen | Firebase Auth | Hive (all boxes) | — |
| Data export | COMPLETE | SettingsScreen | None | Hive (cycles_box) | — |

### Advertising
| Feature | Status | Frontend | Backend | Database | Tests |
|---|---|---|---|---|---|
| AdMob banner | COMPLETE | AdBanner widget | AdMob SDK | None | — |
| UMP consent | COMPLETE | AdConsentService | AdMob SDK | None | — |
| Consent fail-closed | COMPLETE | AdConsentService | AdMob SDK | None | — |

### Notifications
| Feature | Status | Frontend | Backend | Database | Tests |
|---|---|---|---|---|---|
| Period reminders | COMPLETE | NotificationService | None | Hive (reminders_box) | — |
| Medication reminders | COMPLETE | NotificationService | None | Hive (reminders_box) | — |
| Symptom logging prompts | COMPLETE | NotificationService | None | Hive (reminders_box) | — |

### Security
| Feature | Status | Frontend | Backend | Database | Tests |
|---|---|---|---|---|---|
| Encrypted storage (AES-256) | COMPLETE | StorageService | None | Hive + secure_storage | storage_integrity_test.dart |
| Hardcoded secret guard | COMPLETE | — | None | None | hardcoded_secret_source_test.dart |
| Crashlytics wired | COMPLETE | main.dart | Firebase | None | main_error_handler_test.dart |
| Source-order guard | COMPLETE | main.dart | None | None | main_error_handler_test.dart |

### Accessibility
| Feature | Status | Frontend | Backend | Database | Tests |
|---|---|---|---|---|---|
| Screen reader (TalkBack) | COMPLETE | All screens | None | None | theme_accessibility_test.dart |
| Text scaling | COMPLETE | AppTheme | None | None | theme_accessibility_test.dart |
| Color contrast (WCAG AA) | COMPLETE | AppTheme | None | None | theme_accessibility_test.dart |
| Touch targets (48dp) | COMPLETE | All screens | None | None | — |
| Keyboard navigation | COMPLETE | All screens | None | None | — |

## Status Definitions

- **COMPLETE**: Implemented, tested, and verified
- **PARTIALLY IMPLEMENTED**: Code exists but not fully tested
- **INCOMPLETE**: Started but not finished
- **NOT IMPLEMENTED**: Not present in codebase
- **NOT APPLICABLE**: Not relevant to this application
- **BLOCKED**: Cannot proceed without external resource
