import 'package:hive_flutter/hive_flutter.dart';

part 'day_entry.g.dart';

/// Represents a single day's time tracking entry
@HiveType(typeId: 0)
class DayEntry extends HiveObject {
  @HiveField(0)
  final String date; // ISO format YYYY-MM-DD

  @HiveField(1)
  int learningMinutes;

  @HiveField(2)
  int gamingMinutes;

  DayEntry({
    required this.date,
    this.learningMinutes = 0,
    this.gamingMinutes = 0,
  });

  /// The difference between learning and gaming minutes for this day
  int get delta => learningMinutes - gamingMinutes;

  /// Create a copy with updated values
  DayEntry copyWith({
    String? date,
    int? learningMinutes,
    int? gamingMinutes,
  }) {
    return DayEntry(
      date: date ?? this.date,
      learningMinutes: learningMinutes ?? this.learningMinutes,
      gamingMinutes: gamingMinutes ?? this.gamingMinutes,
    );
  }

  /// Format focus time as human readable string
  String get focusFormatted => _formatMinutes(learningMinutes);

  /// Format play time as human readable string
  String get playFormatted => _formatMinutes(gamingMinutes);

  /// Format delta as human readable string with sign
  String get deltaFormatted {
    final prefix = delta >= 0 ? '+' : '';
    return '$prefix${_formatMinutes(delta)}';
  }

  String _formatMinutes(int minutes) {
    final absMinutes = minutes.abs();
    final hours = absMinutes ~/ 60;
    final mins = absMinutes % 60;
    final sign = minutes < 0 ? '-' : '';

    if (hours > 0 && mins > 0) {
      return '$sign${hours}h ${mins}m';
    } else if (hours > 0) {
      return '$sign${hours}h';
    } else {
      return '$sign${mins}m';
    }
  }

  @override
  String toString() {
    return 'DayEntry(date: $date, learning: $learningMinutes, gaming: $gamingMinutes, delta: $delta)';
  }
}

