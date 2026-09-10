class AppConstants {
  AppConstants._();

  static const String appName = 'Radhika';
  static const String appVersion = '1.0.0';
  static const String privacyPolicyUrl =
      'https://raw.githubusercontent.com/anya12forger12-max/radhika/main/PRIVACY.md';
  static const String privacyPolicyVersion = '1.1.0';

  static const int minPasswordLength = 8;
  static const int minAge = 10;
  static const int maxAge = 120;
  static const int defaultCycleLength = 28;
  static const int defaultPeriodLength = 5;
  static const int minCycleLength = 20;
  static const int maxCycleLength = 45;
  static const int minPeriodLength = 2;
  static const int maxPeriodLength = 10;
  static const int ovulationDayOffset = 14;
  static const int fertileWindowStart = 10;
  static const int fertileWindowEnd = 17;

  static const String privacyPolicyText = '''
PRIVACY POLICY

Last updated: September 2026

1. Introduction
Radhika ("we", "our", "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, and safeguard your personal information.

2. Information We Collect
We collect only the minimum information necessary for menstrual cycle tracking and prediction:
- Name or nickname
- Age
- Height and weight (optional)
- Cycle-related data (period dates, symptoms, flow intensity)
- Optional medical information you choose to share
We do not sell your personal information to anyone, including advertisers.

3. How We Use Your Information
- To provide accurate cycle predictions
- To send reminders you request
- To improve application functionality
- For customer support when you contact us

4. Data Privacy & Security
- Your data belongs solely to you
- No user can view another user's personal information
- Your health information is private and encrypted
- Only the application administrator may access stored data when required for maintenance, legal compliance, security, or user-requested support
- Data will never be shared with other users
- All data is encrypted during transmission and storage
- Industry-standard security measures protect your information

5. Data Retention
We retain your data only as long as necessary to provide our services. You may request deletion of your account and associated data at any time.

6. Your Rights
- Access your personal data
- Request data correction or deletion
- Export your data
- Withdraw consent at any time
- Delete your account permanently

7. Advertising and Advertising IDs
Radhika is a free app supported by advertising served by Google AdMob. AdMob may use your device advertising identifier (Advertising ID) to display and measure ads and to prevent fraud.
- We do not sell your personal or health data to advertisers.
- You may see personalized or non-personalized ads. You can opt out of personalized advertising at any time in your device settings (Android: Settings > Privacy > Ads > "Delete advertising ID") and in Google Ads Settings (adssettings.google.com).
- Google's data practices are governed by Google's Privacy Policy (policies.google.com/privacy).
- Where required by law, a consent dialog is shown before personalized ads are served.

8. Third-Party Services
We use Google Firebase for authentication and secure data storage, and Google AdMob for advertising. These services comply with GDPR and other applicable privacy regulations and have their own privacy policies.

9. Children's Privacy
Radhika is not intended for children under 13 and we do not knowingly collect information from anyone under 13. If you believe a child has provided us personal information, contact us and we will delete it.

10. Changes to This Policy
We may update this policy. Users will be notified of material changes and must accept the updated policy to continue using the application.

11. Contact
For questions about this policy, open an issue at github.com/anya12forger12-max/radhika/issues or contact the application administrator.
''';

  static const String medicalDisclaimer =
      'This application provides educational information only and is not a substitute for professional medical advice. Always consult a qualified healthcare provider for medical concerns.';

  static const String predictionDisclaimer =
      'Predictions are estimates based on your logged data. Individual cycles may vary. This information should not be used as a sole method of contraception or fertility planning without medical supervision.';

  static const String cycleDelayMessage =
      'Your cycle appears later than expected. Many factors such as stress, illness, travel, or lifestyle changes may affect menstrual timing. If your period is significantly delayed, unusually heavy, very painful, or if you have concerns, please consult a qualified healthcare professional.';
}
