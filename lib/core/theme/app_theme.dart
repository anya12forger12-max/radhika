import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // ============================================================================
  // Color Palette — Vibrant Berry/Rose Modern Identity
  // ============================================================================
  // Primary color family: Rose (warm, welcoming, energetic)
  //
  // The seed color (0xFFE91E63 = rose500) drives the Material 3 color scheme
  // via ColorScheme.fromSeed. Extended tokens below are convenience references
  // for theming patterns.
  //
  // Color system tokens (derived from seed via Material 3):
  //   ColorScheme.primary — rose500 (0xFFE91E63)
  //   ColorScheme.onPrimary — rose900 (contrast text on primary)
  //   ColorScheme.secondary — purple500 (0xFF9C27B0)
  //   ColorScheme.tertiary — orange500 (0xFFFF9800)
  //   ColorScheme.surface — surface (light) / surface (dark)
  //   ColorScheme.onSurface — onSurface text color
  //
  // Extended convenience references (by hue + shade):
  //   rose50  through rose900   — rose family shades
  //   purple50 through purple900 — purple family shades
  //   orange50 through orange900 — orange family shades
  //
  // Status colors (accessible):
  //   ColorScheme.error — error red
  //   Custom success/warning if needed

  // Rose family — primary warmth
  static const Color rose50 = Color(0xFFFFF8F1);
  static const Color rose100 = Color(0xFFFFF0E5);
  static const Color rose200 = Color(0xFFFFE0D2);
  static const Color rose300 = Color(0xFFFFC8C0);
  static const Color rose400 = Color(0xFFFFA89B);
  static const Color rose500 = Color(0xFFE91E63); // Primary seed
  static const Color rose600 = Color(0xFFD81B60);
  static const Color rose700 = Color(0xFFC2185B);
  static const Color rose800 = Color(0xFFA2145E);
  static const Color rose900 = Color(0xFF880E4F);

  // Purple family — secondary depth
  static const Color purple50 = Color(0xFFF3E5F5);
  static const Color purple100 = Color(0xFFE8EAF6);
  static const Color purple200 = Color(0xFFD1C4E9);
  static const Color purple300 = Color(0xFFB3C6E7);
  static const Color purple400 = Color(0xFF9FA8DA);
  static const Color purple500 = Color(0xFF9C27B0); // Secondary seed
  static const Color purple600 = Color(0xFF8E24AA);
  static const Color purple700 = Color(0xFF7B1FA2);
  static const Color purple800 = Color(0xFF6A1B9A);
  static const Color purple900 = Color(0xFF4A148C);

  // Orange family — tertiary enthusiasm
  static const Color orange50 = Color(0xFFFFF3E0);
  static const Color orange100 = Color(0xFFFFF8E1);
  static const Color orange200 = Color(0xFFFFF3CD);
  static const Color orange300 = Color(0xFFFFF0C3);
  static const Color orange400 = Color(0xFFFFE8B6);
  static const Color orange500 = Color(0xFFFF9800); // Tertiary seed
  static const Color orange600 = Color(0xFFFB8C00);
  static const Color orange700 = Color(0xFFF57C00);
  static const Color orange800 = Color(0xFFEF6C00);
  static const Color orange900 = Color(0xFFE65100);

  // Convenience getters for common theme references
  // These are accessed as AppTheme.cardBorderRadius, AppTheme.cardSurface, etc.
  // They are defined as static constants so they can be referenced without a Theme context.
  // When used inside a BuildContext, prefer Theme.of(context).colorScheme, etc.

  // Card and spacing tokens
  static BorderRadius cardBorderRadius = BorderRadius.circular(16);
  static const EdgeInsets cardPadding = EdgeInsets.all(16);
  static const EdgeInsets screenPadding =
      EdgeInsets.symmetric(horizontal: 24, vertical: 16);
  static const EdgeInsets sectionPadding =
      EdgeInsets.symmetric(horizontal: 20, vertical: 12);
  static const EdgeInsets cardMargin =
      EdgeInsets.symmetric(horizontal: 16, vertical: 8);
  static const EdgeInsets spacingSm =
      EdgeInsets.symmetric(horizontal: 8, vertical: 4);
  static const EdgeInsets spacingMd =
      EdgeInsets.symmetric(horizontal: 12, vertical: 8);
  static const EdgeInsets spacingLg =
      EdgeInsets.symmetric(horizontal: 16, vertical: 16);

  // Surface colors
  static const Color cardSurface = Color(0xFFFFFFFF);

  // Color scheme reference colors (for use in widgets that can't use Theme.of(context))
  // These are derived from the rose500 seed color via Material 3
  static const Color colorSchemePrimaryContainer = Color(0xFFF3E5F5); // equivalent to purple50 in light
  static const Color colorSchemeOnPrimaryContainer = Color(0xFF4A148C); // purple900

  // ============================================================================
  // High-Contrast Color Scheme (WCAG AAA, >= 7:1) — kept as a real scheme
  // (not a copy of light()) so any future wiring of a high-contrast mode
  // actually delivers AAA contrast.
  // ============================================================================
  static const ColorScheme _highContrastColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF000000),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFF000000),
    onPrimaryContainer: Color(0xFFFFFFFF),
    secondary: Color(0xFF333333),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFF333333),
    onSecondaryContainer: Color(0xFFFFFFFF),
    tertiary: Color(0xFF000000),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFF000000),
    onTertiaryContainer: Color(0xFFFFFFFF),
    error: Color(0xFFB00020),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFB00020),
    onErrorContainer: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF000000),
    surfaceContainerHighest: Color(0xFFFFFFFF),
    onSurfaceVariant: Color(0xFF000000),
    outline: Color(0xFF000000),
    outlineVariant: Color(0xFF000000),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFF000000),
    onInverseSurface: Color(0xFFFFFFFF),
    inversePrimary: Color(0xFFFFFFFF),
    surfaceTint: Color(0xFF000000),
  );

  // ============================================================================
  // Light Theme
  // ============================================================================

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'System',
      visualDensity: VisualDensity.comfortable,
      colorScheme: ColorScheme.fromSeed(
        seedColor: rose500,
        brightness: Brightness.light,
      ),
      cardColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      cardTheme: const CardThemeData(
        elevation: 0,
        margin: cardMargin,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF757575)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF757575)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: rose500, width: 2),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFD32F2F)),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFD32F2F), width: 2),
        ),
        filled: true,
        fillColor: rose50.withAlpha(30),
        labelStyle: const TextStyle(color: Color(0xFF616161)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: rose50,
        foregroundColor: rose900,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: rose800,
        unselectedItemColor: rose700,
        backgroundColor: rose50,
        elevation: 2,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: rose500,
        elevation: 6,
      ),
      shadowColor: const Color(0x1A000000),
    );
  }

  // ============================================================================
  // Dark Theme
  // ============================================================================

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'System',
      visualDensity: VisualDensity.comfortable,
      colorScheme: ColorScheme.fromSeed(
        seedColor: rose500,
        brightness: Brightness.dark,
      ),
      cardColor: const Color(0xFF1E1E1E),
      scaffoldBackgroundColor: const Color(0xFF121212),
      cardTheme: const CardThemeData(
        elevation: 0,
        margin: cardMargin,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF757575)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF757575)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: rose500, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFD32F2F)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFD32F2F), width: 2),
        ),
        filled: true,
        fillColor: Color(0xFF2C2C2C),
        labelStyle: TextStyle(color: Color(0xFFB0BEC5)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: rose300,
        unselectedItemColor: rose200,
        backgroundColor: Color(0xFF1E1E1E),
        elevation: 2,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: rose500,
        elevation: 6,
      ),
      shadowColor: const Color(0x1A000000),
    );
  }

  // ============================================================================
  // High Contrast Theme (accessibility) — WCAG AAA (>= 7:1)
  // ============================================================================

  static ThemeData highContrast() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'System',
      visualDensity: VisualDensity.comfortable,
      colorScheme: _highContrastColorScheme,
      cardColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      cardTheme: const CardThemeData(
        elevation: 0,
        margin: cardMargin,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: Color(0xFF000000), fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: Color(0xFF000000), fontWeight: FontWeight.bold),
        displaySmall: TextStyle(color: Color(0xFF000000), fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(color: Color(0xFF000000), fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: Color(0xFF000000), fontWeight: FontWeight.bold),
        headlineSmall: TextStyle(color: Color(0xFF000000), fontWeight: FontWeight.bold),
        titleLarge: TextStyle(color: Color(0xFF000000), fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: Color(0xFF000000), fontWeight: FontWeight.bold),
        titleSmall: TextStyle(color: Color(0xFF000000), fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: Color(0xFF000000)),
        bodyMedium: TextStyle(color: Color(0xFF000000)),
        bodySmall: TextStyle(color: Color(0xFF000000)),
        labelLarge: TextStyle(color: Color(0xFF000000)),
        labelMedium: TextStyle(color: Color(0xFF000000)),
        labelSmall: TextStyle(color: Color(0xFF000000)),
      ),
    );
  }
}
