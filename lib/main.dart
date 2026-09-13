import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:radhika/app.dart';
import 'package:radhika/services/notification_service.dart';
import 'package:radhika/services/storage_service.dart';

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

  runApp(
    const ProviderScope(
      child: RadhikaApp(),
    ),
  );
}
