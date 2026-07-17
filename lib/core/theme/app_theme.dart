import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

class AppTheme {
  AppTheme._();

  static const Color _primaryColor = Color(0xFFE91E63);
  static const Color _secondaryColor = Color(0xFF9C27B0);
  static const Color _tertiaryColor = Color(0xFFFF9800);

  static ThemeData light() {
    return FlexThemeData.light(
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        brightness: Brightness.light,
        secondary: _secondaryColor,
        tertiary: _tertiaryColor,
      ),
      appBarStyle: FlexAppBarStyle.background,
      tooltipsMatchBackground: true,
      surfaceMode: FlexSurfaceMode.level,
      blendLevel: 9,
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 10,
        blendOnColors: false,
        inputDecoratorRadius: 12,
        cardRadius: 16,
        buttonRadius: 12,
        dialogRadius: 16,
        bottomSheetRadius: 20,
        bottomNavigationBarElevation: 2,
        navigationBarSelectedLabelSize: 14,
        navigationBarUnselectedLabelSize: 12,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
      fontFamily: 'System',
    );
  }

  static ThemeData dark() {
    return FlexThemeData.dark(
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        brightness: Brightness.dark,
        secondary: _secondaryColor,
        tertiary: _tertiaryColor,
      ),
      appBarStyle: FlexAppBarStyle.background,
      tooltipsMatchBackground: true,
      surfaceMode: FlexSurfaceMode.level,
      blendLevel: 9,
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 10,
        blendOnColors: false,
        inputDecoratorRadius: 12,
        cardRadius: 16,
        buttonRadius: 12,
        dialogRadius: 16,
        bottomSheetRadius: 20,
        bottomNavigationBarElevation: 2,
        navigationBarSelectedLabelSize: 14,
        navigationBarUnselectedLabelSize: 12,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
      fontFamily: 'System',
    );
  }

  static ThemeData highContrast() {
    final base = light();
    return base.copyWith(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: base.colorScheme.copyWith(
        brightness: Brightness.light,
      ),
    );
  }
}
