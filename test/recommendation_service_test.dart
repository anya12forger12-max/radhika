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

  test('recommendation cards expose relief and diet tips', () {
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
      expect(recommendation.iconKey, isNotEmpty);
    }
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
}