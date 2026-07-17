import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:radhika/core/theme/app_theme.dart';
import 'package:radhika/providers/theme_provider.dart';
import 'package:radhika/screens/auth/forgot_password_screen.dart';
import 'package:radhika/screens/auth/login_screen.dart';
import 'package:radhika/screens/auth/register_screen.dart';
import 'package:radhika/screens/calendar/calendar_screen.dart';
import 'package:radhika/screens/education/education_screen.dart';
import 'package:radhika/screens/education/product_guides/cup_guide_screen.dart';
import 'package:radhika/screens/education/product_guides/pad_guide_screen.dart';
import 'package:radhika/screens/education/product_guides/tampon_guide_screen.dart';
import 'package:radhika/screens/home/home_screen.dart';
import 'package:radhika/screens/profile/profile_screen.dart';
import 'package:radhika/screens/reports/reports_screen.dart';
import 'package:radhika/screens/settings/privacy_policy_screen.dart';
import 'package:radhika/screens/settings/settings_screen.dart';
import 'package:radhika/screens/splash/splash_screen.dart';
import 'package:radhika/screens/tracking/log_period_screen.dart';
import 'package:radhika/screens/tracking/log_symptom_screen.dart';

class RadhikaApp extends ConsumerWidget {
  const RadhikaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final fontSize = themeState.fontSize;

    return MaterialApp(
      title: 'Radhika',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeState.themeMode,
      builder: (context, child) {
        final mediaQueryData = MediaQuery.of(context);
        final scale = mediaQueryData.textScaleFactor * fontSize;
        return MediaQuery(
          data: mediaQueryData.copyWith(textScaleFactor: scale),
          child: child!,
        );
      },
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/home': (context) => const HomeScreen(),
        '/calendar': (context) => const CalendarScreen(),
        '/log-period': (context) => const LogPeriodScreen(),
        '/log-symptom': (context) => const LogSymptomScreen(),
        '/education': (context) => const EducationScreen(),
        '/pad-guide': (context) => const PadGuideScreen(),
        '/tampon-guide': (context) => const TamponGuideScreen(),
        '/cup-guide': (context) => const CupGuideScreen(),
        '/reports': (context) => const ReportsScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/privacy-policy': (context) => const PrivacyPolicyScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
