import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:radhika/providers/auth_provider.dart';
import 'package:radhika/providers/cycle_provider.dart';
import 'package:radhika/core/constants/app_constants.dart';
import 'package:radhika/screens/calendar/calendar_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final cycleState = ref.watch(cycleProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final profile = authState.profile;
    final prediction = cycleState.currentPrediction;

    return Scaffold(
      appBar: AppBar(
        title: Semantics(
          label: 'Radhika app title',
          child: Text(AppConstants.appName),
        ),
        actions: [
          Semantics(
            label: 'Settings',
            button: true,
            child: IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Settings',
              onPressed: () => Navigator.pushNamed(context, '/settings'),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(cycleProvider.notifier).refresh();
          await ref.read(authProvider.notifier).refreshProfile();
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            _buildGreeting(theme, colorScheme, profile),
            const SizedBox(height: 16),
            _buildPredictionCard(theme, colorScheme, prediction, profile),
            const SizedBox(height: 20),
            _buildQuickActions(theme, colorScheme),
            const SizedBox(height: 20),
            _buildCycleStatus(theme, colorScheme, profile, cycleState),
            if (prediction != null && prediction.isDelayed && cycleState.delaySuggestions.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildDelayWarning(theme, colorScheme, cycleState.delaySuggestions),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGreeting(ThemeData theme, ColorScheme colorScheme, dynamic profile) {
    final name = profile?.name?.isNotEmpty == true ? profile.name : 'there';
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Good morning';
    } else if (hour < 17) {
      greeting = 'Good afternoon';
    } else {
      greeting = 'Good evening';
    }

    return Semantics(
      label: '$greeting, $name',
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              greeting,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              name,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1, duration: 400.ms);
  }

  Widget _buildPredictionCard(
    ThemeData theme,
    ColorScheme colorScheme,
    dynamic prediction,
    dynamic profile,
  ) {
    return Semantics(
      label: 'Next period prediction',
      child: Card(
        elevation: 0,
        color: colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: prediction != null && profile?.lastPeriodStart != null
              ? _buildPredictionContent(theme, colorScheme, prediction)
              : _buildEmptyPrediction(theme, colorScheme),
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, duration: 500.ms);
  }

  Widget _buildPredictionContent(
    ThemeData theme,
    ColorScheme colorScheme,
    dynamic prediction,
  ) {
    final now = DateTime.now();
    final daysUntil = prediction.predictedStartDate.difference(now).inDays;
    final dateFormat = DateFormat('MMM d, yyyy');
    final confidencePercent = (prediction.confidence * 100).round();
    final isDue = daysUntil <= 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.event, color: colorScheme.onPrimaryContainer, size: 20),
            const SizedBox(width: 8),
            Text(
              'Next Period',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Semantics(
          label: isDue
              ? 'Your period is due'
              : '$daysUntil days until your next period',
          child: Text(
            isDue ? 'Due' : '$daysUntil days',
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Semantics(
          label: 'Predicted date: ${dateFormat.format(prediction.predictedStartDate)}',
          child: Text(
            'Predicted: ${dateFormat.format(prediction.predictedStartDate)}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Semantics(
          label: 'Confidence level $confidencePercent percent',
          child: Row(
            children: [
              Icon(
                confidencePercent >= 70
                    ? Icons.check_circle
                    : confidencePercent >= 50
                        ? Icons.info
                        : Icons.help,
                size: 16,
                color: colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 4),
              Text(
                '$confidencePercent% confidence',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
                ),
              ),
              const Spacer(),
              Semantics(
                label: 'Prediction disclaimer',
                child: Tooltip(
                  message: AppConstants.predictionDisclaimer,
                  child: Icon(
                    Icons.info_outline,
                    size: 16,
                    color: colorScheme.onPrimaryContainer.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyPrediction(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.event, color: colorScheme.onPrimaryContainer, size: 20),
            const SizedBox(width: 8),
            Text(
              'Next Period',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Semantics(
          label: 'No prediction data available. Start logging your cycle.',
          child: Text(
            'Start logging your cycles\nto get predictions',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(ThemeData theme, ColorScheme colorScheme) {
    final actions = [
      _QuickAction(
        icon: Icons.calendar_today,
        label: 'Log Period',
        route: '/log-period',
        semanticLabel: 'Log period entry',
      ),
      _QuickAction(
        icon: Icons.add,
        label: 'Log Symptoms',
        route: '/log-symptoms',
        semanticLabel: 'Log symptoms',
      ),
      _QuickAction(
        icon: Icons.calendar_month,
        label: 'Calendar',
        route: '/calendar',
        semanticLabel: 'View calendar',
        isScreen: true,
      ),
      _QuickAction(
        icon: Icons.school,
        label: 'Education',
        route: '/education',
        semanticLabel: 'Educational resources',
      ),
      _QuickAction(
        icon: Icons.bar_chart,
        label: 'Reports',
        route: '/reports',
        semanticLabel: 'View reports and charts',
      ),
      _QuickAction(
        icon: Icons.person,
        label: 'Profile',
        route: '/profile',
        semanticLabel: 'User profile',
      ),
    ];

    return Semantics(
      label: 'Quick actions',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'Quick Actions',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: actions.length,
            itemBuilder: (context, index) {
              final action = actions[index];
              return _QuickActionCard(
                action: action,
                colorScheme: colorScheme,
                theme: theme,
                index: index,
                onTap: () => _navigateTo(action),
              );
            },
          ),
        ],
      ),
    );
  }

  void _navigateTo(_QuickAction action) {
    if (action.isScreen) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CalendarScreen()),
      );
    } else {
      Navigator.pushNamed(context, action.route);
    }
  }

  Widget _buildCycleStatus(
    ThemeData theme,
    ColorScheme colorScheme,
    dynamic profile,
    dynamic cycleState,
  ) {
    final entries = cycleState.cycleHistory as List? ?? [];
    final lastPeriodStart = profile?.lastPeriodStart;

    if (lastPeriodStart == null) {
      return Semantics(
        label: 'No cycle data. Log your first period.',
        child: Card(
          elevation: 0,
          color: colorScheme.surfaceContainerHigh,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: colorScheme.primary, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Log your first period to start tracking your cycle',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ).animate().fadeIn(duration: 400.ms);
    }

    final now = DateTime.now();
    final cycleDay = now.difference(lastPeriodStart).inDays + 1;

    bool isOnPeriod = false;
    if (entries.isNotEmpty) {
      final latest = entries.first as dynamic;
      if (latest.endDate != null) {
        final end = latest.endDate as DateTime;
        isOnPeriod = latest.startDate.isBefore(now) && end.isAfter(now.subtract(const Duration(days: 1)));
      }
    }

    String statusText;
    if (isOnPeriod) {
      statusText = "You're on your period";
    } else {
      statusText = "You're on day $cycleDay of your cycle";
    }

    return Semantics(
      label: statusText,
      child: Card(
        elevation: 0,
        color: colorScheme.surfaceContainerHigh,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isOnPeriod
                      ? colorScheme.primaryContainer
                      : colorScheme.secondaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isOnPeriod ? Icons.water_drop : Icons.cycle,
                  color: isOnPeriod
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSecondaryContainer,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cycle Status',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      statusText,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, duration: 400.ms);
  }

  Widget _buildDelayWarning(ThemeData theme, ColorScheme colorScheme, List<String> suggestions) {
    return Semantics(
      label: 'Period delay warning',
      child: Card(
        elevation: 0,
        color: colorScheme.tertiaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.warning_amber_rounded,
                      color: colorScheme.onTertiaryContainer, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Cycle Delay',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: colorScheme.onTertiaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                AppConstants.cycleDelayMessage,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onTertiaryContainer.withValues(alpha: 0.8),
                ),
              ),
              if (suggestions.isNotEmpty) ...[
                const SizedBox(height: 12),
                ...suggestions.take(3).map(
                      (s) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('• ', style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onTertiaryContainer,
                            )),
                            Expanded(
                              child: Text(
                                s,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onTertiaryContainer.withValues(alpha: 0.8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              ],
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, duration: 500.ms);
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final String route;
  final String semanticLabel;
  final bool isScreen;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.route,
    required this.semanticLabel,
    this.isScreen = false,
  });
}

class _QuickActionCard extends StatelessWidget {
  final _QuickAction action;
  final ColorScheme colorScheme;
  final ThemeData theme;
  final int index;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.action,
    required this.colorScheme,
    required this.theme,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: action.semanticLabel,
      button: true,
      child: SizedBox(
        height: 48,
        child: Card(
          elevation: 0,
          color: colorScheme.surfaceContainerHigh,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(action.icon, color: colorScheme.primary, size: 28),
                  const SizedBox(height: 6),
                  Text(
                    action.label,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: (50 * index).ms).slideY(
      begin: 0.1,
      duration: 400.ms,
      delay: (50 * index).ms,
    );
  }
}
