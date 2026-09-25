# Changelog

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
