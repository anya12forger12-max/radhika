import 'package:flutter/material.dart';
import 'package:radhika/core/theme/app_tokens.dart';

/// A consistent section header used across all screens.
/// Replaces the various _SectionHeader, _SectionLabel, and inline header patterns.
class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
    this.actionTooltip,
    this.style,
    this.padding = const EdgeInsets.only(
      left: AppTokens.spaceXs,
      bottom: AppTokens.spaceSm,
    ),
  });

  final String title;
  final String? subtitle;
  final Widget? action;
  final String? actionTooltip;
  final TextStyle? style;
  final EdgeInsetsGeometry padding;

  /// Creates a section header with a trailing action button.
  AppSectionHeader.withAction({
    super.key,
    required this.title,
    this.subtitle,
    required String actionLabel,
    required VoidCallback onAction,
    this.actionTooltip,
    this.style,
    this.padding = const EdgeInsets.only(
      left: AppTokens.spaceXs,
      bottom: AppTokens.spaceSm,
    ),
  }) : action = TextButton(
          onPressed: onAction,
          child: Text(actionLabel),
        );

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyle = style ?? AppTypography.sectionTitle.copyWith(
      color: colors.primary,
    );

    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Flexible(
            child: Semantics(
              label: title,
              header: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: textStyle),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: AppTypography.caption.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (action != null)
            Padding(
              padding: const EdgeInsets.only(left: AppTokens.inlineGap),
              child: Tooltip(
                message: actionTooltip ?? '',
                child: action!,
              ),
            ),
        ],
      ),
    );
  }
}

/// A compact section label used within cards and forms.
class AppSectionLabel extends StatelessWidget {
  const AppSectionLabel({
    super.key,
    required this.text,
    this.style,
    this.padding = EdgeInsets.zero,
  });

  final String text;
  final TextStyle? style;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Semantics(
        label: text,
        header: true,
        child: Text(
          text,
          style: style ?? AppTypography.formLabel,
        ),
      ),
    );
  }
}