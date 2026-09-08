import 'package:flutter_test/flutter_test.dart';

import 'package:radhika/models/cycle_entry.dart';

void main() {
  test('cycle entry duration uses inclusive day count', () {
    final start = DateTime(2026, 9, 1);
    final end = DateTime(2026, 9, 5);
    final entry = CycleEntry(
      id: 'test-1',
      userId: 'u1',
      startDate: start,
      endDate: end,
      flowIntensity: FlowIntensity.medium,
      mood: Mood.good,
      symptoms: const [],
      notes: '',
    );
    expect(entry.duration, 5);
  });

  test('cycle entry without end date has zero duration', () {
    final entry = CycleEntry(
      id: 'test-2',
      userId: 'u1',
      startDate: DateTime(2026, 9, 1),
      flowIntensity: FlowIntensity.light,
      mood: Mood.good,
      symptoms: const [],
      notes: '',
    );
    expect(entry.duration, 0);
  });
}