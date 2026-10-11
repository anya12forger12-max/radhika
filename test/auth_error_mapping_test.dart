import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:radhika/providers/auth_provider.dart';

void main() {
  group('mapAuthErrorCode — sign-in paths mask account-sensitive codes', () {
    test('user-not-found stays masked', () {
      expect(mapAuthErrorCode('user-not-found'), 'Invalid email or password');
    });

    test('wrong-password stays masked', () {
      expect(mapAuthErrorCode('wrong-password'), 'Invalid email or password');
    });

    test('invalid-credential stays masked', () {
      expect(mapAuthErrorCode('invalid-credential'), 'Invalid email or password');
    });

    test('email-already-in-use is masked on sign-in (default)', () {
      expect(mapAuthErrorCode('email-already-in-use'), 'Invalid email or password');
    });
  });

  group('mapAuthErrorCode — registration discloses the real reason', () {
    test('email-already-in-use on registration tells the user to sign in', () {
      expect(
        mapAuthErrorCode('email-already-in-use', isRegistration: true),
        'An account with this email already exists. Please sign in instead',
      );
    });

    test('email-already-in-use registration message is not the masked one', () {
      expect(
        mapAuthErrorCode('email-already-in-use', isRegistration: true),
        isNot('Invalid email or password'),
      );
    });
  });

  group('mapAuthErrorCode — account-exists is always disclosed', () {
    test('account-exists-with-different-credential gets a distinct message', () {
      expect(
        mapAuthErrorCode('account-exists-with-different-credential'),
        'This email is already registered with a different sign-in method',
      );
    });

    test('account-exists is disclosed even when isRegistration is false', () {
      expect(
        mapAuthErrorCode('account-exists-with-different-credential',
            isRegistration: false),
        isNot('Invalid email or password'),
      );
    });
  });

  group('mapAuthErrorCode — other codes are unchanged', () {
    test('invalid-email', () {
      expect(mapAuthErrorCode('invalid-email'), 'Invalid email address');
    });

    test('weak-password', () {
      expect(mapAuthErrorCode('weak-password'), 'Password is too weak');
    });

    test('unknown code falls back', () {
      expect(
        mapAuthErrorCode('something-else'),
        'Authentication failed. Please try again',
      );
    });
  });

  group('wiring — registerWithEmail forwards isRegistration: true', () {
    // The mapping above is only effective if the registration path actually
    // asks for the registration wording. This guard pins the call site so a
    // future refactor cannot silently re-mask the sign-up error.
    late String source;

    setUpAll(() {
      source = File('lib/providers/auth_provider.dart').readAsStringSync();
    });

    test('exactly one call passes isRegistration: true', () {
      final matches =
          RegExp(r'_mapFirebaseError\([^)]*isRegistration:\s*true[^)]*\)')
              .allMatches(source);
      expect(matches, hasLength(1));
    });

    test('the registration call sits inside registerWithEmail', () {
      final start = source.indexOf('Future<void> registerWithEmail');
      final end = source.indexOf('Future<void> signInWithGoogle');
      expect(start, isNonNegative);
      expect(end, greaterThan(start));

      final body = source.substring(start, end);
      expect(
        RegExp(r'_mapFirebaseError\([^)]*isRegistration:\s*true[^)]*\)')
            .hasMatch(body),
        isTrue,
      );
    });
  });
}
