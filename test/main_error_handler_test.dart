import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('main source-order regression guards', () {
    test('FirebaseCrashlytics init must come after Firebase.initializeApp()', () {
      const mainPath = 'lib/main.dart';
      final content = File(mainPath).readAsStringSync();

      final firebaseInitOffset = content.indexOf('Firebase.initializeApp()');
      final crashlyticsOffset = content.indexOf(
          'FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled');

      expect(firebaseInitOffset, isNot(-1),
          reason: 'Firebase.initializeApp() must be present in main.dart');
      expect(crashlyticsOffset, isNot(-1),
          reason: 'FirebaseCrashlytics.setCrashlyticsCollectionEnabled must be present in main.dart');
      expect(crashlyticsOffset, greaterThan(firebaseInitOffset),
          reason: 'Crashlytics must be initialized AFTER Firebase.initializeApp() succeeds, '
              'not before — calling setCrashlyticsCollectionEnabled on an uninitialized '
              'Firebase app throws [core/no-app] and crashes every launch');
    });
  });
}
