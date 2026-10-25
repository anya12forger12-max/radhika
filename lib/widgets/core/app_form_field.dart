import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:radhika/core/theme/app_tokens.dart';

/// A unified form field that replaces the various TextFormField patterns
/// across login, register, profile, log period, and other screens.
///
/// Provides consistent styling, validation UX, explanation text, and accessibility.
class AppFormField extends StatelessWidget {
  const AppFormField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.suffix,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.obscuringCharacter = '•',
    this.enabled = true,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
    this.explanation,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.autofillHints,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.initialValue,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.semanticLabel,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final String obscuringCharacter;
  final bool enabled;
  final bool readOnly;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldValidator<String>? validator;
  final String? explanation;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final Iterable<String>? autofillHints;
  final bool autocorrect;
  final bool enableSuggestions;
  final String? initialValue;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          label: semanticLabel ?? '$label input field',
          child: TextFormField(
            controller: controller,
            initialValue: controller == null ? initialValue : null,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            obscureText: obscureText,
            obscuringCharacter: obscuringCharacter,
            enabled: enabled,
            readOnly: readOnly,
            onTap: onTap,
            onChanged: onChanged,
            onFieldSubmitted: onFieldSubmitted,
            validator: validator,
            maxLines: maxLines,
            minLines: minLines,
            maxLength: maxLength,
            autofillHints: autofillHints,
            autocorrect: autocorrect,
            enableSuggestions: enableSuggestions,
            inputFormatters: inputFormatters,
            textCapitalization: textCapitalization,
            style: theme.textTheme.bodyLarge,
            decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              prefixIcon: prefixIcon != null
                  ? Icon(prefixIcon, size: AppTokens.iconMd)
                  : null,
              suffixIcon: suffixIcon != null
                  ? IconButton(
                      icon: Icon(suffixIcon, size: AppTokens.iconMd),
                      onPressed: () {},
                      tooltip: '',
                    )
                  : suffix,
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
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTokens.inputRadius),
                borderSide: BorderSide(color: colors.error, width: 2),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTokens.inputRadius),
                borderSide: BorderSide(color: colors.error, width: 2),
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
              labelStyle: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
              floatingLabelStyle: theme.textTheme.bodySmall?.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w500,
              ),
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant.withValues(alpha: 0.6),
              ),
              errorStyle: theme.textTheme.bodySmall?.copyWith(
                color: colors.error,
              ),
              counterStyle: theme.textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant.withValues(alpha: 0.5),
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
              style: AppTypography.formHint.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// A password field with built-in visibility toggle.
class AppPasswordField extends StatefulWidget {
  const AppPasswordField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.enabled = true,
    this.validator,
    this.onFieldSubmitted,
    this.textInputAction,
    this.semanticLabel,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final bool enabled;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final String? semanticLabel;

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return AppFormField(
      label: widget.label,
      controller: widget.controller,
      hint: widget.hint,
      obscureText: _obscure,
      enabled: widget.enabled,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      textInputAction: widget.textInputAction,
      semanticLabel: widget.semanticLabel,
      prefixIcon: Icons.lock_outlined,
      suffixIcon: _obscure ? Icons.visibility : Icons.visibility_off,
      suffix: IconButton(
        icon: Icon(
          _obscure ? Icons.visibility_off : Icons.visibility,
          size: AppTokens.iconMd,
        ),
        onPressed: () => setState(() => _obscure = !_obscure),
        tooltip: _obscure ? 'Show password' : 'Hide password',
      ),
    );
  }
}

/// A dropdown field wrapper with consistent styling.
class AppDropdownField<T> extends StatelessWidget {
  const AppDropdownField({
    super.key,
    required this.label,
    required this.items,
    this.value,
    this.onChanged,
    this.validator,
    this.hint,
    this.explanation,
    this.enabled = true,
    this.prefixIcon,
    this.semanticLabel,
  });

  final String label;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T?>? validator;
  final String? hint;
  final String? explanation;
  final bool enabled;
  final IconData? prefixIcon;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          label: semanticLabel ?? '$label dropdown',
          child: DropdownButtonFormField<T>(
            initialValue: value,
            items: items,
            onChanged: enabled ? onChanged : null,
            validator: validator,
            decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              prefixIcon: prefixIcon != null
                  ? Icon(prefixIcon, size: AppTokens.iconMd)
                  : null,
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
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTokens.inputRadius),
                borderSide: BorderSide(color: colors.error, width: 2),
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
            icon: Icon(Icons.keyboard_arrow_down, color: colors.onSurfaceVariant),
            dropdownColor: colors.surfaceContainerLow,
            style: Theme.of(context).textTheme.bodyLarge,
            borderRadius: BorderRadius.circular(AppTokens.inputRadius),
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

/// A multi-line text field with consistent styling.
class AppMultiLineField extends StatelessWidget {
  const AppMultiLineField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.explanation,
    this.validator,
    this.maxLines = 3,
    this.minLines = 2,
    this.enabled = true,
    this.prefixIcon,
    this.semanticLabel,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final String? explanation;
  final FormFieldValidator<String>? validator;
  final int maxLines;
  final int minLines;
  final bool enabled;
  final IconData? prefixIcon;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          label: semanticLabel ?? '$label text field',
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            minLines: minLines,
            enabled: enabled,
            validator: validator,
            style: Theme.of(context).textTheme.bodyLarge,
            decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              prefixIcon: prefixIcon != null
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 48),
                      child: Icon(prefixIcon, size: AppTokens.iconMd),
                    )
                  : null,
              alignLabelWithHint: true,
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
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTokens.inputRadius),
                borderSide: BorderSide(color: colors.error, width: 2),
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