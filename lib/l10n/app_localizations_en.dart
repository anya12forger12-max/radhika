// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Radhika';

  @override
  String get appTagline => 'Your Health Companion';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get privacyPolicyAcceptance => 'I accept the Privacy Policy';

  @override
  String get privacyPolicyRequired =>
      'You must accept the Privacy Policy to continue';

  @override
  String get home => 'Home';

  @override
  String get calendar => 'Calendar';

  @override
  String get education => 'Education';

  @override
  String get recommendations => 'Recommendations';

  @override
  String get reports => 'Reports';

  @override
  String get settings => 'Settings';

  @override
  String get profile => 'Profile';

  @override
  String get logPeriod => 'Log Period';

  @override
  String get logSymptom => 'Log Symptom';

  @override
  String get helpCenter => 'Help Center';

  @override
  String get sendFeedback => 'Send Feedback';

  @override
  String get about => 'About';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get deleteAllData => 'Delete All Data';

  @override
  String get exportData => 'Export Data';

  @override
  String get theme => 'Theme';

  @override
  String get fontSize => 'Font Size';

  @override
  String get notifications => 'Notifications';

  @override
  String get reminders => 'Reminders';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get systemMode => 'System';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get errorNetwork =>
      'No internet connection. Please check your network.';

  @override
  String get errorInvalidCredentials => 'Incorrect email or password.';

  @override
  String get errorWeakPassword => 'Password is too weak.';

  @override
  String get errorEmailAlreadyInUse =>
      'An account with this email already exists.';

  @override
  String get errorAccountExists =>
      'An account already exists with this email using a different sign-in method.';

  @override
  String get loading => 'Loading...';

  @override
  String get retry => 'Retry';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get confirm => 'Confirm';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get done => 'Done';

  @override
  String get skip => 'Skip';

  @override
  String get getStarted => 'Get Started';

  @override
  String get welcome => 'Welcome';

  @override
  String get understandingMenstruation => 'Understanding Menstruation';

  @override
  String get menstrualPads => 'Menstrual Pads';

  @override
  String get tampons => 'Tampons';

  @override
  String get menstrualCups => 'Menstrual Cups';

  @override
  String get healthAndWellness => 'Health & Wellness';

  @override
  String get painManagement => 'Pain Management';

  @override
  String get whenToSeeDoctor => 'When to See a Doctor';

  @override
  String get educationalPurposesOnly =>
      'This information is for educational purposes only. Always consult a healthcare provider for medical advice.';

  @override
  String get consultHealthcareProvider =>
      'Always consult a healthcare provider for persistent or severe symptoms.';

  @override
  String get thankYouFeedback =>
      'Thank you for your feedback. We\'ll review it.';

  @override
  String get feedbackMinChars =>
      'Please provide at least 10 characters of feedback.';

  @override
  String get rateLimitFeedback => 'Please wait 30 seconds between submissions.';
}
