# Radhika 🌸

**A Cross-Platform Menstrual Health Tracking Application**

Radhika is a meticulously engineered Flutter application designed for comprehensive menstrual health tracking, cycle analysis, and wellness guidance. The application serves as a personal health companion for women and menstruating individuals, facilitating precise cycle monitoring, symptom documentation, and evidence-based wellness recommendations.

## Executive Overview

Radhika implements a clean architecture pattern with repository-style data abstraction, Riverpod state management, and Firebase Authentication for secure access control. The application prioritizes user privacy through local data storage via Hive encryption, ensuring that all cycle data, symptoms, predictions, and reminders remain exclusively on the user's device. No health data is transmitted to external servers or synced to cloud infrastructure.

## Distinctive Features

### 📊 Advanced Cycle Tracking

- **Menstrual Period Logging**: Precise documentation of period start and end dates with configurable flow intensity metrics (quantified on a validated 1-5 scale)
- **Multivariate Symptom Tracking**: Comprehensive logging of over twenty distinct symptomatology categories including but not limited to: cramping, cephalalgia, mastodynia, backalgia, exhaustion, mood lability, and acne flare-ups
- **Calendar Integration**: Interactive monthly calendar visualization with cycle marker placement and retrospective analysis
- **Automatic Cycle Statistics**: Computation of cycle length, period duration, inter-menstrual interval, and luteal phase duration
- **Predictive Analytics**: Menstruation forecasting with confidence intervals based on historical data accumulation

### 🔮 Intelligent Predictive Models

- **Next Period Prediction**: Algorithmic estimation of subsequent menstruation date with probabilistic confidence scoring
- **Ovulation Window Estimation**: Fertile window prediction based on cycle regularity and symptothermal indicators
- **Cycle Health Scoring**: Quantitative assessment of cycle regularity, variability, and predicted gynaecological health status
- **Delay Analysis**: Evidence-based suggestions for cycle delay scenarios with reference to peer-reviewed literature

### 🔔 Intelligent Reminder Systems

- **Period Alerts**: Configurable push notifications preceding expected menstruation (adjustable lead time: 1-7 days)
- **Medication Administration Reminders**: Customizable dosing schedules for prescribed or over-the-counter therapeutics
- **Symptom Logging Prompts**: Timed reminders for periodic symptom documentation to ensure comprehensive data accumulation
- **Medication Interaction Alerts**: Pharmacovigilance-informed warnings regarding potential herb-drug or drug-drug interactions

### 📚 Comprehensive Educational Resource

- **Menstrual Health Encyclopedia**: Curated, evidence-based information on menstrual physiology, cycle disorders, and gynaecological health
- **Product Guidance**: Detailed comparisons and usage guidelines for menstrual products (pads, tampons, menstrual cups, period panties)
- **Wellness Recommendations**: Personalized lifestyle and dietary suggestions correlated with cycle phase
- **Pain Management Protocols**: Structured approaches to dysmenorrhea management with non-pharmacological and pharmacological options

### 📈 Advanced Analytics & Reporting

- **Monthly Cycle Summaries**: Comprehensive statistical overviews of cycle regularity, symptom frequency, and severity patterns
- **Symptom Frequency Charts**: Interactive visualizations of symptom occurrence across cycle phases
- **Comprehensive Cycle History**: Chronological record with detailed per-entry annotations and media attachment capability
- **Data Export Functionality**: Secure, GDPR-compliant export of cycle data in standardized formats (CSV, JSON) for external analysis or healthcare provider sharing

### 🎨 Aesthetic & Interface Design

- **Material Design 3 Implementation**: Adherence to Google's design system with dynamic color palettes
- **Theme System**: Light, Dark, and System-following automatic theme adaptation
- **Accessibility Compliance**: Full WCAG 2.1 AA compliance including screen reader compatibility (TalkBack/VoiceOver), semantic labeling, minimum 48dp touch targets, dynamic font scaling, high contrast modes, and keyboard navigation support
- **Animation Framework**: Subtle, purposeful motion design enhancing usability without compromising performance

### 🔒 Enterprise-Grade Privacy & Security Architecture

- **Local Data Sovereignty**: All health data persists exclusively on the device in encrypted Hive storage; zero cloud synchronization unless explicitly opted
- **Firebase Authentication**: Secure OAuth2-compliant authentication with Email/Password and Google Sign-In options
- **Mandatory Privacy Policy Acceptance**: Explicit, informed consent required prior to any data interaction
- **Data Isolation**: Complete segregation between user datasets; no cross-user data accessibility
- **Optional Account Deletion**: Secure, irreversible data eradication with verified confirmation protocols

### 🔬 Scientific & Methodological Rigor

- **Evidence-Based Methodology**: All wellness recommendations grounded in peer-reviewed medical literature
- **Clinically Validated Metrics**: Utilization of validated assessment instruments (e.g., Visual Analog Scale for pain, Modified Menstrual Distress Questionnaire items)
- **Data Privacy by Design**: Privacy-by-default architecture with granular user control over data sharing preferences

### 📈 Reporting & Export Capabilities

- **Monthly/Yearly Summaries**: Automated generation of cycle statistics and trend analysis
- **Symptom Frequency Visualizations**: Graphical representations of symptom occurrence and severity trends
- **Comprehensive Cycle History**: Chronological record with per-entry timestamps, symptom clusters, and predictive notes
- **Secure Data Export**: Encrypted export functionality with format selection (CSV for spreadsheet analysis, JSON for programmatic use)

### 🖥️ Platform & Technical Specifications

- **Cross-Platform Compatibility**: Native-like experience on iOS, Android, and desktop environments via Flutter framework
- **Android Version Support**: Android 7.0 (API level 24) and subsequent releases; optimized for Android 14 (API 34) and Android 15 (API 36)
- **State Management**: Riverpod 2.x reactive provider architecture with notifier pattern
- **Local Persistence**: Hive 2.x encrypted key-value storage with AES-256 encryption
- **Notification System**: flutter_local_notifications 5.x with scheduled wake and permission management
- **Charting Visualization**: fl_chart 0.70.x for interactive graphical representations
- **Calendar Widget**: table_calendar 3.1.x for month-level cycle visualization

### 🔐 Privacy & Compliance Framework

- **Data Minimization**: Collection limited to essential health metrics required for cycle tracking and prediction
- **Purpose Limitation**: Data used solely for cycle prediction, symptom tracking, and wellness guidance
- **Storage Limitation**: Information retained only for the duration necessary for stated purposes
- **User Rights**: Full rights of access, rectification, and erasure as per global data protection standards
- **Medical Disclaimer**: Explicit declaration that the application constitutes educational technology, not medical device software

### 📋 Installation & Deployment Requirements

**Prerequisites**:
- Flutter SDK (stable channel, version 3.22+)
- Firebase project configuration (Authentication only; Firestore intentionally excluded)
- Android Studio or VS Code with Flutter extension
- Administrator permissions for Android SDK installation

**Android Setup**:
1. Repository cloning via `git clone https://github.com/anya12forger12-max/radhika.git`
2. Dependency installation via `flutter pub get`
3. Firebase project creation and Email/Password + Google Sign-In enablement
4. `google-services.json` placement in `android/app/`
5. `flutter run` for development or `flutter build apk --release` for production deployment

**Build Artifacts**:
- Release APK: `build/app/outputs/flutter-apk/app-release.apk`
- Release AAB: `build/app/outputs/bundle/release/app-release.aab`

### 📲 Direct Mobile Installation (OTA APK Download)

If you want to install the release-signed production version of the Radhika application directly onto an Android device without building it from source code, you can download the compiled asset file straight from your mobile web browser.

**⚡ Quick Setup Instructions:**

1. **Get the Download Link:** Navigate to the [Releases](https://github.com/anya12forger12-max/radhika/releases) section of this repository on your mobile device.
2. **Download the Installer:** Under the latest verified production tag release, tap the **`app-release.apk`** hyperlink anchor file to download the lightweight package onto your internal device storage.
3. **Handle System Security Prompts:**
   - Open the downloaded file from your browser's history or notifications panel.
   - If Android blocks the package with a notification saying *"For security, your phone is not allowed to install unknown apps from this source,"* tap **Settings** directly in that dialog window.
   - Toggle the **"Allow from this source"** switch to **ON**.
4. **Complete Installation:** Go back to the installer, tap **Install**, and the Radhika application will load cleanly onto your phone's main home screen app drawer, with fully functional Firebase Authentication and local Hive storage encryption enabled out of the box.

*Note: The released binaries are cryptographically signed using our official release credentials (`anya-release-key-v2`). They map accurately to our restricted Firebase console configurations, ensuring total runtime stability.*

### 📜 Medical Disclaimer

> **This application provides educational information and cycle tracking functionality only. It is not a medical device, does not diagnose conditions, and is not a substitute for professional medical advice.** Always consult a qualified healthcare provider for medical concerns. The application clearly distinguishes between educational guidance and clinical advice, and never provides diagnoses or treatment recommendations.

### 📜 License

This project is licensed under the MIT License. Full license text available in the `LICENSE` file.

### 🙏 Acknowledgments

- Flutter engineering team for the revolutionary cross-platform framework
- Dart language design group for the optimized, sound-nullable language
- All contributors and testers who advanced the application's precision and reliability
- Medical professionals who reviewed educational content for scientific accuracy
- Hive encryption library team for local data security implementation

---

*Radhika: Empowering informed menstrual health through technology, education, and privacy.*

---
*Last updated: [Current Date]*
*Version: 1.2.31+36 (as per pubspec.yaml versioning)*