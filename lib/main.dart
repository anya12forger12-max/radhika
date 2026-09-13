import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:radhika/app.dart';
import 'package:radhika/services/notification_service.dart';
import 'package:radhika/services/storage_service.dart';

Future<void> _rescheduleStartupReminders() async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final storage = StorageService.instance;
    final prefs = storage.getReminderPreferences();
    if (!prefs.anyEnabled) return;
    final prediction = storage.getLatestPrediction(user.uid);
    if (prediction == null) return;
    await NotificationService.instance.reschedulePeriodReminders(
      prefs: prefs,
      predictedDate: prediction.predictedStartDate,
    );
  } catch (e) {
    debugPrint('Failed to reschedule reminders at startup: $e');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Failed to initialize Firebase: $e');
  }
  try {
    await StorageService.instance.init();
  } catch (e) {
    debugPrint('Failed to initialize storage: $e');
  }
  try {
    await NotificationService.instance.init();
  } catch (e) {
    debugPrint('Failed to initialize notifications: $e');
  }
  await _rescheduleStartupReminders();

  runApp(
    const ProviderScope(
      child: RadhikaApp(),
    ),
  );
}
