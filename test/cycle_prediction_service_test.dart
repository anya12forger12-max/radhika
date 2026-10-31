import 'package:flutter_test/flutter_test.dart';
import 'package:radhika/models/cycle_entry.dart';
import 'package:radhika/models/cycle_prediction.dart';
import 'package:radhika/services/cycle_prediction_service.dart';

CycleEntry _entry({
  required DateTime start,
  DateTime? end,
  int painLevel = 0,
  List<Symptom> symptoms = const [],
  bool isSymptomOnly = false,
  int sleepHours = 7,
  bool exercise = false,
  int waterIntake = 4,
  FlowIntensity flowIntensity = FlowIntensity.medium,
}) {
  return CycleEntry(
    id: 'test-${start.millisecondsSinceEpoch}',
    userId: 'user-1',
    startDate: start,
    endDate: end,
    painLevel: painLevel,
    symptoms: symptoms,
    isSymptomOnly: isSymptomOnly,
    sleepHours: sleepHours,
    exercise: exercise,
    waterIntake: waterIntake,
    flowIntensity: flowIntensity,
  );
}

void main() {
  final service = CyclePredictionService();

  group('predictNextCycle', () {
    test('returns prediction with now() when no lastPeriodStart', () {
      final pred = service.predictNextCycle(
        userId: 'u1',
        cycleHistory: [],
        averageCycleLength: 28,
        averagePeriodLength: 5,
        lastPeriodStart: null,
      );
      expect(pred.userId, 'u1');
      expect(pred.predictedCycleLength, 28);
      // predicted start should be approximately now
      expect(pred.predictedStartDate.difference(DateTime.now()).inMinutes.abs(),
          lessThan(2));
    });

    test('predicts next start as lastPeriodStart + averageCycleLength', () {
      final last = DateTime(2026, 1, 1);
      final pred = service.predictNextCycle(
        userId: 'u1',
        cycleHistory: [],
        averageCycleLength: 28,
        averagePeriodLength: 5,
        lastPeriodStart: last,
      );
      expect(pred.predictedStartDate, last.add(const Duration(days: 28)));
      expect(pred.predictedEndDate,
          last.add(const Duration(days: 28 + 5)));
    });

    test('calculates ovulation and fertile window', () {
      final last = DateTime(2026, 1, 1);
      final pred = service.predictNextCycle(
        userId: 'u1',
        cycleHistory: [],
        averageCycleLength: 28,
        averagePeriodLength: 5,
        lastPeriodStart: last,
      );
      expect(pred.ovulationDate, isNotNull);
      expect(pred.fertileWindowStart, isNotNull);
      expect(pred.fertileWindowEnd, isNotNull);
      // ovulation = predictedStart - 14
      expect(pred.ovulationDate,
          pred.predictedStartDate.subtract(const Duration(days: 14)));
    });

    test('confidence is 0.3 with fewer than 2 entries', () {
      final pred = service.predictNextCycle(
        userId: 'u1',
        cycleHistory: [_entry(start: DateTime(2026, 1, 1))],
        averageCycleLength: 28,
        averagePeriodLength: 5,
        lastPeriodStart: DateTime(2026, 1, 1),
      );
      expect(pred.confidence, 0.3);
    });

    test('confidence is 0.5 with 2-3 entries', () {
      final history = [
        _entry(start: DateTime(2026, 1, 1)),
        _entry(start: DateTime(2025, 12, 4)),
      ];
      final pred = service.predictNextCycle(
        userId: 'u1',
        cycleHistory: history,
        averageCycleLength: 28,
        averagePeriodLength: 5,
        lastPeriodStart: DateTime(2026, 1, 1),
      );
      expect(pred.confidence, 0.5);
    });

    test('confidence is 0.7 with 4-5 entries', () {
      final history = List.generate(
          5, (i) => _entry(start: DateTime(2026, 1, 1).subtract(Duration(days: 28 * i))));
      final pred = service.predictNextCycle(
        userId: 'u1',
        cycleHistory: history,
        averageCycleLength: 28,
        averagePeriodLength: 5,
        lastPeriodStart: DateTime(2026, 1, 1),
      );
      expect(pred.confidence, 0.7);
    });

    test('confidence is 0.9 with 6+ entries and low variance', () {
      final history = List.generate(
          6, (i) => _entry(start: DateTime(2026, 1, 1).subtract(Duration(days: 28 * i))));
      final pred = service.predictNextCycle(
        userId: 'u1',
        cycleHistory: history,
        averageCycleLength: 28,
        averagePeriodLength: 5,
        lastPeriodStart: DateTime(2026, 1, 1),
      );
      expect(pred.confidence, 0.9);
    });

    test('isDelayed is true when predicted start is in the past and no active period', () {
      final last = DateTime(2025, 1, 1);
      final pred = service.predictNextCycle(
        userId: 'u1',
        cycleHistory: [],
        averageCycleLength: 28,
        averagePeriodLength: 5,
        lastPeriodStart: last,
      );
      expect(pred.isDelayed, isTrue);
    });
  });

  group('calculateAverageCycleLength', () {
    test('returns default (28) with fewer than 2 entries', () {
      expect(service.calculateAverageCycleLength([]), 28);
      expect(
          service.calculateAverageCycleLength([_entry(start: DateTime(2026, 1, 1))]),
          28);
    });

    test('calculates average from valid cycle lengths', () {
      final history = [
        _entry(start: DateTime(2026, 1, 1)),
        _entry(start: DateTime(2025, 12, 4)), // 28 days
        _entry(start: DateTime(2025, 11, 6)), // 28 days
      ];
      expect(service.calculateAverageCycleLength(history), 28);
    });

    test('filters out cycles shorter than minCycleLength', () {
      final history = [
        _entry(start: DateTime(2026, 1, 1)),
        _entry(start: DateTime(2025, 12, 30)), // 2 days (too short)
        _entry(start: DateTime(2025, 11, 6)), // 54 days (too long? no, 54 > 45)
      ];
      // Only the 28-day gap between Jan 1 and Nov 6... wait, that's 56 days
      // Actually: Jan 1 - Dec 30 = 2 days (filtered), Dec 30 - Nov 6 = 54 days (filtered, > 45)
      // So count = 0, returns default
      expect(service.calculateAverageCycleLength(history), 28);
    });

    test('returns default when all cycles are filtered out', () {
      final history = [
        _entry(start: DateTime(2026, 1, 1)),
        _entry(start: DateTime(2025, 12, 31)), // 1 day (too short)
      ];
      expect(service.calculateAverageCycleLength(history), 28);
    });
  });

  group('calculateAveragePeriodLength', () {
    test('returns default (5) with no completed entries', () {
      expect(service.calculateAveragePeriodLength([]), 5);
      expect(
          service.calculateAveragePeriodLength(
              [_entry(start: DateTime(2026, 1, 1))]),
          5);
    });

    test('calculates average from completed entries', () {
      final history = [
        _entry(start: DateTime(2026, 1, 1), end: DateTime(2026, 1, 5)), // 5 days
        _entry(start: DateTime(2025, 12, 1), end: DateTime(2025, 12, 6)), // 6 days
      ];
      expect(service.calculateAveragePeriodLength(history), 6); // (5+6)/2 = 5.5 → 6 (round)
    });

    test('excludes symptom-only entries? No — uses endDate != null', () {
      final history = [
        _entry(start: DateTime(2026, 1, 1), end: DateTime(2026, 1, 5)),
      ];
      expect(service.calculateAveragePeriodLength(history), 5);
    });
  });

  group('getCycleStatistics', () {
    test('returns empty list with no completed entries', () {
      expect(service.getCycleStatistics([]), isEmpty);
      expect(
          service.getCycleStatistics(
              [_entry(start: DateTime(2026, 1, 1))]),
          isEmpty);
    });

    test('returns 4 stat entries for completed cycles', () {
      final history = [
        _entry(start: DateTime(2026, 1, 1), end: DateTime(2026, 1, 5)),
        _entry(start: DateTime(2025, 12, 4), end: DateTime(2025, 12, 8)),
      ];
      final stats = service.getCycleStatistics(history);
      expect(stats.length, 4);
      expect(stats[0]['label'], 'Average Cycle');
      expect(stats[1]['label'], 'Average Period');
      expect(stats[2]['label'], 'Cycles Logged');
      expect(stats[3]['label'], 'Avg Pain Level');
    });

    test('excludes symptom-only entries', () {
      final history = [
        _entry(start: DateTime(2026, 1, 1), end: DateTime(2026, 1, 5), isSymptomOnly: true),
        _entry(start: DateTime(2025, 12, 4), end: DateTime(2025, 12, 8)),
      ];
      final stats = service.getCycleStatistics(history);
      // Only 1 completed non-symptom-only entry → isEmpty (needs 2 for cycle lengths)
      // Actually: completed has 1 entry (the symptom-only one is excluded), so completed.length=1, not empty
      // cycleLengths is empty (needs 2 entries), avgCycle = default 28
      expect(stats.length, 4);
      expect(stats[2]['value'], '1'); // 1 cycle logged
    });
  });

  group('getSymptomFrequency', () {
    test('returns empty map with no entries', () {
      expect(service.getSymptomFrequency([]), isEmpty);
    });

    test('counts symptom occurrences', () {
      final history = [
        _entry(start: DateTime(2026, 1, 1), symptoms: [Symptom.cramps, Symptom.headache]),
        _entry(start: DateTime(2025, 12, 4), symptoms: [Symptom.cramps]),
      ];
      final freq = service.getSymptomFrequency(history);
      expect(freq['cramps'], 2);
      expect(freq['headache'], 1);
    });

    test('sorts by frequency descending', () {
      final history = [
        _entry(start: DateTime(2026, 1, 1), symptoms: [Symptom.headache]),
        _entry(start: DateTime(2025, 12, 4), symptoms: [Symptom.cramps, Symptom.cramps]),
      ];
      final freq = service.getSymptomFrequency(history);
      final keys = freq.keys.toList();
      expect(keys.first, 'cramps');
    });
  });

  group('generateDelayAnalysis', () {
    test('returns generic suggestions for empty entries', () {
      final suggestions = service.generateDelayAnalysis([]);
      expect(suggestions, isNotEmpty);
      expect(suggestions, contains('Manage stress through relaxation techniques, meditation, or deep breathing.'));
    });

    test('includes sleep suggestion when avg sleep < 6', () {
      final history = [
        _entry(start: DateTime(2026, 1, 1), sleepHours: 5),
        _entry(start: DateTime(2025, 12, 4), sleepHours: 5),
      ];
      final suggestions = service.generateDelayAnalysis(history);
      expect(suggestions.any((s) => s.contains('sleep')), isTrue);
    });

    test('includes exercise suggestion when no exercise', () {
      final history = [
        _entry(start: DateTime(2026, 1, 1), exercise: false),
      ];
      final suggestions = service.generateDelayAnalysis(history);
      expect(suggestions.any((s) => s.contains('exercise')), isTrue);
    });

    test('includes hydration suggestion when avg water < 4', () {
      final history = [
        _entry(start: DateTime(2026, 1, 1), waterIntake: 2),
      ];
      final suggestions = service.generateDelayAnalysis(history);
      expect(suggestions.any((s) => s.contains('hydrated')), isTrue);
    });

    test('includes pain suggestion when avg pain > 3', () {
      final history = [
        _entry(start: DateTime(2026, 1, 1), painLevel: 4),
      ];
      final suggestions = service.generateDelayAnalysis(history);
      expect(suggestions.any((s) => s.contains('pain')), isTrue);
    });
  });
}