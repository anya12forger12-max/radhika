import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Source-level regression guards against hardcoded credentials (master-prompt
/// Phase 4/6: secret protection + automated secret-pattern checks).
///
/// Radhika's Firebase configuration enters the app through the native
/// Firebase init (`Firebase.initializeApp()` with no options), which resolves
/// via the google-services.json / GoogleService-Info.plist — so a Firebase API
/// key must never appear as a string literal in `lib/`. The same applies to any
/// hardcoded client secret / API key in other shapes. AdMob app and ad unit IDs
/// (`ca-app-pub-…`) are *public by design* and are intentionally NOT matched.
void main() {
  group('hardcoded secret source guards', () {
    final Directory libDir = Directory('lib');
    final List<File> libDartFiles = libDir
        .listSync()
        .whereType<File>()
        .where((File f) => f.path.endsWith('.dart'))
        .cast<File>()
        .toList(growable: false)
        .cast<File>()
        .toList();

    final RegExp firebaseKeyPattern = RegExp(r'AIza[A-Za-z0-9_\-]{8,}');
    final RegExp clientSecretPattern =
        RegExp(r'client[_-]?secret\s*[:=]\s*[^\s]+');

    test('lib/ contains no hardcoded Firebase API key literal', () {
      expect(libDartFiles, isNotEmpty,
          reason: 'the lib/ source scan must find at least the app sources');
      for (final File f in libDartFiles) {
        final String content = f.readAsStringSync();
        final Iterable<RegExpMatch> matches =
            firebaseKeyPattern.allMatches(content);
        expect(matches, isEmpty,
            reason: '${f.path} contains ${matches.length} hardcoded Firebase API key '
                'literal(s) — credentials must reach the app via native Firebase config, '
                'not source');
      }
    });

    test('lib/ contains no hardcoded client secret literal', () {
      for (final File f in libDartFiles) {
        final String content = f.readAsStringSync();
        final Iterable<RegExpMatch> matches =
            clientSecretPattern.allMatches(content);
        expect(matches, isEmpty,
            reason: '${f.path} contains ${matches.length} hardcoded client secret '
                'literal(s) — secrets must live in a secret store, not source');
      }
    });
  });
}
