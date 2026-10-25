import 'package:flutter_test/flutter_test.dart';
import 'package:radhika/data/models/secure_model_factory.dart';
import 'package:radhika/models/cycle_entry.dart';
import 'package:radhika/models/reminder.dart';

void main() {
  group('DeserializationSecurityException', () {
    test('is an Exception', () {
      const e = DeserializationSecurityException('boom');
      expect(e, isA<Exception>());
      expect(e.toString(), contains('boom'));
    });
  });

  group('validateAndResolveType', () {
    test('resolves allowlisted markers', () {
      expect(validateAndResolveType('userProfile'),
          AuthorizedModelType.userProfile);
      expect(validateAndResolveType('cycleEntry'),
          AuthorizedModelType.cycleEntry);
      expect(validateAndResolveType('cyclePrediction'),
          AuthorizedModelType.cyclePrediction);
      expect(validateAndResolveType('reminder'), AuthorizedModelType.reminder);
    });

    test('throws on null marker', () {
      expect(() => validateAndResolveType(null),
          throwsA(isA<DeserializationSecurityException>()));
    });

    test('throws on empty marker', () {
      expect(() => validateAndResolveType(''),
          throwsA(isA<DeserializationSecurityException>()));
    });

    test('throws on unknown marker', () {
      expect(() => validateAndResolveType('evilClass'),
          throwsA(isA<DeserializationSecurityException>()));
    });

    test('throws on tampered marker', () {
      expect(() => validateAndResolveType('admin'),
          throwsA(isA<DeserializationSecurityException>()));
    });
  });

  group('safeEnumFromIndex', () {
    test('returns value at valid index', () {
      expect(safeEnumFromIndex<FlowIntensity>(FlowIntensity.values, 2),
          FlowIntensity.medium);
    });

    test('returns fallback on null', () {
      expect(safeEnumFromIndex<FlowIntensity>(FlowIntensity.values, null,
          fallback: 1), FlowIntensity.light);
    });

    test('throws on negative index', () {
      expect(
          () => safeEnumFromIndex<FlowIntensity>(FlowIntensity.values, -1),
          throwsA(isA<DeserializationSecurityException>()));
    });

    test('throws on out-of-range index', () {
      expect(
          () => safeEnumFromIndex<FlowIntensity>(
              FlowIntensity.values, FlowIntensity.values.length + 5),
          throwsA(isA<DeserializationSecurityException>()));
    });

    test('throws on tampered huge index', () {
      expect(
          () => safeEnumFromIndex<FlowIntensity>(FlowIntensity.values, 999999),
          throwsA(isA<DeserializationSecurityException>()));
    });
  });

  group('safeEnumFromIndexOrThrow', () {
    test('returns value at valid index', () {
      expect(safeEnumFromIndexOrThrow<Mood>(Mood.values, 2), Mood.neutral);
    });

    test('throws on null', () {
      expect(() => safeEnumFromIndexOrThrow<Mood>(Mood.values, null),
          throwsA(isA<DeserializationSecurityException>()));
    });

    test('throws on out-of-range', () {
      expect(
          () => safeEnumFromIndexOrThrow<Mood>(Mood.values, 999),
          throwsA(isA<DeserializationSecurityException>()));
    });
  });

  group('CycleEntry.fromMap enum hardening', () {
    Map<String, dynamic> baseMap() => <String, dynamic>{
          'userId': 'u1',
          'startDate': DateTime(2024, 1, 1).millisecondsSinceEpoch,
        };

    test('defaults flowIntensity/mood on missing fields', () {
      final e = CycleEntry.fromMap(baseMap(), 'id1');
      expect(e.flowIntensity, FlowIntensity.light);
      expect(e.mood, Mood.neutral);
      expect(e.symptoms, isEmpty);
    });

    test('throws on out-of-range flowIntensity', () {
      final m = baseMap()..['flowIntensity'] = 999;
      expect(() => CycleEntry.fromMap(m, 'id1'),
          throwsA(isA<DeserializationSecurityException>()));
    });

    test('throws on out-of-range mood', () {
      final m = baseMap()..['mood'] = -1;
      expect(() => CycleEntry.fromMap(m, 'id1'),
          throwsA(isA<DeserializationSecurityException>()));
    });

    test('throws on out-of-range symptom index', () {
      final m = baseMap()..['symptoms'] = <int>[0, 999];
      expect(() => CycleEntry.fromMap(m, 'id1'),
          throwsA(isA<DeserializationSecurityException>()));
    });

    test('throws on non-int symptom entry', () {
      final m = baseMap()..['symptoms'] = <dynamic>['headache'];
      expect(() => CycleEntry.fromMap(m, 'id1'),
          throwsA(isA<DeserializationSecurityException>()));
    });

    test('accepts valid symptom indices', () {
      final m = baseMap()..['symptoms'] = <int>[0, 2, 5];
      final e = CycleEntry.fromMap(m, 'id1');
      expect(e.symptoms, <Symptom>[
        Symptom.headache,
        Symptom.acne,
        Symptom.depression,
      ]);
    });
  });

  group('Reminder.fromMap enum hardening', () {
    test('defaults type on missing field', () {
      final r = Reminder.fromMap(<String, dynamic>{'userId': 'u1'}, 'r1');
      expect(r.type, ReminderType.periodReminder3Days);
    });

    test('throws on out-of-range type', () {
      expect(
          () => Reminder.fromMap(
              <String, dynamic>{'userId': 'u1', 'type': 999}, 'r1'),
          throwsA(isA<DeserializationSecurityException>()));
    });

    test('throws on negative type', () {
      expect(
          () => Reminder.fromMap(
              <String, dynamic>{'userId': 'u1', 'type': -3}, 'r1'),
          throwsA(isA<DeserializationSecurityException>()));
    });
  });

  group('SecureModelFactory', () {
    test('routes cycleEntry to CycleEntry.fromMap', () {
      final m = <String, dynamic>{
        'userId': 'u1',
        'startDate': DateTime(2024, 2, 2).millisecondsSinceEpoch,
      };
      final obj = SecureModelFactory.create('cycleEntry', m, 'cid');
      expect(obj, isA<CycleEntry>());
    });

    test('rejects unknown type indicator before construction', () {
      expect(
          () => SecureModelFactory.create(
              'MaliciousClass', <String, dynamic>{}, 'x'),
          throwsA(isA<DeserializationSecurityException>()));
    });
  });
}