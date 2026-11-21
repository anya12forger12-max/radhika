import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Regression guards for the startup diagnostics and account-cleanup fixes.
void main() {
  group('startup diagnostics', () {
    test('global FlutterError handler records fatal errors to Crashlytics', () {
      final src = File('lib/main.dart').readAsStringSync();
      expect(
        src,
        contains('recordFlutterFatalError(details)'),
        reason: 'the final FlutterError.onError handler must not discard the '
            'Crashlytics fatal-error recording installed earlier in main()',
      );
    });

    test('platform errors are recorded as non-fatal', () {
      final src = File('lib/main.dart').readAsStringSync();
      expect(src, contains('recordError(error, stack, fatal: false)'));
    });
  });

  group('account data cleanup', () {
    test('clearUserData removes every user-owned record', () {
      final src = File('lib/services/storage_service.dart').readAsStringSync();
      final start = src.indexOf('Future<void> clearUserData(String userId)');
      expect(start, isNot(-1));
      final body = src.substring(start);
      for (final box in [
        '_cycles.delete',
        '_predictions.delete',
        '_reminders.delete',
        '_profile.delete',
        '_settings.delete',
      ]) {
        expect(body, contains(box), reason: '$box must be cleared');
      }
    });

    test('AppPreferences box is registered and opened at startup', () {
      final src = File('lib/services/storage_service.dart').readAsStringSync();
      expect(src, contains('Hive.registerAdapter(AppPreferencesAdapter())'));
      expect(src, contains('Hive.openBox<AppPreferences>('));
    });
  });
}
