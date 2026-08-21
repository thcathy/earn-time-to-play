import 'package:flutter/services.dart';
import '../core/constants.dart';

/// Typing constraints for minute fields: digits only, three characters.
class MinutesInput {
  MinutesInput._();

  static final int maxDigits =
      AppConstants.maxManualEntryMinutes.toString().length;

  static final List<TextInputFormatter> formatters = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(maxDigits),
  ];

  /// Today add: at least one minute, and within the three-digit max.
  static bool canAdd(int minutes) {
    return minutes >= 1 && minutes <= AppConstants.maxManualEntryMinutes;
  }
}
