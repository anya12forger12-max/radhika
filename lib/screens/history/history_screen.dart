import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:radhika/models/cycle_entry.dart';
import 'package:radhika/services/cycle_repository.dart';
import 'package:radhika/widgets/common/empty_state.dart';

class HistoryPage extends ConsumerStatefulWidget {
  final bool favoritesOnly;
  final String? userId;

  const HistoryPage({super.key, this.favoritesOnly = false, this.userId});

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  bool _isLoading = true;
  String? _error;
  List<CycleEntry> _entries = const [];
  late bool _favoritesOnly;

  @override
  void initState() {
    super.initState();
    _favoritesOnly = widget.favoritesOnly;
    _load();
  }

  Future<void> _load() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final userId = widget.userId ?? '';
      final entries = ref
          .read(cycleRepositoryProvider)
          .getCycleEntries(userId);
      if (!mounted) return;
      setState(() {
        _entries = entries;
        _isLoading = false;
      });
    } on Object catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _refresh() async => _load();

  Future<void> _toggleFavorite(String entryId) async {
    await ref.read(cycleRepositoryProvider).toggleFavorite(entryId);
    _load();
  }

  List<CycleEntry> get _filtered => _favoritesOnly
      ? _entries.where((entry) => entry.isFavorite).toList()
      : List<CycleEntry>.from(_entries);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final displayed = _filtered;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cycle History'),
        actions: [
          HistoryFilter(
            favoritesOnly: _favoritesOnly,
            onToggle: (value) => setState(() => _favoritesOnly = value),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? _buildError(theme, colorScheme)
                : displayed.isEmpty
                    ? _buildEmpty(theme, colorScheme)
                    : _buildList(theme, colorScheme, displayed),
      ),
    );
  }

  Widget _buildEmpty(ThemeData theme, ColorScheme colorScheme) {
    final title = _favoritesOnly
        ? 'No favorite entries yet'
        : 'No cycle history yet';
    final subtitle = _favoritesOnly
        ? 'Mark an entry as a favorite to see it here.'
        : 'Log a period or symptom to start building your history.';
    return EmptyState(
      icon: _favoritesOnly ? Icons.favorite_border : Icons.history,
      title: title,
      subtitle: subtitle,
      action: _favoritesOnly
          ? null
          : TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, '/log-period'),
              child: const Text('Log Period'),
            ),
    );
  }

  Widget _buildError(ThemeData theme, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline,
                size: 64, color: colorScheme.error),
            const SizedBox(height: 16),
            Text('Unable to load history',
                style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(_error ?? '',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _refresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(
      ThemeData theme, ColorScheme colorScheme, List<CycleEntry> entries) {
    return ListView.builder(
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return _HistoryEntryRow(
          entry: entry,
          onToggleFavorite: _toggleFavorite,
        );
      },
    );
  }
}

class HistoryFilter extends StatelessWidget {
  final bool favoritesOnly;
  final ValueChanged<bool> onToggle;

  const HistoryFilter({
    super.key,
    required this.favoritesOnly,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      avatar: const Icon(Icons.favorite, size: 18),
      label: const Text('Favorites'),
      selected: favoritesOnly,
      onSelected: onToggle,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }
}

class _HistoryEntryRow extends ConsumerWidget {
  final CycleEntry entry;
  final Future<void> Function(String entryId) onToggleFavorite;

  const _HistoryEntryRow({
    required this.entry,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dateFormat = DateFormat('MMM d, yyyy');

    return ListTile(
      leading: IconButton(
        icon: Icon(
          entry.isFavorite ? Icons.favorite : Icons.favorite_border,
          color: entry.isFavorite ? colorScheme.error : null,
        ),
        onPressed: () => onToggleFavorite(entry.id),
        tooltip: entry.isFavorite ? 'Unfavorite' : 'Favorite',
      ),
      title: Text(dateFormat.format(entry.startDate),
          style: theme.textTheme.bodyLarge),
      subtitle: Text(
        entry.notes.isNotEmpty ? entry.notes : 'No notes',
        style: theme.textTheme.bodySmall,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text('${entry.duration} day${entry.duration == 1 ? '' : 's'}',
          style: theme.textTheme.labelMedium),
    );
  }
}
