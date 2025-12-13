import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/day_entry.dart';
import '../models/settings.dart';
import '../services/storage_service.dart';
import '../utils/time_utils.dart';

/// State class for the time bank
class TimeBankState {
  final List<DayEntry> entries;
  final AppSettings settings;
  final bool isLoading;

  const TimeBankState({
    this.entries = const [],
    this.settings = const AppSettings(),
    this.isLoading = true,
  });

  TimeBankState copyWith({
    List<DayEntry>? entries,
    AppSettings? settings,
    bool? isLoading,
  }) {
    return TimeBankState(
      entries: entries ?? this.entries,
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  /// Get today's entry (or create a virtual one if not exists)
  DayEntry get todayEntry {
    final todayKey = TimeUtils.todayKey();
    return entries.firstWhere(
      (e) => e.date == todayKey,
      orElse: () => DayEntry(date: todayKey),
    );
  }

  /// Calculate the cumulative balance from all entries
  int get currentBalance {
    int balance = settings.startingBalance;
    // Sort entries by date (oldest first) for cumulative calculation
    final sortedEntries = List<DayEntry>.from(entries)
      ..sort((a, b) => a.date.compareTo(b.date));
    for (final entry in sortedEntries) {
      balance += entry.delta;
    }
    return balance;
  }

  /// Check if user can play (balance >= 0 or overdraft allowed)
  bool get canPlay => settings.allowOverdraft || currentBalance >= 0;

  /// Check if balance is at or below warning threshold
  bool get isWarning => currentBalance <= settings.warningThreshold && currentBalance >= 0;

  /// Check if in overdraft (balance < 0)
  bool get isOverdraft => currentBalance < 0;

  /// Get entries sorted by date (newest first)
  List<DayEntry> get sortedEntries {
    final sorted = List<DayEntry>.from(entries);
    sorted.sort((a, b) => b.date.compareTo(a.date));
    return sorted;
  }

  /// Get entries with cumulative balance for each day
  List<({DayEntry entry, int cumulativeBalance})> get entriesWithBalance {
    final sorted = List<DayEntry>.from(entries);
    sorted.sort((a, b) => a.date.compareTo(b.date)); // Oldest first

    int balance = settings.startingBalance;
    final result = <({DayEntry entry, int cumulativeBalance})>[];

    for (final entry in sorted) {
      balance += entry.delta;
      result.add((entry: entry, cumulativeBalance: balance));
    }

    return result.reversed.toList(); // Return newest first
  }

  /// Calculate total focus minutes
  int get totalFocusMinutes {
    return entries.fold(0, (sum, entry) => sum + entry.learningMinutes);
  }

  /// Calculate total play minutes
  int get totalPlayMinutes {
    return entries.fold(0, (sum, entry) => sum + entry.gamingMinutes);
  }

  /// Calculate average daily balance (delta)
  double get averageDailyDelta {
    if (entries.isEmpty) return 0;
    final totalDelta = entries.fold(0, (sum, entry) => sum + entry.delta);
    return totalDelta / entries.length;
  }

  /// Calculate current streak of positive balance days
  int get positiveBalanceStreak {
    if (entries.isEmpty) return 0;

    final sorted = List<DayEntry>.from(entries);
    sorted.sort((a, b) => b.date.compareTo(a.date)); // Newest first

    int streak = 0;
    int balance = currentBalance;

    for (final entry in sorted) {
      if (balance >= 0) {
        streak++;
        balance -= entry.delta;
      } else {
        break;
      }
    }

    return streak;
  }
}

/// Provider for the time bank state
final timeBankProvider = StateNotifierProvider<TimeBankNotifier, TimeBankState>((ref) {
  return TimeBankNotifier();
});

/// Notifier for managing time bank state
class TimeBankNotifier extends StateNotifier<TimeBankState> {
  TimeBankNotifier() : super(const TimeBankState()) {
    _loadData();
  }

  final _storage = StorageService.instance;

  Future<void> _loadData() async {
    final entries = _storage.getEntriesSorted();
    final settings = _storage.getSettings();
    state = state.copyWith(
      entries: entries,
      settings: settings,
      isLoading: false,
    );
  }

  /// Refresh data from storage
  Future<void> refresh() async {
    await _loadData();
  }

  /// Add focus minutes to today
  Future<void> addFocus(int minutes) async {
    final todayKey = TimeUtils.todayKey();
    final entry = _storage.getOrCreateEntry(todayKey);
    entry.learningMinutes += minutes;
    await _storage.saveEntry(entry);
    await _loadData();
  }

  /// Add play minutes to today
  Future<void> addPlay(int minutes) async {
    final todayKey = TimeUtils.todayKey();
    final entry = _storage.getOrCreateEntry(todayKey);
    entry.gamingMinutes += minutes;
    await _storage.saveEntry(entry);
    await _loadData();
  }

  /// Update a specific day's entry
  Future<void> updateEntry(String date, {int? learningMinutes, int? gamingMinutes}) async {
    var entry = _storage.getEntry(date);
    if (entry == null) {
      entry = DayEntry(
        date: date,
        learningMinutes: learningMinutes ?? 0,
        gamingMinutes: gamingMinutes ?? 0,
      );
    } else {
      if (learningMinutes != null) {
        entry.learningMinutes = learningMinutes;
      }
      if (gamingMinutes != null) {
        entry.gamingMinutes = gamingMinutes;
      }
    }
    await _storage.saveEntry(entry);
    await _loadData();
  }

  /// Delete a day's entry
  Future<void> deleteEntry(String date) async {
    await _storage.deleteEntry(date);
    await _loadData();
  }

  /// Update settings
  Future<void> updateSettings(AppSettings newSettings) async {
    await _storage.saveSettings(newSettings);
    state = state.copyWith(settings: newSettings);
  }

  /// Update starting balance
  Future<void> setStartingBalance(int balance) async {
    final newSettings = state.settings.copyWith(startingBalance: balance);
    await updateSettings(newSettings);
  }

  /// Toggle allow overdraft
  Future<void> toggleAllowOverdraft() async {
    final newSettings = state.settings.copyWith(allowOverdraft: !state.settings.allowOverdraft);
    await updateSettings(newSettings);
  }

  /// Set warning threshold
  Future<void> setWarningThreshold(int threshold) async {
    final newSettings = state.settings.copyWith(warningThreshold: threshold);
    await updateSettings(newSettings);
  }

  /// Set max play per day
  Future<void> setMaxPlayPerDay(int? max) async {
    final newSettings = max == null
        ? state.settings.copyWith(clearMaxGamingPerDay: true)
        : state.settings.copyWith(maxGamingPerDay: max);
    await updateSettings(newSettings);
  }

  /// Export data to CSV
  String exportToCsv() {
    return _storage.exportToCsv();
  }

  /// Reset all data
  Future<void> resetAllData() async {
    await _storage.resetAllData();
    state = const TimeBankState(isLoading: false);
    await _loadData();
  }
}

