import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';

/// Provider for the current theme mode
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

/// Notifier for managing theme mode
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _loadTheme();
  }

  void _loadTheme() {
    final settings = StorageService.instance.getSettings();
    state = settings.themeMode;
  }

  /// Set the theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final settings = StorageService.instance.getSettings();
    await StorageService.instance.saveSettings(settings.copyWith(themeMode: mode));
  }

  /// Toggle between light and dark mode
  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(newMode);
  }

  /// Cycle through theme modes: system -> light -> dark -> system
  Future<void> cycleTheme() async {
    final newMode = switch (state) {
      ThemeMode.system => ThemeMode.light,
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
    };
    await setThemeMode(newMode);
  }
}

