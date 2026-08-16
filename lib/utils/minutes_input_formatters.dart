import 'package:flutter/services.dart';
import '../core/constants.dart';

/// Shared input formatters for minute values.
///
/// Limits how many digits can be entered at once so a single field cannot
/// accept an unbounded number string.
class MinutesInputFormatters {
  MinutesInputFormatters._();

  static final int maxDigits =
      AppConstants.maxManualEntryMinutes.toString().length;

  /// Digits only, short length, and value cannot exceed the per-entry max.
  static final List<TextInputFormatter> minutes = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(maxDigits),
    MaxIntValueFormatter(AppConstants.maxManualEntryMinutes),
  ];
}

/// Rejects an edit when the parsed integer would exceed [max].
class MaxIntValueFormatter extends TextInputFormatter {
  const MaxIntValueFormatter(this.max);

  final int max;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    final parsed = int.tryParse(newValue.text);
    if (parsed == null || parsed > max) {
      return oldValue;
    }
    return newValue;
  }
}
