import 'package:flutter/material.dart';
import 'package:radhika/core/theme/app_tokens.dart';

/// A unified primary button (filled) with consistent styling across the app.
/// Replaces the various ElevatedButton/FilledButton patterns.
class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.fullWidth = true,
    this.height = AppTokens.buttonHeight,
    this.semanticLabel,
    this.tooltip,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool isLoading;
  final bool fullWidth;
  final double height;
  final String? semanticLabel;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final enabled = onPressed != null && !isLoading;

    final Widget child = isLoading
        ? SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(colors.onPrimary),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: AppTokens.spaceSm),
              ],
              Text(
                label,
                style: AppTypography.buttonLabel.copyWith(
                  color: colors.onPrimary,
                ),
              ),
            ],
          );

    final button = FilledButton(
      onPressed: enabled ? onPressed : null,
      style: FilledButton.styleFrom(
        fixedSize: fullWidth ? Size(double.infinity, height) : Size.fromHeight(height),
        minimumSize: fullWidth ? Size(double.infinity, height) : Size.fromHeight(height),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.buttonRadius),
        ),
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        disabledBackgroundColor: colors.primary.withValues(alpha: 0.38),
        disabledForegroundColor: colors.onPrimary.withValues(alpha: 0.38),
        elevation: AppTokens.elevationNone,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: child,
    );

    return Semantics(
      label: semanticLabel ?? label,
      button: true,
      enabled: enabled,
      child: tooltip != null
          ? Tooltip(message: tooltip!, child: button)
          : button,
    );
  }
}

/// A unified secondary button (outlined) with consistent styling.
class AppSecondaryButton extends StatelessWidget {
  const AppSecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.fullWidth = true,
    this.height = AppTokens.buttonHeight,
    this.semanticLabel,
    this.tooltip,
    this.foregroundColor,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool isLoading;
  final bool fullWidth;
  final double height;
  final String? semanticLabel;
  final String? tooltip;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final enabled = onPressed != null && !isLoading;
    final color = foregroundColor ?? colors.primary;

    final Widget child = isLoading
        ? SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: AppTokens.spaceSm),
              ],
              Text(
                label,
                style: AppTypography.buttonLabel.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );

    final button = OutlinedButton(
      onPressed: enabled ? onPressed : null,
      style: OutlinedButton.styleFrom(
        fixedSize: fullWidth ? Size(double.infinity, height) : Size.fromHeight(height),
        minimumSize: fullWidth ? Size(double.infinity, height) : Size.fromHeight(height),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.buttonRadius),
        ),
        foregroundColor: color,
        side: BorderSide(color: color, width: 1.5),
        disabledForegroundColor: color.withValues(alpha: 0.38),
        elevation: AppTokens.elevationNone,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: child,
    );

    return Semantics(
      label: semanticLabel ?? label,
      button: true,
      enabled: enabled,
      child: tooltip != null
          ? Tooltip(message: tooltip!, child: button)
          : button,
    );
  }
}

/// A unified text button with consistent styling.
class AppTextButton extends StatelessWidget {
  const AppTextButton({
    super.key,
    required this.label,
    this.onPressed,
    this.semanticLabel,
    this.style,
  });

  final String label;
  final VoidCallback? onPressed;
  final String? semanticLabel;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final enabled = onPressed != null;

    return Semantics(
      label: semanticLabel ?? label,
      button: true,
      enabled: enabled,
      child: TextButton(
        onPressed: enabled ? onPressed : null,
        style: TextButton.styleFrom(
          foregroundColor: colors.primary,
          disabledForegroundColor: colors.primary.withValues(alpha: 0.38),
          padding: const EdgeInsets.symmetric(
            horizontal: AppTokens.spaceSm,
            vertical: AppTokens.spaceXs,
          ),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTokens.buttonRadius),
          ),
        ),
        child: Text(
          label,
          style: style ?? AppTypography.buttonLabel.copyWith(
            color: enabled ? colors.primary : colors.primary.withValues(alpha: 0.38),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// A destructive button (for delete, logout, etc.) with error color.
class AppDestructiveButton extends StatelessWidget {
  const AppDestructiveButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.fullWidth = true,
    this.height = AppTokens.buttonHeight,
    this.semanticLabel,
    this.outlined = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool fullWidth;
  final double height;
  final String? semanticLabel;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final enabled = onPressed != null && !isLoading;

    if (outlined) {
      return AppSecondaryButton(
        label: label,
        onPressed: enabled ? onPressed : null,
        isLoading: isLoading,
        fullWidth: fullWidth,
        height: height,
        semanticLabel: semanticLabel,
        foregroundColor: colors.error,
      );
    }

    return AppPrimaryButton(
      label: label,
      onPressed: enabled ? onPressed : null,
      isLoading: isLoading,
      fullWidth: fullWidth,
      height: height,
      semanticLabel: semanticLabel,
    );
  }
}

/// A compact icon button with consistent sizing and touch targets.
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.semanticLabel,
    this.size = AppTokens.iconMd,
    this.color,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(AppTokens.spaceSm),
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final String? semanticLabel;
  final double size;
  final Color? color;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final button = IconButton(
      icon: Icon(icon, size: size, color: color ?? colors.onSurface),
      onPressed: onPressed,
      tooltip: tooltip,
      padding: padding,
      constraints: const BoxConstraints(
        minWidth: AppTokens.minTouchTarget,
        minHeight: AppTokens.minTouchTarget,
      ),
      style: IconButton.styleFrom(
        backgroundColor: backgroundColor ?? colors.surfaceContainerHighest,
        disabledBackgroundColor: colors.surfaceContainerHighest.withValues(alpha: 0.5),
        foregroundColor: color ?? colors.onSurface,
        disabledForegroundColor: colors.onSurface.withValues(alpha: 0.38),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.buttonRadius),
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );

    return Semantics(
      label: semanticLabel ?? tooltip ?? '',
      button: true,
      enabled: onPressed != null,
      child: button,
    );
  }
}

/// A toggle button (switch-like) with consistent styling.
class AppToggleButton extends StatelessWidget {
  const AppToggleButton({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.icon,
    this.semanticLabel,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? subtitle;
  final IconData? icon;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Semantics(
      label: semanticLabel ?? label,
      toggled: value,
      child: SwitchListTile(
        title: Text(label, style: AppTypography.bodyLarge),
        subtitle: subtitle != null
            ? Text(subtitle!, style: AppTypography.bodySmall.copyWith(
                color: context.colors.onSurfaceVariant,
              ))
            : null,
        value: value,
        onChanged: onChanged,
        secondary: icon != null
            ? Icon(icon, color: context.colors.primary, size: AppTokens.iconMd)
            : null,
        contentPadding: EdgeInsets.zero,
        activeThumbColor: colors.primary,
        inactiveThumbColor: colors.outline,
        inactiveTrackColor: colors.surfaceContainerHighest,
      ),
    );
  }
}

/// A chip-style filter/choice button.
class AppFilterChip<T> extends StatelessWidget {
  const AppFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
    this.avatar,
    this.semanticLabel,
    this.disabled = false,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;
  final Widget? avatar;
  final String? semanticLabel;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Semantics(
      label: semanticLabel ?? label,
      button: true,
      selected: selected,
      enabled: !disabled,
      child: FilterChip(
        selected: selected,
        label: Text(label, style: AppTypography.chipLabel),
        avatar: avatar,
        onSelected: disabled ? null : onSelected,
        showCheckmark: false,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        selectedColor: colors.primaryContainer,
        backgroundColor: colors.surfaceContainerHigh,
        checkmarkColor: colors.onPrimaryContainer,
        labelStyle: AppTypography.chipLabel.copyWith(
          color: selected ? colors.onPrimaryContainer : colors.onSurface,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
        ),
        side: BorderSide(
          color: selected ? colors.primary : colors.outlineVariant,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.chipRadius),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppTokens.spaceMd,
          vertical: AppTokens.spaceXs,
        ),
      ),
    );
  }
}

/// A choice chip for single selection from a group.
class AppChoiceChip<T> extends StatelessWidget {
  const AppChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
    this.avatar,
    this.semanticLabel,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;
  final Widget? avatar;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Semantics(
      label: semanticLabel ?? label,
      button: true,
      selected: selected,
      child: ChoiceChip(
        selected: selected,
        label: Text(label, style: AppTypography.chipLabel),
        avatar: avatar,
        onSelected: onSelected,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        selectedColor: colors.primaryContainer,
        backgroundColor: colors.surfaceContainerHigh,
        labelStyle: AppTypography.chipLabel.copyWith(
          color: selected ? colors.onPrimaryContainer : colors.onSurface,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
        ),
        side: BorderSide(
          color: selected ? colors.primary : colors.outlineVariant,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.chipRadius),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppTokens.spaceMd,
          vertical: AppTokens.spaceXs,
        ),
      ),
    );
  }
}