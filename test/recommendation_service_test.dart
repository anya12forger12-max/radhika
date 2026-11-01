import 'package:flutter_test/flutter_test.dart';

import 'package:radhika/models/cycle_entry.dart';
import 'package:radhika/services/recommendation_service.dart';

CycleEntry _entry({
  int daysAgo = 0,
  List<Symptom> symptoms = const [],
  int painLevel = 0,
  FlowIntensity flowIntensity = FlowIntensity.medium,
  bool spotting = false,
  String id = 'e',
}) {
  return CycleEntry(
    id: id,
    userId: 'u1',
    startDate: DateTime.now().subtract(Duration(days: daysAgo)),
    flowIntensity: flowIntensity,
    spotting: spotting,
    painLevel: painLevel,
    mood: Mood.neutral,
    symptoms: symptoms,
    notes: '',
  );
}

void main() {
  final service = RecommendationService();

  test('empty history returns a single general wellness recommendation', () {
    final result = service.build(entries: const []);
    expect(result.length, 1);
    expect(result.first.title, 'Healthy Cycle Habits');
    expect(result.first.isGeneral, isTrue);
    expect(result.first.reliefTips, isNotEmpty);
    expect(result.first.dietTips, isNotEmpty);
  });

  test('no symptoms logged returns only the general wellness card', () {
    final result = service.build(entries: [_entry(daysAgo: 2)]);
    expect(result.length, 1);
    expect(result.first.title, 'Healthy Cycle Habits');
  });

  test('logged symptoms produce matching cards in priority order', () {
    final result = service.build(
      entries: [
        _entry(
          daysAgo: 1,
          symptoms: const [Symptom.fatigue, Symptom.cramps],
        ),
      ],
    );
    final titles = result.map((r) => r.title).toList();
    expect(titles, contains('Cramps'));
    expect(titles, contains('Fatigue'));
    expect(titles.indexOf('Cramps'), lessThan(titles.indexOf('Fatigue')));
  });

  test('duplicate symptoms across days collapse into a single card', () {
    final result = service.build(
      entries: [
        _entry(daysAgo: 1, symptoms: const [Symptom.cramps], id: 'a'),
        _entry(daysAgo: 2, symptoms: const [Symptom.cramps], id: 'b'),
      ],
    );
    expect(result.where((r) => r.title == 'Cramps').length, 1);
  });

  test('high pain without pain symptoms adds a severe pain care card', () {
    final result = service.build(
      entries: [_entry(daysAgo: 1, painLevel: 4)],
    );
    expect(result.where((r) => r.title == 'Severe Pain Care').length, 1);
    expect(result.first.title, 'Severe Pain Care');
  });

  test('severe pain card is not duplicated when cramps are logged', () {
    final result = service.build(
      entries: [
        _entry(
          daysAgo: 1,
          painLevel: 5,
          symptoms: const [Symptom.cramps],
        ),
      ],
    );
    final titles = result.map((r) => r.title).toList();
    expect(titles, contains('Cramps'));
    expect(titles, isNot(contains('Severe Pain Care')));
    final cramps = result.firstWhere((r) => r.title == 'Cramps');
    expect(cramps.careNote, isNotNull);
  });

  test('entries outside the analysis window are ignored', () {
    final result = service.build(
      entries: [
        _entry(daysAgo: 45, symptoms: const [Symptom.cramps]),
      ],
    );
    expect(result.length, 1);
    expect(result.first.title, 'Healthy Cycle Habits');
  });

  test('heavy or spotting flow adds heavy flow support card', () {
    final result = service.build(
      entries: [_entry(daysAgo: 1, flowIntensity: FlowIntensity.heavy)],
    );
    expect(result.where((r) => r.title == 'Heavy Flow Support').length, 1);

    final spottingResult = service.build(
      entries: [_entry(daysAgo: 1, spotting: true)],
    );
    expect(
      spottingResult.where((r) => r.title == 'Heavy Flow Support').length,
      1,
    );
  });

  test('recommendation cards expose relief, diet, and hydration tips', () {
    final result = service.build(
      entries: [
        _entry(
          daysAgo: 1,
          symptoms: const [Symptom.anxiety, Symptom.bloating],
        ),
      ],
    );
    for (final recommendation in result) {
      expect(recommendation.reliefTips, isNotEmpty);
      expect(recommendation.dietTips, isNotEmpty);
      expect(recommendation.hydrationTips, isNotEmpty);
      expect(recommendation.iconKey, isNotEmpty);
    }
  });

  test('general wellness card exposes hydration tips', () {
    final result = service.build(entries: const []);
    expect(result.first.hydrationTips, isNotEmpty);
  });

  test('recommendation cards expose warning signs for symptoms', () {
    final result = service.build(
      entries: [
        _entry(
          daysAgo: 1,
          symptoms: const [Symptom.cramps],
        ),
      ],
    );
    final cramps = result.firstWhere((r) => r.title == 'Cramps');
    expect(cramps.warningSigns, isNotEmpty);
  });

  test('depression card carries a mental health care note', () {
    final result = service.build(
      entries: [
        _entry(daysAgo: 1, symptoms: const [Symptom.depression]),
      ],
    );
    final depression = result.firstWhere((r) => r.title == 'Depression');
    expect(depression.careNote, isNotNull);
    expect(depression.careNote!, contains('self-harm'));
  });

  test('general wellness fallback explains that no symptoms were logged', () {
    final result = service.build(entries: const []);
    expect(result.first.sourceNote, isNotNull);
    expect(result.first.sourceNote, contains('No symptoms logged'));
  });

  test('symptom cards explain they are based on logged symptoms', () {
    final result = service.build(
      entries: [
        _entry(daysAgo: 1, symptoms: const [Symptom.cramps]),
      ],
    );
    final cramps = result.firstWhere((r) => r.title == 'Cramps');
    expect(cramps.sourceNote, isNotNull);
    expect(cramps.sourceNote, contains('Based on symptoms you logged'));
  });

  test('severe pain card explains it came from logged symptoms', () {
    final result = service.build(
      entries: [_entry(daysAgo: 1, painLevel: 4)],
    );
    final severe = result.firstWhere((r) => r.title == 'Severe Pain Care');
    expect(severe.sourceNote, isNotNull);
    expect(severe.sourceNote, contains('Based on severe symptoms you logged'));
  });

  test('heavy flow card explains it came from logged flow', () {
    final result = service.build(
      entries: [_entry(daysAgo: 1, flowIntensity: FlowIntensity.heavy)],
    );
    final heavy = result.firstWhere((r) => r.title == 'Heavy Flow Support');
    expect(heavy.sourceNote, isNotNull);
    expect(heavy.sourceNote, contains('Based on heavy flow you logged'));
  });

  test('interest based educational picks explain their source', () {
    final result = service.build(
      entries: const [],
      interests: const ['hydration'],
    );
    expect(result.length, 1);
    expect(result.first.sourceNote, 'Based on your selected interests');
  });

  test('interest outside the allowlist is ignored', () {
    final result = service.build(
      entries: const [],
      interests: const ['not_a_real_interest'],
    );
    // Unknown interests are dropped (fail-closed) and fall back to
    // general wellness guidance.
    expect(result.length, 1);
    expect(result.first.title, 'Healthy Cycle Habits');
    expect(result.first.sourceNote, contains('No symptoms logged'));
  });

  test('general wellness card carries a care note and warning signs', () {
    final result = service.build(entries: const []);
    expect(result.first.careNote, isNotNull);
    expect(result.first.warningSigns, isNotEmpty);
  });

  test('bloating card carries a care note', () {
    final result = service.build(
      entries: [_entry(daysAgo: 1, symptoms: const [Symptom.bloating])],
    );
    final bloating = result.firstWhere((r) => r.title == 'Bloating');
    expect(bloating.careNote, isNotNull);
  });

  test('interests mapping to the same guidance pool collapse via dedupe', () {
    final result = service.build(
      entries: const [],
      interests: const ['pain', 'severe'],
    );
    expect(result.length, 1);
    expect(result.first.iconKey, 'severe_pain');
  });
}