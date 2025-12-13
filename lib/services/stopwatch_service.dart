import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Persistent stopwatch state that survives app restarts
class StopwatchState {
  final bool isRunning;
  final DateTime? startTime;
  final String mode; // 'focus' or 'play'
  final int accumulatedMs; // Time accumulated before last pause

  StopwatchState({
    this.isRunning = false,
    this.startTime,
    this.mode = 'focus',
    this.accumulatedMs = 0,
  });

  /// Calculate total elapsed milliseconds
  int get elapsedMilliseconds {
    if (!isRunning || startTime == null) {
      return accumulatedMs;
    }
    return accumulatedMs + DateTime.now().difference(startTime!).inMilliseconds;
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() => {
    'isRunning': isRunning,
    'startTime': startTime?.toIso8601String(),
    'mode': mode,
    'accumulatedMs': accumulatedMs,
  };

  /// Create from JSON
  factory StopwatchState.fromJson(Map<String, dynamic> json) {
    return StopwatchState(
      isRunning: json['isRunning'] ?? false,
      startTime: json['startTime'] != null 
          ? DateTime.parse(json['startTime']) 
          : null,
      mode: json['mode'] ?? 'focus',
      accumulatedMs: json['accumulatedMs'] ?? 0,
    );
  }

  /// Create a copy with updated values
  StopwatchState copyWith({
    bool? isRunning,
    DateTime? startTime,
    String? mode,
    int? accumulatedMs,
    bool clearStartTime = false,
  }) {
    return StopwatchState(
      isRunning: isRunning ?? this.isRunning,
      startTime: clearStartTime ? null : (startTime ?? this.startTime),
      mode: mode ?? this.mode,
      accumulatedMs: accumulatedMs ?? this.accumulatedMs,
    );
  }
}

/// Service to manage persistent stopwatch state
class StopwatchService {
  static const _key = 'stopwatch_state';
  
  /// Load stopwatch state from storage
  static Future<StopwatchState> load() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_key);
    if (json == null) {
      return StopwatchState();
    }
    try {
      return StopwatchState.fromJson(jsonDecode(json));
    } catch (e) {
      return StopwatchState();
    }
  }

  /// Save stopwatch state to storage
  static Future<void> save(StopwatchState state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(state.toJson()));
  }

  /// Clear stopwatch state
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  /// Start the stopwatch
  static Future<StopwatchState> start(String mode) async {
    final state = StopwatchState(
      isRunning: true,
      startTime: DateTime.now(),
      mode: mode,
      accumulatedMs: 0,
    );
    await save(state);
    return state;
  }

  /// Pause the stopwatch (keeps accumulated time)
  static Future<StopwatchState> pause(StopwatchState current) async {
    final state = StopwatchState(
      isRunning: false,
      startTime: null,
      mode: current.mode,
      accumulatedMs: current.elapsedMilliseconds,
    );
    await save(state);
    return state;
  }

  /// Resume the stopwatch
  static Future<StopwatchState> resume(StopwatchState current) async {
    final state = StopwatchState(
      isRunning: true,
      startTime: DateTime.now(),
      mode: current.mode,
      accumulatedMs: current.accumulatedMs,
    );
    await save(state);
    return state;
  }

  /// Reset the stopwatch
  static Future<StopwatchState> reset() async {
    final state = StopwatchState();
    await clear();
    return state;
  }
}

