import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:radhika/models/cycle_entry.dart';
import 'package:radhika/providers/cycle_provider.dart';

class CycleDetailScreen extends ConsumerWidget {
  final String entryId;

  const CycleDetailScreen({super.key, required this.entryId});

  static const Map<FlowIntensity, String> _flowLabels = {
    FlowIntensity.veryLight: 'Very Light',
    FlowIntensity.light: 'Light',
    FlowIntensity.medium: 'Medium',
    FlowIntensity.heavy: 'Heavy',
    FlowIntensity.veryHeavy: 'Very Heavy',
  };

  static String _titleCase(String value) {
    final spaced = value.replaceAllMapped(
      RegExp(r'[A-Z]'),
      (m) => ' ${m.group(0)!.toLowerCase()}',
    );
    return spaced
        .split(' ')
        .map((w) =>
            w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }

  CycleEntry? _findEntry(WidgetRef ref) {
    final history = ref.watch(cycleProvider).cycleHistory;
    for (final entry in history) {
      if (entry.id == entryId) return entry;
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final entry = _findEntry(ref);

    return Scaffold(
      appBar: AppBar(title: const Text('Cycle Details')),
      body: entry == null
          ? Center(
              child: Text(
                'Entry not found',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            )
          : _buildDetails(theme, entry),
    );
  }

  Widget _buildDetails(ThemeData theme, CycleEntry entry) {
    final colorScheme = theme.colorScheme;
    final dateFormat = DateFormat('MMMM d, yyyy');
    final symptoms = entry.symptoms.isNotEmpty
        ? entry.symptoms.map((s) => _titleCase(s.name)).join(', ')
        : 'None';

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          dateFormat.format(entry.startDate),
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          entry.endDate == null
              ? '${entry.duration} day · Ongoing'
              : '${entry.duration} days · Ends ${dateFormat.format(entry.endDate!)}',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 24),
        _detailRow(theme, 'Flow', _flowLabels[entry.flowIntensity] ?? 'N/A'),
        _detailRow(theme, 'Spotting', entry.spotting ? 'Yes' : 'No'),
        _detailRow(theme, 'Pain Level', '${entry.painLevel}/5'),
        _detailRow(theme, 'Mood', _titleCase(entry.mood.name)),
        _detailRow(theme, 'Energy Level', '${entry.energyLevel}/5'),
        _detailRow(theme, 'Sleep', '${entry.sleepHours} hours'),
        _detailRow(theme, 'Exercise', entry.exercise ? 'Yes' : 'No'),
        _detailRow(theme, 'Water Intake', '${entry.waterIntake} glasses'),
        _detailRow(theme, 'Symptoms', symptoms),
        if (entry.notes.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text('Notes', style: theme.textTheme.titleSmall),
          const SizedBox(height: 4),
          Text(entry.notes, style: theme.textTheme.bodyMedium),
        ],
      ],
    );
  }

  Widget _detailRow(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: theme.textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}