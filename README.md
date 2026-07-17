# Radhika 🌸

**Your Personal Menstrual Health Companion**

Radhika is a cross-platform menstrual health tracking application built with Flutter. It helps women and menstruating individuals track their cycles, understand their menstrual health, receive educational guidance, and obtain evidence-based wellness advice.

## Features

### 📊 Cycle Tracking
- Log period start/end dates with flow intensity
- Track symptoms, mood, pain, sleep, exercise, and more
- Calendar view with cycle markers
- Automatic cycle statistics

### 🔮 Smart Predictions
- Predict next period date with confidence score
- Estimate ovulation and fertile window
- Predictions improve with more data
- Cycle delay analysis with evidence-based suggestions

### 🔔 Reminders
- Customizable notifications before expected period
- Daily medication reminders
- Symptom logging reminders

### 📚 Education
- Comprehensive menstrual health information
- Detailed product guides (pads, tampons, menstrual cups)
- Health and wellness recommendations
- Pain management guidance

### 📈 Reports
- Monthly and yearly summaries
- Symptom frequency charts
- Cycle history with detailed view
- Data export

### 🎨 Design
- Modern, minimalistic Material Design 3 interface
- Light, Dark, and System themes
- Adjustable font size
- Smooth animations
- Full WCAG 2.1 AA accessibility compliance

### 🔒 Privacy & Security
- End-to-end encrypted data storage
- Secure Firebase Authentication
- Mandatory privacy policy acceptance
- User data belongs solely to the user
- No cross-user data access
- Optional account deletion

## Screenshots

*(Add screenshots here)*

## Architecture

```
lib/
├── core/           # Theme, constants, utilities, routing
├── models/         # Data models (UserProfile, CycleEntry, etc.)
├── services/       # Business logic (Auth, Storage, Predictions, Notifications)
├── providers/      # Riverpod state management
├── screens/        # UI screens organized by feature
│   ├── splash/
│   ├── auth/
│   ├── home/
│   ├── calendar/
│   ├── tracking/
│   ├── education/
│   ├── reports/
│   ├── settings/
│   └── profile/
└── widgets/        # Reusable UI components
```

**Pattern**: Clean Architecture with Repository Pattern
**State Management**: Riverpod
**Backend**: Firebase (Auth, Firestore, Storage)
**Local Storage**: Hive

## Installation

### Prerequisites
- Flutter SDK (latest stable)
- Firebase account
- Android Studio / VS Code

### Android
```bash
# Clone the repository
git clone https://github.com/anyaforger123456/radhika.git
cd radhika

# Install dependencies
flutter pub get

# Set up Firebase
# 1. Create a Firebase project at https://console.firebase.google.com
# 2. Enable Authentication (Email/Password + Google Sign-In)
# 3. Create a Firestore database
# 4. Download google-services.json and place in android/app/
# 5. Run the app
flutter run
```

### Windows
```bash
# Same setup as above, then:
flutter config --enable-windows-desktop
flutter run -d windows
```

### Linux
```bash
# Same setup as above, then:
flutter config --enable-linux-desktop
sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev
flutter run -d linux
```

### macOS
```bash
# Same setup as above, then:
flutter config --enable-macos-desktop
flutter run -d macos
```

## Build Instructions

### Android (APK)
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Android (App Bundle)
```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

### Windows
```bash
flutter build windows --release
# Output: build/windows/runner/Release/
```

### Linux
```bash
flutter build linux --release
# Output: build/linux/x64/release/bundle/
```

### macOS
```bash
flutter build macos --release
# Output: build/macos/Build/Products/Release/
```

## Firebase Setup

1. Create a Firebase project
2. Enable Authentication methods:
   - Email/Password
   - Google Sign-In
3. Create Firestore database (start in test mode, then apply rules)
4. Enable Firebase Storage
5. Register Android, iOS, and desktop apps
6. Download and add config files:
   - Android: `google-services.json` → `android/app/`
   - iOS: `GoogleService-Info.plist` → `ios/Runner/`
   - Desktop: Use Firebase Admin SDK or REST API

## Firestore Security Rules

Apply the rules in `firestore.rules` to secure your database.

## Technology Stack

| Component | Technology |
|-----------|-----------|
| Framework | Flutter 3.44+ |
| Language | Dart 3.12+ |
| Architecture | Clean Architecture |
| State Management | Riverpod |
| Authentication | Firebase Auth |
| Database | Cloud Firestore |
| Local Storage | Hive |
| Notifications | flutter_local_notifications |
| Charts | fl_chart |
| Calendar | table_calendar |
| PDF Export | pdf, printing |

## Accessibility

Radhika is designed to be fully accessible:
- Screen reader support (TalkBack/VoiceOver)
- Semantic labels on all controls
- Minimum 48x48dp touch targets
- Dynamic font scaling
- High contrast support
- Keyboard navigation
- WCAG 2.1 AA compliance

## Medical Disclaimer

> This application provides educational information only and is not a substitute for professional medical advice. Always consult a qualified healthcare provider for medical concerns. The app never diagnoses conditions and clearly distinguishes between educational guidance and medical advice.

## FAQ

**Q: Is my data private?**
A: Yes. Your data belongs solely to you. No other user can access your information. Only the application administrator may access data for maintenance or support, with strict controls.

**Q: Does the app work offline?**
A: Yes. Core features like logging periods, viewing history, predictions, and education content work offline.

**Q: Is this a medical device?**
A: No. Radhika is an educational and tracking tool. It does not diagnose, treat, or prevent any medical condition.

**Q: Can I export my data?**
A: Yes. You can export your cycle data from Settings.

**Q: How do I delete my account?**
A: Go to Settings → Delete Account. This permanently removes your data.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support, contact the repository administrator through GitHub issues.

## Acknowledgments

- Flutter team for the amazing framework
- All contributors and testers
- Medical professionals who reviewed educational content
