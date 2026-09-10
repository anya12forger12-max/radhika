import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:radhika/app.dart';
import 'package:radhika/services/notification_service.dart';
import 'package:radhika/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await MobileAds.instance.initialize();
  await StorageService.instance.init();
  await NotificationService.instance.init();

  runApp(
    const ProviderScope(
      child: RadhikaApp(),
    ),
  );
}
