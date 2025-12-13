import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _localeKey = 'app_locale';

/// Supported locales
enum AppLocale {
  system('system', 'System', null),
  english('en', 'English', Locale('en')),
  traditionalChinese('zh_TW', '繁體中文', Locale('zh', 'TW')),
  simplifiedChinese('zh_CN', '简体中文', Locale('zh', 'CN'));

  final String code;
  final String displayName;
  final Locale? locale;

  const AppLocale(this.code, this.displayName, this.locale);

  static AppLocale fromCode(String code) {
    return AppLocale.values.firstWhere(
      (l) => l.code == code,
      orElse: () => AppLocale.system,
    );
  }
}

/// Provider for locale state
final localeProvider = StateNotifierProvider<LocaleNotifier, AppLocale>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<AppLocale> {
  LocaleNotifier() : super(AppLocale.system) {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_localeKey) ?? 'system';
    state = AppLocale.fromCode(code);
  }

  Future<void> setLocale(AppLocale locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.code);
  }
}

