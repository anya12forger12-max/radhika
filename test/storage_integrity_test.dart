import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('radhika_hive_release');
    Hive.init(tempDir.path);
  });

  tearDown(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  group('Hive box integrity for v1.2.29 release', () {
    test('clean write reopens correctly', () async {
      final cipher = HiveAesCipher(Hive.generateSecureKey());
      final box = await Hive.openBox<String>(
        'release_clean',
        encryptionCipher: cipher,
      );
      await box.put('k1', 'v1');
      await Hive.close();

      final reopened = await Hive.openBox<String>(
        'release_clean',
        encryptionCipher: cipher,
      );
      expect(reopened.get('k1'), 'v1');
      expect(reopened.length, 1);
    });

    test('native recovery after mid-frame truncation', () async {
      final cipher = HiveAesCipher(Hive.generateSecureKey());
      final box = await Hive.openBox<String>(
        'release_damaged',
        encryptionCipher: cipher,
      );
      await box.put('k1', 'v1');
      await Hive.close();

      final file = File('${tempDir.path}/release_damaged.hive');
      final original = await file.readAsBytes();
      await file.writeAsBytes(original.sublist(0, original.length - 1));

      final reopened = await Hive.openBox<String>(
        'release_damaged',
        encryptionCipher: cipher,
      );
      expect(reopened.length, 0);
      expect(reopened.get('k1'), isNull);
    });
  });

  group('release source posture', () {
    test('no deleteBoxFromDisk in open-failure path', () {
      final source = File('lib/services/storage_service.dart').readAsStringSync();
      expect(source, isNot(contains('deleteBoxFromDisk(name)')));
      expect(source, isNot(contains('bytes: Uint8List(0)')));
    });
  });
}