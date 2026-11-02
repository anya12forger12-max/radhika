import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:radhika/core/theme/app_theme.dart';

double _luminance(Color c) => c.computeLuminance();

double _contrast(Color a, Color b) {
  final la = _luminance(a);
  final lb = _luminance(b);
  final lighter = la > lb ? la : lb;
  final darker = la > lb ? lb : la;
  return (lighter + 0.05) / (darker + 0.05);
}

void _check(String label, Color fg, Color bg, double min, {String? scheme}) {
  final ratio = _contrast(fg, bg);
  expect(
    ratio,
    greaterThanOrEqualTo(min),
    reason: '$label contrast ${ratio.toStringAsFixed(2)} < $min'
        '${scheme == null ? '' : ' ($scheme)'}',
  );
}

void _checkScheme(ColorScheme cs, double min, String scheme) {
  _check('onPrimary/primary', cs.onPrimary, cs.primary, min, scheme: scheme);
  _check('onSecondary/secondary', cs.onSecondary, cs.secondary, min, scheme: scheme);
  _check('onTertiary/tertiary', cs.onTertiary, cs.tertiary, min, scheme: scheme);
  _check('onError/error', cs.onError, cs.error, min, scheme: scheme);
  _check('onSurface/surface', cs.onSurface, cs.surface, min, scheme: scheme);
  _check('onPrimaryContainer/primaryContainer', cs.onPrimaryContainer,
      cs.primaryContainer, min, scheme: scheme);
  _check('onSecondaryContainer/secondaryContainer', cs.onSecondaryContainer,
      cs.secondaryContainer, min, scheme: scheme);
  _check('onTertiaryContainer/tertiaryContainer', cs.onTertiaryContainer,
      cs.tertiaryContainer, min, scheme: scheme);
  _check('onErrorContainer/errorContainer', cs.onErrorContainer, cs.errorContainer,
      min, scheme: scheme);
  _check('onSurface/surfaceContainerHighest', cs.onSurface,
      cs.surfaceContainerHighest, min, scheme: scheme);
}

void main() {
  group('WCAG 2.1 AA - Material 3 scheme role pairs (light/dark)', () {
    for (final entry in <MapEntry<String, ThemeData>>[
      MapEntry('light', AppTheme.light()),
      MapEntry('dark', AppTheme.dark()),
    ]) {
      test('${entry.key} scheme meets AA (>= 4.5) on all text roles', () {
        _checkScheme(entry.value.colorScheme, 4.5, entry.key);
      });
    }
  });

  group('WCAG 2.1 AA - high contrast scheme (AAA, >= 7.0)', () {
    test('highContrast scheme meets AAA on all text roles', () {
      _checkScheme(AppTheme.highContrast().colorScheme, 7.0, 'highContrast');
    });
  });

  group('WCAG 2.1 AA - custom theme surfaces', () {
    for (final entry in <MapEntry<String, ThemeData>>[
      MapEntry('light', AppTheme.light()),
      MapEntry('dark', AppTheme.dark()),
    ]) {
      final name = entry.key;
      final theme = entry.value;
      test('$name: appBar foreground on background >= 4.5', () {
        final bg = theme.appBarTheme.backgroundColor!;
        final fg = theme.appBarTheme.foregroundColor!;
        _check('appBar fg/bg', fg, bg, 4.5, scheme: name);
      });

      test('$name: input label on fill >= 4.5', () {
        final fill = theme.inputDecorationTheme.fillColor!;
        final label = theme.inputDecorationTheme.labelStyle!.color!;
        _check('input label/fill', label, fill, 4.5, scheme: name);
      });

      test('$name: error color on background >= 4.5', () {
        final bg = theme.scaffoldBackgroundColor;
        final err = theme.colorScheme.error;
        _check('error/bg', err, bg, 4.5, scheme: name);
      });

      test('$name: input border on background >= 3.0 (UI component)', () {
        final bg = theme.scaffoldBackgroundColor;
        final border = (theme.inputDecorationTheme.enabledBorder as OutlineInputBorder)
            .borderSide
            .color;
        _check('border/bg', border, bg, 3.0, scheme: name);
      });
    }
  });

  group('Design system tokens', () {
    test('rose500 is the M3 seed', () {
      expect(AppTheme.rose500, const Color(0xFFE91E63));
    });
    test('cardBorderRadius is 16', () {
      expect(AppTheme.cardBorderRadius, BorderRadius.circular(16));
    });
    test('cardPadding', () {
      expect(AppTheme.cardPadding, const EdgeInsets.all(16));
    });
    test('screenPadding', () {
      expect(AppTheme.screenPadding,
          const EdgeInsets.symmetric(horizontal: 24, vertical: 16));
    });
    test('sectionPadding', () {
      expect(AppTheme.sectionPadding,
          const EdgeInsets.symmetric(horizontal: 20, vertical: 12));
    });
    test('cardMargin', () {
      expect(AppTheme.cardMargin,
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8));
    });
    test('spacingSm', () {
      expect(AppTheme.spacingSm,
          const EdgeInsets.symmetric(horizontal: 8, vertical: 4));
    });
    test('spacingMd', () {
      expect(AppTheme.spacingMd,
          const EdgeInsets.symmetric(horizontal: 12, vertical: 8));
    });
    test('spacingLg', () {
      expect(AppTheme.spacingLg,
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16));
    });
    test('cardSurface is white', () {
      expect(AppTheme.cardSurface, const Color(0xFFFFFFFF));
    });
    test('colorSchemePrimaryContainer', () {
      expect(AppTheme.colorSchemePrimaryContainer, const Color(0xFFF3E5F5));
    });
    test('colorSchemeOnPrimaryContainer', () {
      expect(AppTheme.colorSchemeOnPrimaryContainer, const Color(0xFF4A148C));
    });
  });
}