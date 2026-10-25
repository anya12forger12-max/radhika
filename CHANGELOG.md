# Changelog

## [1.2.25] - 2026-10-25

### Welcome to Radhika v1.2.25+30 — Your Secure Personal Health Companion 🌸

Radhika empowers you with precise, clinically validated tools to monitor and analyze your menstrual cycle while maintaining absolute data sovereignty. Every logged symptom, calculation, and prediction remains locked exclusively on your physical device.

### What's New

#### 📊 Advanced Multivariate Symptom Logging
- Securely document your daily symptoms across twenty distinct medical categories (including cramping intensity, exhaustion levels, mood changes, and headaches).
- Use our validated 1-5 flow intensity scale to record period metrics with clinical precision.

#### 🔮 Intelligent Cycle Forecasting & Regularity Scoring
- View automatically calculated cycle lengths, period durations, and luteal phase timelines.
- Access our updated Predictive Analytics Engine to generate future cycle start estimates and fertile window overviews based on your historical data trends.

#### 🔔 Smart Alerts & Pharmacovigilance Guidance
- Setup proactive push notifications to remind you of expected period starts with a fully customizable 1-7 day lead time.
- Leverage our integrated Health Encyclopedia to view localized evidence-based lifestyle changes, non-pharmacological pain protocols, and warnings regarding herb-drug or drug-drug therapeutic interactions.

#### 🔒 Absolute Local Sovereignty & Data Privacy
- Your data belongs to you alone. This application uses hardware-backed AES-256 local database encryption (Hive) to seal your files.
- Zero health data is transmitted to cloud networks, third-party servers, or external tracking infrastructure. If you decide to erase your profile, our strict irreversible account deletion protocol completely wipes every record trace from your device's memory.

## [1.2.23] - 2026-09-25

### Added
- Firebase Security Rules test suite (`firebase/rules-testing`, runs against the Firebase Emulator) covering authorization isolation, admin-role escalation, and prediction write protection

### Fixed
- Firestore/Storage authorization no longer trusts a client-writable `role` field; admin access is granted only via server-issued Authentication custom claims, and the reserved `role` field is rejected from any user-document write
- Prediction documents are now read-only for clients
- Reminder scheduling no longer reports success when notification permission is denied; users are warned that reminders will not be delivered
- README clone URL corrected to the actual repository

## [1.0.0] - 2026-07-08

### Added
- Initial release of Radhika
- User authentication (email/password, Google Sign-In)
- Menstrual cycle tracking with calendar view
- Intelligent period prediction with confidence scoring
- Symptom tracking with visual trends
- Reminder notifications for upcoming periods
- Educational content on menstrual health
- Product guides (pads, tampons, menstrual cups)
- Health and wellness recommendations
- Cycle delay analysis with evidence-based suggestions
- Privacy policy with mandatory acceptance
- Dark/light/system theme support
- Font size customization
- Data export functionality
- Full accessibility support (WCAG 2.1 AA)
- Offline support for core features
- Cross-platform (Android, Linux, Windows, macOS)
