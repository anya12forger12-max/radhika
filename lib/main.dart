import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:radhika/app.dart';
import 'package:radhika/models/user_profile.dart';
import 'package:radhika/providers/theme_provider.dart';
import 'package:radhika/services/notification_service.dart';
import 'package:radhika/services/storage_service.dart';

Future<void> _rescheduleStartupReminders() async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final storage = StorageService.instance;
    final prefs = storage.getReminderPreferences(user.uid);
    if (!prefs.anyEnabled) return;
    final prediction = storage.getLatestPrediction(user.uid);
    if (prediction == null) return;
    await NotificationService.instance.reschedulePeriodReminders(
      prefs: prefs,
      predictedDate: prediction.predictedStartDate,
    );
  } catch (e) {
    if (kDebugMode) debugPrint('Failed to reschedule reminders at startup: $e');
  }
}

Future<ThemeModeSetting> _loadInitialTheme() async {
  try {
    await StorageService.instance.init();
    final prefs = StorageService.instance.getAppPreferences();
    return prefs.themeMode;
  } catch (e) {
    if (kDebugMode) debugPrint('Failed to load initial theme: $e');
    return ThemeModeSetting.system;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  try {
    await Firebase.initializeApp();
  } catch (e) {
    if (kDebugMode) debugPrint('Failed to initialize Firebase: $e');
  }

  final initialTheme = await _loadInitialTheme();

  try {
    await NotificationService.instance.init();
  } catch (e) {
    if (kDebugMode) debugPrint('Failed to initialize notifications: $e');
  }

  await _rescheduleStartupReminders();

  runApp(
    ProviderScope(
      overrides: [
        initialThemeProvider.overrideWithValue(initialTheme),
      ],
      child: const RadhikaApp(),
    ),
  );
}
