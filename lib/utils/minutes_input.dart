import 'package:flutter/services.dart';
import '../core/constants.dart';

/// Parsing, validation, and typing constraints for minute fields.
class MinutesInput {
  MinutesInput._();

  static final int maxDigits =
      AppConstants.maxManualEntryMinutes.toString().length;

  /// Digits only, then a single cap on both length and numeric value.
  static final List<TextInputFormatter> formatters = [
    FilteringTextInputFormatter.digitsOnly,
    const MinutesValueFormatter(),
  ];

  static bool isValid(int value, {int min = 0}) {
    return value >= min && value <= AppConstants.maxManualEntryMinutes;
  }
}

/// Rejects an edit when it would exceed the digit cap or the per-entry max.
class MinutesValueFormatter extends TextInputFormatter {
  const MinutesValueFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    if (newValue.text.length > MinutesInput.maxDigits) {
      return oldValue;
    }
    final parsed = int.tryParse(newValue.text);
    if (parsed == null || parsed > AppConstants.maxManualEntryMinutes) {
      return oldValue;
    }
    return newValue;
  }
}
