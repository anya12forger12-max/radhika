import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:radhika/services/storage_service.dart';

enum ThemeModeSetting {
  system,
  light,
  dark,
}

class ThemeState {
  final ThemeModeSetting setting;
  final double fontSize;

  const ThemeState({
    this.setting = ThemeModeSetting.system,
    this.fontSize = 1.0,
  });

  ThemeMode get themeMode {
    switch (setting) {
      case ThemeModeSetting.system:
        return ThemeMode.system;
      case ThemeModeSetting.light:
        return ThemeMode.light;
      case ThemeModeSetting.dark:
        return ThemeMode.dark;
    }
  }

  ThemeState copyWith({
    ThemeModeSetting? setting,
    double? fontSize,
  }) {
    return ThemeState(
      setting: setting ?? this.setting,
      fontSize: fontSize ?? this.fontSize,
    );
  }
}

class ThemeNotifier extends StateNotifier<ThemeState> {
  final StorageService _storageService;

  ThemeNotifier(this._storageService) : super(const ThemeState()) {
    _loadSettings();
  }

  void _loadSettings() {
    final themeStr = _storageService.getSetting('theme_mode');
    final fontSizeStr = _storageService.getSetting('font_size');
    state = ThemeState(
      setting: themeStr != null
          ? ThemeModeSetting.values[int.parse(themeStr)]
          : ThemeModeSetting.system,
      fontSize: fontSizeStr != null ? double.parse(fontSizeStr) : 1.0,
    );
  }

  Future<void> setThemeMode(ThemeModeSetting setting) async {
    state = state.copyWith(setting: setting);
    await _storageService.saveSetting('theme_mode', '${setting.index}');
  }

  Future<void> setFontSize(double size) async {
    state = state.copyWith(fontSize: size);
    await _storageService.saveSetting('font_size', '$size');
  }
}

final themeProvider =
    StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  final storageService = ref.read(storageServiceProvider);
  return ThemeNotifier(storageService);
});
