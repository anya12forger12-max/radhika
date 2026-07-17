import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:radhika/providers/cycle_provider.dart';
import 'package:radhika/models/cycle_entry.dart';
import 'package:radhika/models/cycle_prediction.dart';

enum _CycleMarker { period, predictedPeriod, fertileWindow, ovulation }

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    final cycleState = ref.watch(cycleProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final entries = cycleState.cycleHistory;
    final prediction = cycleState.currentPrediction;

    final markers = _buildMarkers(entries, prediction);
    final selectedDayEvents = markers[_selectedDay] ?? [];
    final monthEntries = _entriesForMonth(entries, _focusedDay);

    return Scaffold(
      appBar: AppBar(
        title: Semantics(
          label: 'Calendar',
          child: const Text('Calendar'),
        ),
      ),
      body: Column(
        children: [
          _buildCalendar(theme, colorScheme, markers),
          if (selectedDayEvents.isNotEmpty)
            _buildSelectedDayDetails(theme, colorScheme, _selectedDay, selectedDayEvents, entries),
          const SizedBox(height: 8),
          _buildMonthEntriesList(theme, colorScheme, monthEntries),
          _buildStatisticsBar(theme, colorScheme, entries),
        ],
      ),
      floatingActionButton: Semantics(
        label: 'Add new period entry',
        button: true,
        child: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, '/log-period'),
          tooltip: 'Add period entry',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Map<DateTime, List<_CycleMarker>> _buildMarkers(
    List<CycleEntry> entries,
    CyclePrediction? prediction,
  ) {
    final markers = <DateTime, List<_CycleMarker>>{};

    void addMarker(DateTime date, _CycleMarker marker) {
      final key = DateTime(date.year, date.month, date.day);
      markers.putIfAbsent(key, () => []);
      if (!markers[key]!.contains(marker)) {
        markers[key]!.add(marker);
      }
    }

    for (final entry in entries) {
      if (entry.endDate == null) continue;
      var day = DateTime(entry.startDate.year, entry.startDate.month, entry.startDate.day);
      final end = DateTime(entry.endDate!.year, entry.endDate!.month, entry.endDate!.day);
      while (!day.isAfter(end)) {
        addMarker(day, _CycleMarker.period);
        day = day.add(const Duration(days: 1));
      }
    }

    if (prediction != null) {
      var day = DateTime(
        prediction.predictedStartDate.year,
        prediction.predictedStartDate.month,
        prediction.predictedStartDate.day,
      );
      final end = DateTime(
        prediction.predictedEndDate.year,
        prediction.predictedEndDate.month,
        prediction.predictedEndDate.day,
      );
      while (!day.isAfter(end)) {
        addMarker(day, _CycleMarker.predictedPeriod);
        day = day.add(const Duration(days: 1));
      }

      if (prediction.fertileWindowStart != null && prediction.fertileWindowEnd != null) {
        var d = DateTime(
          prediction.fertileWindowStart!.year,
          prediction.fertileWindowStart!.month,
          prediction.fertileWindowStart!.day,
        );
        final fEnd = DateTime(
          prediction.fertileWindowEnd!.year,
          prediction.fertileWindowEnd!.month,
          prediction.fertileWindowEnd!.day,
        );
        while (!d.isAfter(fEnd)) {
          addMarker(d, _CycleMarker.fertileWindow);
          d = d.add(const Duration(days: 1));
        }
      }

      if (prediction.ovulationDate != null) {
        addMarker(prediction.ovulationDate!, _CycleMarker.ovulation);
      }
    }

    return markers;
  }

  Widget _buildCalendar(
    ThemeData theme,
    ColorScheme colorScheme,
    Map<DateTime, List<_CycleMarker>> markers,
  ) {
    return Semantics(
      label: 'Cycle calendar',
      child: TableCalendar<_CycleMarker>(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        calendarFormat: _calendarFormat,
        onFormatChanged: (format) {
          setState(() => _calendarFormat = format);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        onPageChanged: (focusedDay) {
          setState(() => _focusedDay = focusedDay);
        },
        eventLoader: (day) => markers[DateTime(day.year, day.month, day.day)] ?? [],
        calendarBuilders: CalendarBuilders<_CycleMarker>(
          markerBuilder: (context, date, markers) {
            if (markers.isEmpty) return const SizedBox.shrink();
            return Semantics(
              label: _markerSemantics(markers),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: markers.map((m) {
                  return Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _markerColor(m),
                    ),
                  );
                }).toList(),
              ),
            );
          },
          selectedBuilder: (context, date, today) {
            return Container(
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${date.day}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            );
          },
          todayBuilder: (context, date, today) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: colorScheme.primary, width: 2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${date.day}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            );
          },
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: true,
          titleCentered: true,
          formatButtonSemanticLabel: 'Change calendar view',
          titleTextStyle: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          leftChevronIcon: Semantics(
            label: 'Previous month',
            button: true,
            child: const Icon(Icons.chevron_left),
          ),
          rightChevronIcon: Semantics(
            label: 'Next month',
            button: true,
            child: const Icon(Icons.chevron_right),
          ),
        ),
        calendarStyle: CalendarStyle(
          cellMargin: const EdgeInsets.all(4),
          todayDecoration: BoxDecoration(
            border: Border.all(color: colorScheme.primary, width: 2),
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          todayTextStyle: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          selectedTextStyle: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  String _markerSemantics(List<_CycleMarker> markers) {
    final labels = markers.map((m) {
      switch (m) {
        case _CycleMarker.period:
          return 'period day';
        case _CycleMarker.predictedPeriod:
          return 'predicted period day';
        case _CycleMarker.fertileWindow:
          return 'fertile window';
        case _CycleMarker.ovulation:
          return 'ovulation day';
      }
    }).toList();
    return 'Markers: ${labels.join(', ')}';
  }

  Color _markerColor(_CycleMarker marker) {
    switch (marker) {
      case _CycleMarker.period:
        return Colors.red;
      case _CycleMarker.predictedPeriod:
        return Colors.pink;
      case _CycleMarker.fertileWindow:
        return Colors.purple;
      case _CycleMarker.ovulation:
        return Colors.blue;
    }
  }

  Widget _buildSelectedDayDetails(
    ThemeData theme,
    ColorScheme colorScheme,
    DateTime day,
    List<_CycleMarker> markers,
    List<CycleEntry> entries,
  ) {
    final entry = _entryForDay(entries, day);
    final dateStr = DateFormat('EEEE, MMMM d, yyyy').format(day);

    return Semantics(
      label: 'Details for $dateStr',
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        elevation: 0,
        color: colorScheme.surfaceContainerHigh,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(dateStr, style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              )),
              const SizedBox(height: 8),
              if (entry != null && _isInRange(entry, day))
                _buildEntryDetail(theme, colorScheme, entry, day)
              else if (markers.contains(_CycleMarker.ovulation))
                Text('Ovulation Day', style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ))
              else if (markers.contains(_CycleMarker.fertileWindow))
                Text('Fertile Window', style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.purple,
                  fontWeight: FontWeight.w600,
                ))
              else if (markers.contains(_CycleMarker.predictedPeriod))
                Text('Predicted Period Day', style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.pink,
                  fontWeight: FontWeight.w600,
                ))
              else
                Text('No events', style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                )),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 300.ms),
    );
  }

  bool _isInRange(CycleEntry entry, DateTime day) {
    if (entry.endDate == null) return false;
    final d = DateTime(day.year, day.month, day.day);
    final start = DateTime(entry.startDate.year, entry.startDate.month, entry.startDate.day);
    final end = DateTime(entry.endDate!.year, entry.endDate!.month, entry.endDate!.day);
    return !d.isBefore(start) && !d.isAfter(end);
  }

  CycleEntry? _entryForDay(List<CycleEntry> entries, DateTime day) {
    for (final entry in entries) {
      if (entry.endDate != null && _isInRange(entry, day)) return entry;
    }
    return null;
  }

  Widget _buildEntryDetail(ThemeData theme, ColorScheme colorScheme, CycleEntry entry, DateTime day) {
    final flowLabels = {
      FlowIntensity.veryLight: 'Very Light',
      FlowIntensity.light: 'Light',
      FlowIntensity.medium: 'Medium',
      FlowIntensity.heavy: 'Heavy',
      FlowIntensity.veryHeavy: 'Very Heavy',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.water_drop, color: Colors.red.shade400, size: 18),
            const SizedBox(width: 6),
            Text('Period Day', style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.red.shade700,
            )),
          ],
        ),
        const SizedBox(height: 6),
        _detailRow(theme, 'Flow', flowLabels[entry.flowIntensity] ?? 'Medium'),
        if (entry.spotting) _detailRow(theme, 'Spotting', 'Yes'),
        _detailRow(theme, 'Pain Level', '${entry.painLevel}/5'),
        if (entry.mood != Mood.neutral) _detailRow(theme, 'Mood', entry.mood.name),
        if (entry.symptoms.isNotEmpty)
          _detailRow(theme, 'Symptoms', entry.symptoms.map((s) => s.name).join(', ')),
      ],
    );
  }

  Widget _detailRow(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            )),
          ),
          Expanded(
            child: Text(value, style: theme.textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

  List<CycleEntry> _entriesForMonth(List<CycleEntry> entries, DateTime month) {
    return entries.where((e) {
      return e.startDate.year == month.year && e.startDate.month == month.month;
    }).toList()
      ..sort((a, b) => b.startDate.compareTo(a.startDate));
  }

  Widget _buildMonthEntriesList(ThemeData theme, ColorScheme colorScheme, List<CycleEntry> entries) {
    if (entries.isEmpty) {
      return const SizedBox.shrink();
    }

    final monthStr = DateFormat('MMMM yyyy').format(_focusedDay);

    return Expanded(
      child: Semantics(
        label: 'Cycle entries for $monthStr',
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final entry = entries[index];
            return _buildEntryTile(theme, colorScheme, entry, index);
          },
        ),
      ),
    );
  }

  Widget _buildEntryTile(ThemeData theme, ColorScheme colorScheme, CycleEntry entry, int index) {
    final dateFormat = DateFormat('MMM d');
    return Semantics(
      label: 'Cycle entry starting ${dateFormat.format(entry.startDate)}',
      child: Card(
        elevation: 0,
        color: colorScheme.surfaceContainerHigh,
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.water_drop, color: colorScheme.onPrimaryContainer, size: 20),
          ),
          title: Text(
            'Started ${dateFormat.format(entry.startDate)}',
            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            '${entry.duration} days · ${entry.flowIntensity.name} flow${entry.painLevel > 0 ? ' · Pain: ${entry.painLevel}/5' : ''}',
            style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          trailing: Semantics(
            label: 'View entry details',
            button: true,
            child: IconButton(
              icon: Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
              tooltip: 'View details',
              onPressed: () => Navigator.pushNamed(context, '/cycle-detail', arguments: entry.id),
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms, delay: (50 * index).ms);
  }

  Widget _buildStatisticsBar(ThemeData theme, ColorScheme colorScheme, List<CycleEntry> entries) {
    final completed = entries.where((e) => e.endDate != null).toList();
    final sorted = List<CycleEntry>.from(completed)
      ..sort((a, b) => a.startDate.compareTo(b.startDate));

    final cycleLengths = <int>[];
    for (int i = 1; i < sorted.length; i++) {
      cycleLengths.add(sorted[i].startDate.difference(sorted[i - 1].startDate).inDays);
    }

    final avgCycle = cycleLengths.isNotEmpty
        ? cycleLengths.reduce((a, b) => a + b) ~/ cycleLengths.length
        : 28;
    final avgPeriod = completed.isNotEmpty
        ? completed.map((e) => e.duration).reduce((a, b) => a + b) ~/ completed.length
        : 5;
    final cyclesLogged = completed.length;

    return Semantics(
      label: 'Cycle statistics - Average cycle $avgCycle days, average period $avgPeriod days, $cyclesLogged cycles logged',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHigh,
          border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
        ),
        child: Row(
          children: [
            _statItem(theme, colorScheme, '$avgCycle', 'Avg Cycle', 'days'),
            _statDivider(colorScheme),
            _statItem(theme, colorScheme, '$avgPeriod', 'Avg Period', 'days'),
            _statDivider(colorScheme),
            _statItem(theme, colorScheme, '$cyclesLogged', 'Cycles', 'logged'),
          ],
        ),
      ),
    );
  }

  Widget _statItem(ThemeData theme, ColorScheme colorScheme, String value, String label, String unit) {
    return Expanded(
      child: Semantics(
        label: '$label: $value $unit',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value, style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            )),
            const SizedBox(height: 2),
            Text(label, style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            )),
            Text(unit, style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            )),
          ],
        ),
      ),
    );
  }

  Widget _statDivider(ColorScheme colorScheme) {
    return Container(
      width: 1,
      height: 32,
      color: colorScheme.outlineVariant,
    );
  }
}
