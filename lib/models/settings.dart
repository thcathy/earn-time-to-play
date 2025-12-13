import 'package:flutter/material.dart';
import '../core/constants.dart';

/// App settings model
class AppSettings {
  final int startingBalance;
  final bool allowOverdraft;
  final int warningThreshold;
  final int? maxGamingPerDay;
  final ThemeMode themeMode;

  const AppSettings({
    this.startingBalance = AppConstants.defaultStartingBalance,
    this.allowOverdraft = AppConstants.defaultAllowOverdraft,
    this.warningThreshold = AppConstants.defaultWarningThreshold,
    this.maxGamingPerDay,
    this.themeMode = ThemeMode.system,
  });

  AppSettings copyWith({
    int? startingBalance,
    bool? allowOverdraft,
    int? warningThreshold,
    int? maxGamingPerDay,
    bool clearMaxGamingPerDay = false,
    ThemeMode? themeMode,
  }) {
    return AppSettings(
      startingBalance: startingBalance ?? this.startingBalance,
      allowOverdraft: allowOverdraft ?? this.allowOverdraft,
      warningThreshold: warningThreshold ?? this.warningThreshold,
      maxGamingPerDay: clearMaxGamingPerDay ? null : (maxGamingPerDay ?? this.maxGamingPerDay),
      themeMode: themeMode ?? this.themeMode,
    );
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'startingBalance': startingBalance,
      'allowOverdraft': allowOverdraft,
      'warningThreshold': warningThreshold,
      'maxGamingPerDay': maxGamingPerDay,
      'themeMode': themeMode.index,
    };
  }

  /// Create from JSON
  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      startingBalance: json['startingBalance'] as int? ?? AppConstants.defaultStartingBalance,
      allowOverdraft: json['allowOverdraft'] as bool? ?? AppConstants.defaultAllowOverdraft,
      warningThreshold: json['warningThreshold'] as int? ?? AppConstants.defaultWarningThreshold,
      maxGamingPerDay: json['maxGamingPerDay'] as int?,
      themeMode: ThemeMode.values[json['themeMode'] as int? ?? ThemeMode.system.index],
    );
  }

  @override
  String toString() {
    return 'AppSettings(startingBalance: $startingBalance, allowOverdraft: $allowOverdraft, '
        'warningThreshold: $warningThreshold, maxGamingPerDay: $maxGamingPerDay, themeMode: $themeMode)';
  }
}

