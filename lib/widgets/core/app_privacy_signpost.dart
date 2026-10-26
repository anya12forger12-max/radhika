import 'package:flutter/material.dart';
import 'package:radhika/core/theme/app_tokens.dart';

/// A persistent visual indicator communicating local-data sovereignty.
///
/// Displays a green shield icon alongside plain-language text stating that
/// health data is encrypted and stored exclusively on this device, with no
/// cloud sync. Use on storage boundaries (home, settings, backup surfaces).
class AppPrivacySignpost extends StatelessWidget {
  const AppPrivacySignpost({
    super.key,
    this.message = 'Your data is fully encrypted and stored exclusively on '
        'this device. No cloud sync active.',
    this.compact = false,
  });

  final String message;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      label: message,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? AppTokens.spaceSm : AppTokens.spaceMd,
          vertical: compact ? AppTokens.spaceXs : AppTokens.spaceSm,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF2E7D32).withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppTokens.radiusMd),
          border: Border.all(
            color: const Color(0xFF2E7D32).withValues(alpha: 0.35),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.verified_user,
              size: 18,
              color: Color(0xFF2E7D32),
            ),
            const SizedBox(width: AppTokens.spaceSm),
            Flexible(
              child: Text(
                '🔒 $message',
                style: textTheme.labelSmall?.copyWith(
                  color: const Color(0xFF1B5E20),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}