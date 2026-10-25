import 'package:flutter/material.dart';
import 'package:radhika/core/theme/app_tokens.dart';

/// A unified card component that replaces the various Card patterns across the app.
/// Provides consistent elevation, padding, border radius, and semantic labeling.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppTokens.cardPadding),
    this.margin,
    this.onTap,
    this.color,
    this.elevation = AppTokens.elevationSm,
    this.borderRadius = AppTokens.cardRadius,
    this.border,
    this.semanticLabel,
    this.clipBehavior = Clip.antiAlias,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? color;
  final double elevation;
  final double borderRadius;
  final BorderSide? border;
  final String? semanticLabel;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = context.theme;

    final card = Card(
      elevation: elevation,
      margin: margin ?? const EdgeInsets.symmetric(
        horizontal: AppTokens.screenPadding,
        vertical: AppTokens.spaceXs,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: border ?? BorderSide.none,
      ),
      color: color ?? colors.surfaceContainerLow,
      clipBehavior: clipBehavior,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(
          padding: padding!,
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      return Semantics(
        label: semanticLabel ?? '',
        button: true,
        child: card,
      );
    }
    return card;
  }
}

/// A card with a standard header (title + optional subtitle/action).
class AppCardWithHeader extends StatelessWidget {
  const AppCardWithHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
    required this.child,
    this.padding = const EdgeInsets.all(AppTokens.cardPadding),
    this.headerPadding = const EdgeInsets.fromLTRB(
      AppTokens.cardPadding,
      AppTokens.cardPadding,
      AppTokens.cardPadding,
      AppTokens.spaceMd,
    ),
    this.margin,
    this.onTap,
    this.color,
    this.elevation = AppTokens.elevationSm,
    this.borderRadius = AppTokens.cardRadius,
    this.semanticLabel,
  });

  final String title;
  final String? subtitle;
  final Widget? action;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry headerPadding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? color;
  final double elevation;
  final double borderRadius;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      margin: margin,
      onTap: onTap,
      color: color,
      elevation: elevation,
      borderRadius: borderRadius,
      semanticLabel: semanticLabel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: headerPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Flexible(
                  child: Semantics(
                    header: true,
                    child: Text(
                      title,
                      style: AppTypography.cardTitle,
                    ),
                  ),
                ),
                if (action != null) action!,
              ],
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppTokens.spaceXs),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTokens.cardPadding),
              child: Text(
                subtitle!,
                style: AppTypography.cardSubtitle.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ),
          ],
          Padding(
            padding: padding,
            child: child,
          ),
        ],
      ),
    );
  }
}

/// A compact card used for list items and history entries.
class AppListCard extends StatelessWidget {
  const AppListCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppTokens.cardPadding,
      vertical: AppTokens.spaceMd,
    ),
    this.margin = const EdgeInsets.symmetric(
      horizontal: AppTokens.screenPadding,
      vertical: AppTokens.spaceXs,
    ),
    this.color,
    this.borderRadius = AppTokens.cardRadius,
    this.semanticLabel,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double borderRadius;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: padding,
      margin: margin,
      onTap: onTap,
      color: color,
      borderRadius: borderRadius,
      semanticLabel: semanticLabel,
      elevation: AppTokens.elevationNone,
      child: child,
    );
  }
}

/// A stat card showing a value with label and optional icon.
class AppStatCard extends StatelessWidget {
  const AppStatCard({
    super.key,
    required this.value,
    required this.label,
    this.unit,
    this.icon,
    this.iconColor,
    this.valueColor,
    this.onTap,
    this.semanticLabel,
  });

  final String value;
  final String label;
  final String? unit;
  final IconData? icon;
  final Color? iconColor;
  final Color? valueColor;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = context.theme;

    return Semantics(
      label: semanticLabel ?? '$label: $value ${unit ?? ""}',
      button: onTap != null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTokens.cardRadius),
        child: AppCard(
          padding: const EdgeInsets.all(AppTokens.cardPadding),
          margin: const EdgeInsets.symmetric(vertical: AppTokens.spaceXs),
          elevation: AppTokens.elevationNone,
          color: colors.surfaceContainerLow,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: AppTokens.iconXl,
                  color: iconColor ?? colors.primary,
                ),
                const SizedBox(height: AppTokens.spaceSm),
              ],
              Text(
                value,
                style: AppTypography.statValue.copyWith(
                  color: valueColor ?? colors.primary,
                ),
              ),
              if (unit != null) ...[
                const SizedBox(height: AppTokens.spaceXs),
                Text(
                  unit!,
                  style: AppTypography.statLabel.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
              const SizedBox(height: AppTokens.spaceXs),
              Text(
                label,
                style: AppTypography.statLabel.copyWith(
                  color: colors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A card for displaying a detail row (label + value).
class AppDetailRow extends StatelessWidget {
  const AppDetailRow({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.valueStyle,
    this.labelWidth = 110,
  });

  final String label;
  final String value;
  final IconData? icon;
  final TextStyle? valueStyle;
  final double labelWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTokens.spaceXs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: AppTokens.iconSm, color: context.colors.primary),
            const SizedBox(width: AppTokens.spaceSm),
          ],
          SizedBox(
            width: labelWidth,
            child: Text(
              label,
              style: AppTypography.formHint.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: valueStyle ?? AppTypography.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}