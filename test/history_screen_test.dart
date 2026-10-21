import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:radhika/models/cycle_entry.dart';
import 'package:radhika/screens/history/history_screen.dart';
import 'package:radhika/services/cycle_data_source.dart';
import 'package:radhika/services/cycle_repository.dart';

CycleEntry _entry({
  required String id,
  required DateTime startDate,
  bool isFavorite = false,
  String notes = '',
}) {
  return CycleEntry(
    id: id,
    userId: 'u1',
    startDate: startDate,
    flowIntensity: FlowIntensity.medium,
    mood: Mood.neutral,
    symptoms: const [],
    notes: notes,
    isFavorite: isFavorite,
  );
}

class FakeCycleDataSource implements CycleDataSource {
  final List<CycleEntry> _entries;
  int loadCalls = 0;
  bool shouldThrow = false;

  FakeCycleDataSource({List<CycleEntry> entries = const []})
      : _entries = List<CycleEntry>.from(entries);

  @override
  List<CycleEntry> getCycleEntries(String userId) {
    loadCalls++;
    if (shouldThrow) throw Exception('load failed');
    return List<CycleEntry>.from(_entries);
  }

  CycleEntry? _find(String entryId) {
    for (final entry in _entries) {
      if (entry.id == entryId) return entry;
    }
    return null;
  }

  @override
  CycleEntry? getCycleEntry(String entryId) => _find(entryId);

  @override
  Future<void> saveCycleEntry(CycleEntry entry) async {
    if (shouldThrow) throw Exception('save failed');
    final index = _entries.indexWhere((e) => e.id == entry.id);
    if (index == -1) {
      _entries.add(entry);
    } else {
      _entries[index] = entry;
    }
  }

  @override
  Future<void> deleteCycleEntry(String entryId) async {
    _entries.removeWhere((e) => e.id == entryId);
  }

  @override
  Future<void> toggleFavorite(String entryId) async {
    if (shouldThrow) throw Exception('toggle failed');
    final entry = _find(entryId);
    if (entry == null) return;
    final index = _entries.indexWhere((e) => e.id == entryId);
    _entries[index] = entry.copyWith(isFavorite: !entry.isFavorite);
  }
}

Widget _testWidget({
  required FakeCycleDataSource fake,
  required Widget page,
}) {
  return ProviderScope(
    overrides: [
      cycleDataSourceProvider.overrideWithValue(fake),
    ],
    child: MaterialApp(home: page),
  );
}

List<CycleEntry> _threeEntries() => [
  _entry(id: 'e1', startDate: DateTime(2026, 9, 1), isFavorite: true),
  _entry(id: 'e2', startDate: DateTime(2026, 9, 5), isFavorite: false),
  _entry(id: 'e3', startDate: DateTime(2026, 9, 10), isFavorite: true),
];

void main() {
  group('HistoryPage favorites filtering', () {
    testWidgets('loads all entries on entry when not favorites-only',
        (tester) async {
      final fake = FakeCycleDataSource(entries: _threeEntries());
      await tester.pumpWidget(_testWidget(
        fake: fake,
        page: const HistoryPage(userId: 'u1'),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Sep 1, 2026'), findsOneWidget);
      expect(find.text('Sep 5, 2026'), findsOneWidget);
      expect(find.text('Sep 10, 2026'), findsOneWidget);
      expect(fake.loadCalls, greaterThan(0));
    });

    testWidgets('shows only favorites when favoritesOnly is true',
        (tester) async {
      final fake = FakeCycleDataSource(entries: _threeEntries());
      await tester.pumpWidget(_testWidget(
        fake: fake,
        page: const HistoryPage(favoritesOnly: true, userId: 'u1'),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Sep 1, 2026'), findsOneWidget);
      expect(find.text('Sep 10, 2026'), findsOneWidget);
      expect(find.text('Sep 5, 2026'), findsNothing);
    });

    testWidgets('favorites chip toggles the filter', (tester) async {
      final fake = FakeCycleDataSource(entries: _threeEntries());
      await tester.pumpWidget(_testWidget(
        fake: fake,
        page: const HistoryPage(userId: 'u1'),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Sep 5, 2026'), findsOneWidget);

      final chip = find.byType(FilterChip).first;
      await tester.tap(chip);
      await tester.pumpAndSettle();

      expect(find.text('Sep 5, 2026'), findsNothing);
      expect(find.text('Sep 1, 2026'), findsOneWidget);
      expect(find.text('Sep 10, 2026'), findsOneWidget);

      await tester.tap(chip);
      await tester.pumpAndSettle();
      expect(find.text('Sep 5, 2026'), findsOneWidget);
    });

    testWidgets(
        'shows a favorites-aware empty state when no favorites exist',
        (tester) async {
      final testFake = FakeCycleDataSource(
        entries: [_entry(id: 'e2', startDate: DateTime(2026, 9, 5))],
      );
      await tester.pumpWidget(_testWidget(
        fake: testFake,
        page: const HistoryPage(favoritesOnly: true, userId: 'u1'),
      ));
      await tester.pumpAndSettle();

      expect(find.text('No favorite entries yet'), findsOneWidget);
      expect(find.text('Sep 5, 2026'), findsNothing);
    });

    testWidgets('toggling the star on an entry persists and re-filters',
        (tester) async {
      final fake = FakeCycleDataSource(entries: _threeEntries());
      await tester.pumpWidget(_testWidget(
        fake: fake,
        page: const HistoryPage(favoritesOnly: true, userId: 'u1'),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Sep 5, 2026'), findsNothing);

      final e1Row = find.ancestor(
        of: find.text('Sep 1, 2026').first,
        matching: find.byType(ListTile),
      );
      final star = find.descendant(
        of: e1Row,
        matching: find.byIcon(Icons.favorite),
      ).first;
      await tester.tap(star);
      await tester.pumpAndSettle();

      expect(find.text('Sep 1, 2026'), findsNothing);
      expect(find.text('Sep 10, 2026'), findsOneWidget);
      expect(fake.getCycleEntry('e1')?.isFavorite, isFalse);
    });
  });

  group('HistoryPage error and refresh', () {
    testWidgets('retry recovers after a load failure', (tester) async {
      final testFake = FakeCycleDataSource();
      testFake.shouldThrow = true;
      await tester.pumpWidget(_testWidget(
        fake: testFake,
        page: const HistoryPage(userId: 'u1'),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Unable to load history'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);

      testFake.shouldThrow = false;
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();

      expect(find.text('Unable to load history'), findsNothing);
    });

    testWidgets('pull-to-refresh reloads entries', (tester) async {
      final fake = FakeCycleDataSource(entries: _threeEntries());
      await tester.pumpWidget(_testWidget(
        fake: fake,
        page: const HistoryPage(userId: 'u1'),
      ));
      await tester.pumpAndSettle();

      final initialCalls = fake.loadCalls;

      await tester.drag(find.byType(ListView), const Offset(0, 300));
      await tester.pumpAndSettle();

      expect(fake.loadCalls, greaterThan(initialCalls));
    });
  });

  group('HistoryPage empty state', () {
    testWidgets('shows empty state when there are no entries',
        (tester) async {
      final testFake = FakeCycleDataSource();
      await tester.pumpWidget(_testWidget(
        fake: testFake,
        page: const HistoryPage(userId: 'u1'),
      ));
      await tester.pumpAndSettle();

      expect(find.text('No cycle history yet'), findsOneWidget);
    });
  });
}
