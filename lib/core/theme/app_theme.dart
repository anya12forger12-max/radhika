import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

class AppTheme {
  AppTheme._();

  // Pre-computed seed colors — defined once, never per-build.
  static const Color _primaryColor = Color(0xFFE91E63);
  static const Color _secondaryColor = Color(0xFF9C27B0);
  static const Color _tertiaryColor = Color(0xFFFF9800);

  // Pre-computed color schemes — computed once at class load time,
  // not recomputed on every MaterialApp rebuild.
  static final ColorScheme _lightColorScheme = ColorScheme.fromSeed(
    seedColor: _primaryColor,
    brightness: Brightness.light,
    secondary: _secondaryColor,
    tertiary: _tertiaryColor,
  );

  static final ColorScheme _darkColorScheme = ColorScheme.fromSeed(
    seedColor: _primaryColor,
    brightness: Brightness.dark,
    secondary: _secondaryColor,
    tertiary: _tertiaryColor,
  );

  // High-contrast color scheme — WCAG AAA compliant (≥7:1 contrast),
  // built with ThemeData (not FlexThemeData) so blend levels don't wash out contrast.
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

  // Shared component sub-themes — single source of truth.
  static const FlexSubThemesData _subThemes = FlexSubThemesData(
    blendOnLevel: 10,
    blendOnColors: false,
    inputDecoratorRadius: 12,
    cardRadius: 16,
    elevatedButtonRadius: 12,
    filledButtonRadius: 12,
    outlinedButtonRadius: 12,
    textButtonRadius: 12,
    dialogRadius: 16,
    bottomSheetRadius: 20,
    bottomNavigationBarElevation: 2,
    navigationBarSelectedLabelSize: 14,
    navigationBarUnselectedLabelSize: 12,
  );

  static ThemeData light() => FlexThemeData.light(
    colorScheme: _lightColorScheme,
    appBarStyle: FlexAppBarStyle.background,
    tooltipsMatchBackground: true,
    surfaceMode: FlexSurfaceMode.level,
    blendLevel: 9,
    subThemesData: _subThemes,
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    fontFamily: 'System',
  ).copyWith(
    cardTheme: const CardThemeData(
      elevation: 0,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
  );

  static ThemeData dark() => FlexThemeData.dark(
    colorScheme: _darkColorScheme,
    appBarStyle: FlexAppBarStyle.background,
    tooltipsMatchBackground: true,
    surfaceMode: FlexSurfaceMode.level,
    blendLevel: 9,
    subThemesData: _subThemes,
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    fontFamily: 'System',
  ).copyWith(
    cardTheme: const CardThemeData(
      elevation: 0,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
  );

  static ThemeData highContrast() => ThemeData(
    useMaterial3: true,
    colorScheme: _highContrastColorScheme,
    fontFamily: 'System',
    visualDensity: VisualDensity.comfortable,
    cardTheme: const CardThemeData(
      elevation: 0,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
