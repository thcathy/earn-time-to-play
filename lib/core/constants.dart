/// App-wide constants
class AppConstants {
  AppConstants._();

  // Storage keys
  static const String entriesBoxName = 'day_entries';
  static const String settingsKey = 'app_settings';
  static const String themeKey = 'theme_mode';

  // Default values
  static const int defaultStartingBalance = 0;
  static const int defaultWarningThreshold = 30;
  static const bool defaultAllowOverdraft = false;

  // Quick add options (in minutes)
  static const List<int> quickAddOptions = [15, 30, 60];

  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 150);
  static const Duration mediumAnimation = Duration(milliseconds: 200);
  static const Duration longAnimation = Duration(milliseconds: 300);
}

