import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:radhika/core/constants/app_constants.dart';
import 'package:radhika/providers/cycle_provider.dart';
import 'package:radhika/services/recommendation_service.dart';

class RecommendationsScreen extends ConsumerWidget {
  const RecommendationsScreen({super.key});

  static const Map<String, IconData> _icons = {
    'cramps': Icons.healing,
    'back_pain': Icons.accessibility_new,
    'headache': Icons.mood_bad,
    'nausea': Icons.sick,
    'bloating': Icons.self_improvement,
    'breast_tenderness': Icons.favorite_border,
    'fatigue': Icons.bedtime,
    'acne': Icons.face_retouching_natural,
    'mood_swings': Icons.mood,
    'anxiety': Icons.psychology,
    'depression': Icons.cloud,
    'severe_pain': Icons.warning_amber_rounded,
    'heavy_flow': Icons.opacity,
    'general': Icons.spa,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cycleState = ref.watch(cycleProvider);
    final recommendations =
        RecommendationService().build(entries: cycleState.cycleHistory);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Recommendations'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Semantics(
            label: 'Personalized recommendations from your recent logs',
            child: Text(
              'Relief and diet tips based on symptoms you\'ve logged in the '
              'last 30 days.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 16),
          for (final recommendation in recommendations) ...[
            _RecommendationCard(recommendation: recommendation),
            const SizedBox(height: 12),
          ],
          Semantics(
            label: 'Log symptoms for personalized tips',
            button: true,
            child: OutlinedButton.icon(
              onPressed: () =>
                  Navigator.of(context).pushNamed('/log-symptom'),
              icon: const Icon(Icons.add),
              label: const Text('Log symptoms for more tips'),
            ),
          ),
          const SizedBox(height: 16),
          const _DisclaimerCard(),
        ],
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({required this.recommendation});

  final Recommendation recommendation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final icon = RecommendationsScreen._icons[recommendation.iconKey] ??
        Icons.spa;

    return Semantics(
      label: recommendation.title,
      child: Card(
        elevation: 0,
        color: colorScheme.surfaceContainerHigh,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: colorScheme.onPrimaryContainer),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      recommendation.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _BulletSection(
                label: 'Relief tips',
                items: recommendation.reliefTips,
              ),
              const SizedBox(height: 12),
              _BulletSection(
                label: 'Diet tips',
                items: recommendation.dietTips,
              ),
              if (recommendation.careNote != null) ...[
                const SizedBox(height: 12),
                _CareNote(text: recommendation.careNote!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _BulletSection extends StatelessWidget {
  const _BulletSection({required this.label, required this.items});

  final String label;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Semantics(
      label: label,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 4),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\u2022 ',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _CareNote extends StatelessWidget {
  const _CareNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      label: 'Care note: $text',
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.errorContainer.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.info_outline,
              size: 18,
              color: theme.colorScheme.error,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onErrorContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DisclaimerCard extends StatelessWidget {
  const _DisclaimerCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      label: 'Medical disclaimer',
      child: Card(
        elevation: 0,
        color: theme.colorScheme.errorContainer.withValues(alpha: 0.3),
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline,
                color: theme.colorScheme.error,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  AppConstants.medicalDisclaimer,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onErrorContainer,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}