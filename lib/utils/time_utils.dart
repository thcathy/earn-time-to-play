import 'package:intl/intl.dart';

/// Utility functions for time formatting and date operations
class TimeUtils {
  TimeUtils._();

  static final _dateFormat = DateFormat('yyyy-MM-dd');
  static final _displayDateFormat = DateFormat('MMM d, yyyy');
  static final _shortDateFormat = DateFormat('MMM d');
  static final _weekdayFormat = DateFormat('EEEE');

  /// Get today's date as ISO string (YYYY-MM-DD)
  static String todayKey() {
    return _dateFormat.format(DateTime.now());
  }

  /// Format a date string for display
  /// Pass [todayLabel] and [yesterdayLabel] for localized strings
  static String formatDateForDisplay(String isoDate, {String? todayLabel, String? yesterdayLabel}) {
    try {
      final date = _dateFormat.parse(isoDate);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      final dateOnly = DateTime(date.year, date.month, date.day);

      if (dateOnly == today) {
        return todayLabel ?? 'Today';
      } else if (dateOnly == yesterday) {
        return yesterdayLabel ?? 'Yesterday';
      } else if (dateOnly.isAfter(today.subtract(const Duration(days: 7)))) {
        return _weekdayFormat.format(date);
      } else {
        return _displayDateFormat.format(date);
      }
    } catch (e) {
      return isoDate;
    }
  }

  /// Format date as short display (e.g., "Dec 8")
  static String formatDateShort(String isoDate) {
    try {
      final date = _dateFormat.parse(isoDate);
      return _shortDateFormat.format(date);
    } catch (e) {
      return isoDate;
    }
  }

  /// Format minutes as human readable string
  static String formatMinutes(int minutes) {
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

  /// Format minutes with explicit sign
  static String formatMinutesWithSign(int minutes) {
    final prefix = minutes >= 0 ? '+' : '';
    return '$prefix${formatMinutes(minutes)}';
  }

  /// Format minutes as hours with decimal (e.g., "2.5h")
  static String formatMinutesAsHours(int minutes) {
    final hours = minutes / 60;
    if (hours == hours.roundToDouble()) {
      return '${hours.toInt()}h';
    }
    return '${hours.toStringAsFixed(1)}h';
  }

  /// Get start of week (Monday) for a given date
  static DateTime startOfWeek(DateTime date) {
    final weekday = date.weekday;
    return DateTime(date.year, date.month, date.day - (weekday - 1));
  }

  /// Get start of month for a given date
  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Parse ISO date string to DateTime
  static DateTime parseDate(String isoDate) {
    return _dateFormat.parse(isoDate);
  }

  /// Format DateTime to ISO date string
  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }

  /// Get list of dates from start to end (inclusive)
  static List<String> getDateRange(DateTime start, DateTime end) {
    final dates = <String>[];
    var current = start;
    while (!current.isAfter(end)) {
      dates.add(formatDate(current));
      current = current.add(const Duration(days: 1));
    }
    return dates;
  }

  /// Get the last N days as date strings
  static List<String> getLastNDays(int n) {
    final dates = <String>[];
    final now = DateTime.now();
    for (var i = 0; i < n; i++) {
      final date = now.subtract(Duration(days: i));
      dates.add(formatDate(date));
    }
    return dates;
  }
}

