import 'dart:ui' show PlatformDispatcher;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:radhika/app.dart';
import 'package:radhika/core/utils/error_handler.dart';
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
    errorHandler.reportError(e, context: 'reminder-reschedule');
    if (kDebugMode) debugPrint('Failed to reschedule reminders at startup: $e');
  }
}

/// Firebase configuration for the web build.
///
/// Mobile builds read the bundled `google-services.json` /
/// `GoogleService-Info.plist`. The web build has no such file, so the web
/// app credentials are supplied at build time via `--dart-define` (see
/// `vercel_build.sh`, which forwards the Vercel project environment
/// variables). When they are absent, `null` is returned and the app starts
/// signed-out with a clear message on the login screen instead of failing
/// to boot.
FirebaseOptions? _webFirebaseOptions() {
  if (!kIsWeb) return null;

  const apiKey = String.fromEnvironment('FIREBASE_API_KEY');
  const appId = String.fromEnvironment('FIREBASE_APP_ID');
  const messagingSenderId =
      String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID');
  const projectId = String.fromEnvironment('FIREBASE_PROJECT_ID');
  const authDomain = String.fromEnvironment('FIREBASE_AUTH_DOMAIN');
  const storageBucket = String.fromEnvironment('FIREBASE_STORAGE_BUCKET');

  if (apiKey.isEmpty ||
      appId.isEmpty ||
      messagingSenderId.isEmpty ||
      projectId.isEmpty) {
    return null;
  }

  return FirebaseOptions(
    apiKey: apiKey,
    appId: appId,
    messagingSenderId: messagingSenderId,
    projectId: projectId,
    authDomain:
        authDomain.isEmpty ? '$projectId.firebaseapp.com' : authDomain,
    storageBucket: storageBucket.isEmpty
        ? '$projectId.firebasestorage.app'
        : storageBucket,
  );
}

Future<ThemeModeSetting> _loadInitialTheme() async {
  try {
    await StorageService.instance.init();
    final themeStr = StorageService.instance.getSetting('theme_mode');
    final themeIndex = themeStr != null ? int.tryParse(themeStr) : null;
    return themeIndex != null &&
            themeIndex >= 0 &&
            themeIndex < ThemeModeSetting.values.length
        ? ThemeModeSetting.values[themeIndex]
        : ThemeModeSetting.system;
  } catch (e) {
    errorHandler.reportError(e, context: 'theme-load');
    if (kDebugMode) debugPrint('Failed to load initial theme: $e');
    return ThemeModeSetting.system;
  }
}

Future<void> main() async {
  final startupStopwatch = Stopwatch()..start();
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final webOptions = _webFirebaseOptions();
    if (webOptions != null) {
      await Firebase.initializeApp(options: webOptions);
    } else {
      await Firebase.initializeApp();
    }
  } catch (e) {
    errorHandler.reportError(e, context: 'firebase-init');
    if (kDebugMode) debugPrint('Failed to initialize Firebase: $e');
  }

  try {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    // Route uncaught Flutter framework errors to Crashlytics so they are
    // recorded as fatal events rather than only printed to the console.
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    // Route uncaught async/platform errors to Crashlytics as non-fatal
    // events (they may be recoverable) so they are still visible.
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: false);
      return true;
    };
  } catch (e) {
    errorHandler.reportError(e, context: 'crashlytics-init');
    if (kDebugMode) debugPrint('Crashlytics initialization failed: $e');
  }

  final initialTheme = await _loadInitialTheme();

  try {
    await NotificationService.instance.init();
  } catch (e) {
    errorHandler.reportError(e, context: 'notification-init');
    if (kDebugMode) debugPrint('Failed to initialize notifications: $e');
  }

  await _rescheduleStartupReminders();

  // Global error handler: capture uncaught framework/engine errors for
  // authorized diagnostics (debug log + Crashlytics), then preserve the
  // default console behavior.
  FlutterError.onError = (FlutterErrorDetails details) {
    errorHandler.reportError(
      details.exception,
      context: 'flutter-error',
      stackTrace: details.stack,
    );
    FlutterError.dumpErrorToConsole(details);
  };

  startupStopwatch.stop();
  if (kDebugMode) {
    debugPrint('Radhika startup completed in ${startupStopwatch.elapsedMilliseconds}ms');
  }

  runApp(
    ProviderScope(
      overrides: [
        initialThemeProvider.overrideWithValue(initialTheme),
      ],
      child: const RadhikaApp(),
    ),
  );
}
