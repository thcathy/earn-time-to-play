import 'package:flutter/services.dart';
import '../core/constants.dart';

/// Parsing, validation, and typing constraints for minute fields.
class MinutesInput {
  MinutesInput._();

  static final int maxDigits =
      AppConstants.maxManualEntryMinutes.toString().length;

  /// Digits only, capped at [maxDigits]. That also caps the numeric value.
  static final List<TextInputFormatter> formatters = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(maxDigits),
  ];

  static bool isValid(int value, {int min = 0}) {
    return value >= min && value <= AppConstants.maxManualEntryMinutes;
  }
}
