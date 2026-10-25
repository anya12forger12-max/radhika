import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:radhika/core/theme/app_tokens.dart';

/// A unified date picker field with consistent styling and accessibility.
class AppDateField extends StatelessWidget {
  const AppDateField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.firstDate,
    this.lastDate,
    this.initialDate,
    this.hint,
    this.explanation,
    this.enabled = true,
    this.prefixIcon = Icons.calendar_today,
    this.semanticLabel,
    this.format = 'MMM d, yyyy',
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? initialDate;
  final String? hint;
  final String? explanation;
  final bool enabled;
  final IconData prefixIcon;
  final String? semanticLabel;
  final String format;

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: value ?? initialDate ?? now,
      firstDate: firstDate ?? now.subtract(const Duration(days: 365 * 10)),
      lastDate: lastDate ?? now,
      helpText: label,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme,
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      onChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dateFormat = DateFormat(format);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          label: semanticLabel ?? '$label date picker',
          button: true,
          child: InkWell(
            onTap: enabled ? () => _pickDate(context) : null,
            borderRadius: BorderRadius.circular(AppTokens.inputRadius),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: label,
                hintText: hint,
                prefixIcon: Icon(prefixIcon, size: AppTokens.iconMd),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTokens.inputRadius),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTokens.inputRadius),
                  borderSide: BorderSide(color: colors.outlineVariant),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTokens.inputRadius),
                  borderSide: BorderSide(color: colors.primary, width: 2),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTokens.inputRadius),
                  borderSide: BorderSide(color: colors.outlineVariant),
                ),
                filled: true,
                fillColor: enabled
                    ? colors.surface
                    : colors.surfaceContainerHighest.withValues(alpha: 0.5),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppTokens.cardPadding,
                  vertical: AppTokens.spaceMd,
                ),
              ),
              child: Text(
                value != null
                    ? dateFormat.format(value!)
                    : hint ?? 'Select date',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: value != null
                          ? colors.onSurface
                          : colors.onSurfaceVariant.withValues(alpha: 0.6),
                    ),
              ),
            ),
          ),
        ),
        if (explanation != null) ...[
          const SizedBox(height: AppTokens.spaceXs),
          Padding(
            padding: const EdgeInsets.only(left: AppTokens.inlineGap),
            child: Text(
              explanation!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
            ),
          ),
        ],
      ],
    );
  }
}

/// A unified time picker field with consistent styling.
class AppTimeField extends StatelessWidget {
  const AppTimeField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.hint,
    this.explanation,
    this.enabled = true,
    this.prefixIcon = Icons.access_time,
    this.semanticLabel,
  });

  final String label;
  final TimeOfDay? value;
  final ValueChanged<TimeOfDay> onChanged;
  final String? hint;
  final String? explanation;
  final bool enabled;
  final IconData prefixIcon;
  final String? semanticLabel;

  Future<void> _pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: value ?? TimeOfDay.now(),
      helpText: label,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme,
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      onChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          label: semanticLabel ?? '$label time picker',
          button: true,
          child: InkWell(
            onTap: enabled ? () => _pickTime(context) : null,
            borderRadius: BorderRadius.circular(AppTokens.inputRadius),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: label,
                hintText: hint,
                prefixIcon: Icon(prefixIcon, size: AppTokens.iconMd),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTokens.inputRadius),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTokens.inputRadius),
                  borderSide: BorderSide(color: colors.outlineVariant),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTokens.inputRadius),
                  borderSide: BorderSide(color: colors.primary, width: 2),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTokens.inputRadius),
                  borderSide: BorderSide(color: colors.outlineVariant),
                ),
                filled: true,
                fillColor: enabled
                    ? colors.surface
                    : colors.surfaceContainerHighest.withValues(alpha: 0.5),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppTokens.cardPadding,
                  vertical: AppTokens.spaceMd,
                ),
              ),
              child: Text(
                value != null
                    ? value!.format(context)
                    : hint ?? 'Select time',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: value != null
                          ? colors.onSurface
                          : colors.onSurfaceVariant.withValues(alpha: 0.6),
                    ),
              ),
            ),
          ),
        ),
        if (explanation != null) ...[
          const SizedBox(height: AppTokens.spaceXs),
          Padding(
            padding: const EdgeInsets.only(left: AppTokens.inlineGap),
            child: Text(
              explanation!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
            ),
          ),
        ],
      ],
    );
  }
}

/// A unified avatar widget with consistent sizing and fallback.
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    this.image,
    this.radius = AppTokens.avatarMd,
    this.backgroundColor,
    this.child,
    this.border,
  });

  final ImageProvider? image;
  final double radius;
  final Color? backgroundColor;
  final Widget? child;
  final Border? border;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return CircleAvatar(
      radius: radius,
      backgroundImage: image,
      backgroundColor: backgroundColor ?? context.colors.primaryContainer,
      foregroundColor: colors.onPrimaryContainer,
      child: child,
    );
  }
}

/// A unified badge/chip for status indicators.
class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.label,
    this.icon,
    this.color,
    this.textColor,
    this.size = AppTokens.iconSm,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppTokens.spaceSm,
      vertical: AppTokens.spaceXs,
    ),
  });

  final String label;
  final IconData? icon;
  final Color? color;
  final Color? textColor;
  final double size;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final badgeColor = color ?? context.colors.primaryContainer;
    final badgeTextColor = textColor ?? context.colors.onPrimaryContainer;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(AppTokens.chipRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: size, color: badgeTextColor),
            const SizedBox(width: AppTokens.spaceXs),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: badgeTextColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

/// A divider with optional label.
class AppSectionDivider extends StatelessWidget {
  const AppSectionDivider({
    super.key,
    this.label,
    this.indent = 0,
    this.endIndent = 0,
    this.thickness = 1,
    this.color,
  });

  final String? label;
  final double indent;
  final double endIndent;
  final double thickness;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    if (label == null) {
      return Divider(
        indent: indent,
        endIndent: endIndent,
        thickness: thickness,
        color: color ?? context.colors.outlineVariant,
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppTokens.spaceSm),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              indent: indent,
              endIndent: AppTokens.spaceMd,
              thickness: thickness,
              color: color ?? context.colors.outlineVariant,
            ),
          ),
          Text(
            label!,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
          ),
          Expanded(
            child: Divider(
              indent: AppTokens.spaceMd,
              endIndent: endIndent,
              thickness: thickness,
              color: color ?? context.colors.outlineVariant,
            ),
          ),
        ],
      ),
    );
  }
}