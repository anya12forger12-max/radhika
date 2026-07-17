import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:radhika/models/cycle_entry.dart';
import 'package:radhika/providers/cycle_provider.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _exportData() async {
    final state = ref.read(cycleProvider);
    final buffer = StringBuffer();
    buffer.writeln('Radhika Cycle Data Export');
    buffer.writeln('Date: ${DateFormat.yMd().format(DateTime.now())}');
    buffer.writeln('---');
    for (final entry in state.cycleHistory) {
      buffer.writeln(
        'Start: ${DateFormat.yMd().format(entry.startDate)} | '
        'Duration: ${entry.duration}d | '
        'Flow: ${entry.flowIntensity.name} | '
        'Pain: ${entry.painLevel}/5 | '
        'Symptoms: ${entry.symptoms.map((s) => s.name).join(', ')}',
      );
    }
    await Share.share(buffer.toString(), subject: 'Radhika Cycle Data');
  }

  Future<void> _deleteEntry(CycleEntry entry) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Entry'),
        content: Text(
          'Delete cycle entry from ${DateFormat.yMd().format(entry.startDate)}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(cycleProvider.notifier).deleteCycleEntry(entry.id);
    }
  }

  void _showEntryDetails(CycleEntry entry) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(80),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              DateFormat.yMMMd().format(entry.startDate),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _detailRow(Icons.calendar_today, 'Duration', '${entry.duration} days'),
            _detailRow(
              Icons.water_drop,
              'Flow',
              entry.flowIntensity.name.replaceAllMapped(
                RegExp(r'[A-Z]'),
                (m) => ' ${m.group(0)}',
              ).trim(),
            ),
            _detailRow(Icons.healing, 'Pain Level', '${entry.painLevel}/5'),
            _detailRow(
              Icons.mood,
              'Mood',
              entry.mood.name.replaceAllMapped(
                RegExp(r'[A-Z]'),
                (m) => ' ${m.group(0)}',
              ).trim(),
            ),
            if (entry.spotting)
              _detailRow(Icons.fiber_manual_record, 'Spotting', 'Yes'),
            if (entry.symptoms.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Symptoms: ${entry.symptoms.map((s) => s.name.replaceAllMapped(RegExp(r'[A-Z]'), (m) => ' ${m.group(0)}')).join(', ')}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            if (entry.notes.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Notes: ${entry.notes}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cycleState = ref.watch(cycleProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        actions: [
          Semantics(
            label: 'Export cycle data',
            child: IconButton(
              icon: const Icon(Icons.share),
              onPressed: _exportData,
              tooltip: 'Export data',
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Monthly'),
            Tab(text: 'Yearly'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _MonthlyTab(entries: cycleState.cycleHistory),
          _YearlyTab(entries: cycleState.cycleHistory),
          _HistoryTab(
            entries: cycleState.cycleHistory,
            onTap: _showEntryDetails,
            onDelete: _deleteEntry,
          ),
        ],
      ),
    );
  }
}

class _MonthlyTab extends StatelessWidget {
  final List<CycleEntry> entries;

  const _MonthlyTab({required this.entries});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final completed = entries.where((e) => e.endDate != null).toList();

    if (completed.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bar_chart, size: 64, color: theme.colorScheme.onSurfaceVariant.withAlpha(100)),
            const SizedBox(height: 16),
            Text(
              'No cycle data yet',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    final avgCycle = completed.length > 1
        ? _averageCycleLength(completed)
        : 0;
    final avgPeriod = (completed.map((e) => e.duration).reduce((a, b) => a + b) ~/ completed.length);
    final avgPain = (completed.map((e) => e.painLevel).reduce((a, b) => a + b) ~/ completed.length);

    final symptomFreq = _buildSymptomFrequency(completed);
    final flowDist = _buildFlowDistribution(completed);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            label: 'Cycle summary card',
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _summaryItem(theme, 'Avg Cycle', '$avgCycle days', Icons.loop),
                    _summaryItem(theme, 'Avg Period', '$avgPeriod days', Icons.calendar_month),
                    _summaryItem(theme, 'Avg Pain', '$avgPain/5', Icons.healing),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (symptomFreq.isNotEmpty) ...[
            Semantics(
              label: 'Symptom frequency chart',
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Symptom Frequency',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: symptomFreq.values.reduce((a, b) => a > b ? a : b).toDouble() + 1,
                            barTouchData: BarTouchData(
                              touchTooltipData: BarTouchTooltipData(
                                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                  final label = symptomFreq.keys.elementAt(group.x.toInt());
                                  return BarTooltipItem(
                                    '$label\n${rod.toY.toInt()}',
                                    TextStyle(
                                      color: theme.colorScheme.onSurface,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              ),
                            ),
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    final keys = symptomFreq.keys.toList();
                                    if (value.toInt() >= 0 && value.toInt() < keys.length) {
                                      final label = keys[value.toInt()]
                                          .replaceAllMapped(RegExp(r'[A-Z]'), (m) => ' ${m.group(0)}')
                                          .trim();
                                      return SideTitleWidget(
                                        meta: meta,
                                        child: Text(
                                          label.length > 6 ? '${label.substring(0, 6)}.' : label,
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      );
                                    }
                                    return const SizedBox();
                                  },
                                  reservedSize: 28,
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 28,
                                  getTitlesWidget: (value, meta) {
                                    if (value == value.roundToDouble()) {
                                      return Text(
                                        '${value.toInt()}',
                                        style: const TextStyle(fontSize: 10),
                                      );
                                    }
                                    return const SizedBox();
                                  },
                                ),
                              ),
                              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            ),
                            gridData: FlGridData(
                              show: true,
                              horizontalInterval: 1,
                              drawVerticalLine: false,
                            ),
                            borderData: FlBorderData(show: false),
                            barGroups: symptomFreq.entries.toList().asMap().entries.map((entry) {
                              return BarChartGroupData(
                                x: entry.key,
                                barRods: [
                                  BarChartRodData(
                                    toY: entry.value.value.toDouble(),
                                    color: theme.colorScheme.primary,
                                    width: 20,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4),
                                      topRight: Radius.circular(4),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
          Semantics(
            label: 'Flow distribution chart',
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Flow Distribution',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: flowDist.isEmpty
                          ? Center(
                              child: Text(
                                'No flow data',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            )
                          : PieChart(
                              PieChartData(
                                sections: flowDist.entries.toList().asMap().entries.map((entry) {
                                  final colors = [
                                    theme.colorScheme.primary.withAlpha(180),
                                    theme.colorScheme.secondary.withAlpha(180),
                                    theme.colorScheme.tertiary.withAlpha(180),
                                    theme.colorScheme.primary.withAlpha(100),
                                    theme.colorScheme.secondary.withAlpha(100),
                                  ];
                                  final total = flowDist.values.fold(0, (a, b) => a + b);
                                  final pct = (entry.value.value / total * 100).round();
                                  return PieChartSectionData(
                                    color: colors[entry.key % colors.length],
                                    value: entry.value.value.toDouble(),
                                    title: '$pct%',
                                    radius: 60,
                                    titleStyle: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  );
                                }).toList(),
                                centerSpaceRadius: 40,
                                sectionsSpace: 2,
                              ),
                            ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      children: flowDist.entries.map((entry) {
                        final colors = [
                          theme.colorScheme.primary.withAlpha(180),
                          theme.colorScheme.secondary.withAlpha(180),
                          theme.colorScheme.tertiary.withAlpha(180),
                          theme.colorScheme.primary.withAlpha(100),
                          theme.colorScheme.secondary.withAlpha(100),
                        ];
                        final idx = flowDist.keys.toList().indexOf(entry.key);
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: colors[idx % colors.length],
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              entry.key.replaceAllMapped(RegExp(r'[A-Z]'), (m) => ' ${m.group(0)}').trim(),
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _averageCycleLength(List<CycleEntry> sortedEntries) {
    final sorted = List<CycleEntry>.from(sortedEntries)
      ..sort((a, b) => a.startDate.compareTo(b.startDate));
    int total = 0;
    int count = 0;
    for (int i = 1; i < sorted.length; i++) {
      final days = sorted[i].startDate.difference(sorted[i - 1].startDate).inDays;
      if (days >= 20 && days <= 45) {
        total += days;
        count++;
      }
    }
    if (count == 0) return 0;
    return total ~/ count;
  }

  Map<String, int> _buildSymptomFrequency(List<CycleEntry> entries) {
    final freq = <String, int>{};
    for (final entry in entries) {
      for (final symptom in entry.symptoms) {
        freq[symptom.name] = (freq[symptom.name] ?? 0) + 1;
      }
    }
    final sorted = freq.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return {for (final e in sorted) e.key: e.value};
  }

  Map<String, int> _buildFlowDistribution(List<CycleEntry> entries) {
    final dist = <String, int>{};
    for (final entry in entries) {
      final name = entry.flowIntensity.name;
      dist[name] = (dist[name] ?? 0) + 1;
    }
    return dist;
  }

  Widget _summaryItem(ThemeData theme, String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _YearlyTab extends StatelessWidget {
  final List<CycleEntry> entries;

  const _YearlyTab({required this.entries});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final completed = entries.where((e) => e.endDate != null).toList();

    if (completed.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.show_chart, size: 64, color: theme.colorScheme.onSurfaceVariant.withAlpha(100)),
            const SizedBox(height: 16),
            Text(
              'No yearly data yet',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    final monthlyData = _buildMonthlyData(completed);

    final avgCycle = completed.length > 1
        ? _averageCycleLength(completed)
        : 0;
    final avgPeriod = completed.map((e) => e.duration).reduce((a, b) => a + b) ~/ completed.length;
    final totalCycles = completed.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            label: 'Yearly statistics summary',
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _statItem(theme, 'Avg Cycle', '$avgCycle days'),
                    _statItem(theme, 'Avg Period', '$avgPeriod days'),
                    _statItem(theme, 'Total', '$totalCycles cycles'),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (monthlyData.length >= 2) ...[
            Semantics(
              label: 'Cycle length trend chart',
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cycle Length Trend',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 250,
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(
                              show: true,
                              horizontalInterval: 5,
                              drawVerticalLine: false,
                            ),
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 28,
                                  getTitlesWidget: (value, meta) {
                                    final idx = value.toInt();
                                    if (idx >= 0 && idx < monthlyData.length) {
                                      final monthNames = [
                                        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                                        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
                                      ];
                                      return SideTitleWidget(
                                        meta: meta,
                                        child: Text(
                                          monthNames[monthlyData[idx].month - 1],
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      );
                                    }
                                    return const SizedBox();
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 36,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      '${value.toInt()}',
                                      style: const TextStyle(fontSize: 10),
                                    );
                                  },
                                ),
                              ),
                              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            ),
                            borderData: FlBorderData(show: false),
                            minY: 0,
                            maxY: _maxCycleLength(monthlyData) + 5,
                            lineBarsData: [
                              LineChartBarData(
                                spots: monthlyData.asMap().entries.map((entry) {
                                  return FlSpot(entry.key.toDouble(), entry.value.avgCycleLength.toDouble());
                                }).toList(),
                                isCurved: true,
                                color: theme.colorScheme.primary,
                                barWidth: 3,
                                dotData: FlDotData(
                                  show: true,
                                  getDotPainter: (spot, percent, barData, index) {
                                    return FlDotCirclePainter(
                                      radius: 4,
                                      color: theme.colorScheme.primary,
                                      strokeWidth: 2,
                                      strokeColor: theme.colorScheme.onPrimary,
                                    );
                                  },
                                ),
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: theme.colorScheme.primary.withAlpha(30),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ] else
            Card(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    'Need at least 2 months of data',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<_MonthlyData> _buildMonthlyData(List<CycleEntry> entries) {
    final sorted = List<CycleEntry>.from(entries)
      ..sort((a, b) => a.startDate.compareTo(b.startDate));
    final byMonth = <String, List<int>>{};

    for (int i = 1; i < sorted.length; i++) {
      final days = sorted[i].startDate.difference(sorted[i - 1].startDate).inDays;
      if (days >= 20 && days <= 45) {
        final key = '${sorted[i].startDate.year}-${sorted[i].startDate.month}';
        byMonth.putIfAbsent(key, () => []);
        byMonth[key]!.add(days);
      }
    }

    return byMonth.entries.map((e) {
      final parts = e.key.split('-');
      final avg = e.value.reduce((a, b) => a + b) ~/ e.value.length;
      return _MonthlyData(
        year: int.parse(parts[0]),
        month: int.parse(parts[1]),
        avgCycleLength: avg,
      );
    }).toList()
      ..sort((a, b) {
        if (a.year != b.year) return a.year.compareTo(b.year);
        return a.month.compareTo(b.month);
      });
  }

  double _maxCycleLength(List<_MonthlyData> data) {
    double max = 0;
    for (final d in data) {
      if (d.avgCycleLength > max) max = d.avgCycleLength.toDouble();
    }
    return max;
  }

  int _averageCycleLength(List<CycleEntry> sortedEntries) {
    final sorted = List<CycleEntry>.from(sortedEntries)
      ..sort((a, b) => a.startDate.compareTo(b.startDate));
    int total = 0;
    int count = 0;
    for (int i = 1; i < sorted.length; i++) {
      final days = sorted[i].startDate.difference(sorted[i - 1].startDate).inDays;
      if (days >= 20 && days <= 45) {
        total += days;
        count++;
      }
    }
    if (count == 0) return 0;
    return total ~/ count;
  }

  Widget _statItem(ThemeData theme, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _MonthlyData {
  final int year;
  final int month;
  final int avgCycleLength;

  const _MonthlyData({
    required this.year,
    required this.month,
    required this.avgCycleLength,
  });
}

class _HistoryTab extends StatelessWidget {
  final List<CycleEntry> entries;
  final void Function(CycleEntry) onTap;
  final Future<void> Function(CycleEntry) onDelete;

  const _HistoryTab({
    required this.entries,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.history, size: 64, color: theme.colorScheme.onSurfaceVariant.withAlpha(100)),
            const SizedBox(height: 16),
            Text(
              'No cycle history',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return Semantics(
          label: 'Cycle entry from ${DateFormat.yMd().format(entry.startDate)}',
          child: Dismissible(
            key: ValueKey(entry.id),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 24),
              color: Colors.red,
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            confirmDismiss: (_) async {
              await onDelete(entry);
              return false;
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Icon(
                  Icons.calendar_today,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              title: Text(
                DateFormat.yMMMd().format(entry.startDate),
              ),
              subtitle: Text(
                '${entry.duration} days | ${entry.flowIntensity.name.replaceAllMapped(RegExp(r'[A-Z]'), (m) => ' ${m.group(0)}').trim()} | Pain: ${entry.painLevel}/5',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => onTap(entry),
            ),
          ),
        );
      },
    );
  }
}
