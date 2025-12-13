import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';
import '../models/day_entry.dart';
import '../models/settings.dart';

/// Service for persisting data to local storage
class StorageService {
  static StorageService? _instance;
  late Box<DayEntry> _entriesBox;
  late SharedPreferences _prefs;

  StorageService._();

  static StorageService get instance {
    _instance ??= StorageService._();
    return _instance!;
  }

  /// Initialize storage - must be called before using the service
  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter(DayEntryAdapter());
    _entriesBox = await Hive.openBox<DayEntry>(AppConstants.entriesBoxName);
    _prefs = await SharedPreferences.getInstance();
  }

  // ==================== Day Entries ====================

  /// Get all day entries
  List<DayEntry> getAllEntries() {
    return _entriesBox.values.toList();
  }

  /// Get entry for a specific date
  DayEntry? getEntry(String date) {
    return _entriesBox.get(date);
  }

  /// Get or create entry for a specific date
  DayEntry getOrCreateEntry(String date) {
    var entry = _entriesBox.get(date);
    if (entry == null) {
      entry = DayEntry(date: date);
      _entriesBox.put(date, entry);
    }
    return entry;
  }

  /// Save or update a day entry
  Future<void> saveEntry(DayEntry entry) async {
    await _entriesBox.put(entry.date, entry);
  }

  /// Delete a day entry
  Future<void> deleteEntry(String date) async {
    await _entriesBox.delete(date);
  }

  /// Delete all entries
  Future<void> clearAllEntries() async {
    await _entriesBox.clear();
  }

  /// Get entries for a date range (inclusive)
  List<DayEntry> getEntriesInRange(String startDate, String endDate) {
    return _entriesBox.values
        .where((entry) => entry.date.compareTo(startDate) >= 0 && entry.date.compareTo(endDate) <= 0)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // Newest first
  }

  /// Get entries sorted by date (newest first)
  List<DayEntry> getEntriesSorted() {
    final entries = _entriesBox.values.toList();
    entries.sort((a, b) => b.date.compareTo(a.date));
    return entries;
  }

  // ==================== Settings ====================

  /// Get app settings
  AppSettings getSettings() {
    final json = _prefs.getString(AppConstants.settingsKey);
    if (json == null) {
      return const AppSettings();
    }
    try {
      return AppSettings.fromJson(jsonDecode(json));
    } catch (e) {
      return const AppSettings();
    }
  }

  /// Save app settings
  Future<void> saveSettings(AppSettings settings) async {
    await _prefs.setString(AppConstants.settingsKey, jsonEncode(settings.toJson()));
  }

  /// Reset settings to defaults
  Future<void> resetSettings() async {
    await _prefs.remove(AppConstants.settingsKey);
  }

  // ==================== Export ====================

  /// Export all data as CSV string
  String exportToCsv() {
    final entries = getEntriesSorted();
    final buffer = StringBuffer();
    
    // Header
    buffer.writeln('Date,Learning Minutes,Gaming Minutes,Delta,Cumulative Balance');
    
    // Calculate cumulative balance
    final settings = getSettings();
    int cumulativeBalance = settings.startingBalance;
    
    // Sort entries oldest first for cumulative calculation
    final sortedEntries = entries.reversed.toList();
    final balances = <String, int>{};
    
    for (final entry in sortedEntries) {
      cumulativeBalance += entry.delta;
      balances[entry.date] = cumulativeBalance;
    }
    
    // Write entries newest first
    for (final entry in entries) {
      buffer.writeln(
        '${entry.date},${entry.learningMinutes},${entry.gamingMinutes},${entry.delta},${balances[entry.date]}',
      );
    }
    
    return buffer.toString();
  }

  // ==================== Reset ====================

  /// Reset all data (entries and settings)
  Future<void> resetAllData() async {
    await clearAllEntries();
    await resetSettings();
  }
}

