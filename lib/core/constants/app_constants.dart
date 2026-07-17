class AppConstants {
  AppConstants._();

  static const String appName = 'Radhika';
  static const String appVersion = '1.0.0';
  static const String privacyPolicyVersion = '1.0.0';

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

Last updated: July 2026

1. Introduction
Radhika ("we", "our", "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, and safeguard your personal information.

2. Information We Collect
We collect only the minimum information necessary for menstrual cycle tracking and prediction:
- Name or nickname
- Age
- Height and weight (optional)
- Cycle-related data (period dates, symptoms, flow intensity)
- Optional medical information you choose to share

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

7. Third-Party Services
We use Firebase (Google) for authentication and secure data storage. Firebase complies with GDPR and other privacy regulations.

8. Changes to This Policy
We may update this policy. Users will be notified of material changes and must accept the updated policy to continue using the application.

9. Contact
For questions about this policy, contact the application administrator.
''';

  static const String medicalDisclaimer =
      'This application provides educational information only and is not a substitute for professional medical advice. Always consult a qualified healthcare provider for medical concerns.';

  static const String predictionDisclaimer =
      'Predictions are estimates based on your logged data. Individual cycles may vary. This information should not be used as a sole method of contraception or fertility planning without medical supervision.';

  static const String cycleDelayMessage =
      'Your cycle appears later than expected. Many factors such as stress, illness, travel, or lifestyle changes may affect menstrual timing. If your period is significantly delayed, unusually heavy, very painful, or if you have concerns, please consult a qualified healthcare professional.';
}
