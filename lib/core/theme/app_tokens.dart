import 'package:flutter/material.dart';

/// Centralized design tokens for consistent spacing, sizing, and visual properties.
/// All screens and components should reference these tokens instead of hardcoded values.
class AppTokens {
  AppTokens._();

  /// Spacing scale — base unit is 4dp. Use these for all padding, margins, gaps.
  static const double spaceXs = 4;   // 4dp
  static const double spaceSm = 8;   // 8dp
  static const double spaceMd = 12;  // 12dp
  static const double spaceLg = 16;  // 16dp
  static const double spaceXl = 20;  // 20dp
  static const double space2xl = 24; // 24dp
  static const double space3xl = 32; // 32dp
  static const double space4xl = 40; // 40dp
  static const double space5xl = 48; // 48dp
  static const double space6xl = 64; // 64dp

  /// Semantic spacing aliases for common patterns.
  static const double screenPadding = spaceLg;        // 16 - screen edges
  static const double sectionGap = spaceXl;           // 20 - between major sections
  static const double cardGap = spaceMd;              // 12 - between cards in a grid/list
  static const double cardPadding = spaceLg;          // 16 - inside cards
  static const double cardPaddingSm = spaceMd;        // 12 - compact card padding
  static const double inlineGap = spaceSm;            // 8 - between inline elements
  static const double formFieldGap = spaceLg;         // 16 - between form fields
  static const double buttonHeight = 48;              // 48 - standard button height
  static const double buttonHeightSm = 40;            // 40 - compact button height
  static const double fabSize = 56;                   // 56 - FAB diameter
  static const double iconSm = 16;                    // 16 - small icon
  static const double iconMd = 20;                    // 20 - medium icon
  static const double iconLg = 24;                    // 24 - large icon
  static const double iconXl = 28;                    // 28 - extra large icon
  static const double avatarSm = 32;                  // 32 - small avatar
  static const double avatarMd = 40;                  // 40 - medium avatar
  static const double avatarLg = 48;                  // 48 - large avatar
  static const double avatarXl = 64;                  // 64 - extra large avatar

  /// Border radius scale.
  static const double radiusXs = 4;    // 4dp
  static const double radiusSm = 8;    // 8dp
  static const double radiusMd = 12;   // 12dp
  static const double radiusLg = 16;   // 16dp
  static const double radiusXl = 20;   // 20dp
  static const double radius2xl = 24;  // 24dp
  static const double radiusFull = 9999; // Fully rounded

  /// Semantic radius aliases.
  static const double inputRadius = radiusMd;    // 12 - text fields, chips
  static const double buttonRadius = radiusMd;   // 12 - buttons
  static const double cardRadius = radiusLg;     // 16 - cards
  static const double dialogRadius = radiusXl;   // 20 - dialogs
  static const double sheetRadius = radius2xl;   // 24 - bottom sheets
  static const double chipRadius = radiusFull;   // Fully rounded - chips, badges

  /// Elevation / shadow scale.
  static const double elevationNone = 0;
  static const double elevationSm = 1;   // Subtle - cards
  static const double elevationMd = 3;   // Medium - elevated cards, FAB
  static const double elevationLg = 6;   // High - dialogs, sheets
  static const double elevationXl = 12;  // Very high - modals

  /// Animation durations.
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 250);
  static const Duration durationSlow = Duration(milliseconds: 400);
  static const Duration durationPage = Duration(milliseconds: 300);

  /// Stagger delay for list/item animations.
  static const Duration staggerDelay = Duration(milliseconds: 50);

  /// Minimum touch target size (Material guideline: 48x48dp).
  static const double minTouchTarget = 48;

  /// Maximum content width for centered layouts (tablet/desktop).
  static const double maxContentWidth = 600;

  /// Chart sizing.
  static const double chartHeightSm = 160;
  static const double chartHeightMd = 200;
  static const double chartHeightLg = 250;
  static const double chartHeightXl = 300;

  /// Safe area / system bar considerations.
  static const double bottomBarHeight = 56; // Standard navigation bar height
  static const double statusBarHeight = 24; // Approximate status bar height

  /// Content density.
  static const double listTileMinHeight = 56; // Minimum list tile height
  static const double denseListTileHeight = 48; // Dense list tile height
}

/// Typography tokens — semantic text styles mapped to Material TextTheme.
/// Use these via `AppTypography` extension on `BuildContext`.
class AppTypography {
  const AppTypography._();

  /// Display styles — largest, for hero sections.
  static const TextStyle displayLarge = TextStyle(
    fontSize: 57,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
    height: 1.12,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 45,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.16,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.22,
  );

  /// Headline styles — page titles, major sections.
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.25,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.29,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.33,
  );

  /// Title styles — section headers, card titles.
  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.27,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.33,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.4,
  );

  /// Body styles — main reading text.
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.43,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.33,
  );

  /// Label styles — buttons, chips, captions.
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.43,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.33,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.45,
  );

  /// Semantic style getters for common use cases.
  static TextStyle get pageTitle => headlineLarge;
  static TextStyle get sectionTitle => titleLarge;
  static TextStyle get cardTitle => titleMedium;
  static TextStyle get cardSubtitle => bodyMedium;
  static TextStyle get formLabel => labelLarge;
  static TextStyle get formHint => bodySmall;
  static TextStyle get buttonLabel => labelLarge;
  static TextStyle get chipLabel => labelMedium;
  static TextStyle get statValue => headlineMedium.copyWith(fontWeight: FontWeight.w700);
  static TextStyle get statLabel => labelSmall;
  static TextStyle get caption => bodySmall;
  static TextStyle get overline => labelSmall;
  static TextStyle get disclaimer => bodySmall;
}

/// Extension for easy access to design tokens in build context.
extension AppTokensExt on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
}