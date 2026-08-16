import 'package:earn_time_to_play/core/constants.dart';
import 'package:earn_time_to_play/utils/minutes_input_formatters.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TextEditingValue applyAll(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var value = newValue;
    for (final formatter in MinutesInputFormatters.minutes) {
      value = formatter.formatEditUpdate(oldValue, value);
    }
    return value;
  }

  group('MinutesInputFormatters', () {
    test('allows a valid minute value', () {
      final result = applyAll(
        TextEditingValue.empty,
        const TextEditingValue(text: '30'),
      );
      expect(result.text, '30');
    });

    test('allows the per-entry maximum', () {
      final maxText = AppConstants.maxManualEntryMinutes.toString();
      final result = applyAll(
        TextEditingValue.empty,
        TextEditingValue(text: maxText),
      );
      expect(result.text, maxText);
    });

    test('rejects a long digit string pasted in one go', () {
      final result = applyAll(
        TextEditingValue.empty,
        const TextEditingValue(text: '999999999'),
      );
      expect(
        result.text.length,
        lessThanOrEqualTo(MinutesInputFormatters.maxDigits),
      );
      final parsed = int.tryParse(result.text);
      if (parsed != null) {
        expect(parsed, lessThanOrEqualTo(AppConstants.maxManualEntryMinutes));
      } else {
        expect(result.text, isEmpty);
      }
    });

    test('strips non-digits', () {
      final result = applyAll(
        TextEditingValue.empty,
        const TextEditingValue(text: '12a3'),
      );
      expect(result.text, '123');
    });

    test('rejects a value just above the maximum', () {
      final maxText = AppConstants.maxManualEntryMinutes.toString();
      final aboveMax = (AppConstants.maxManualEntryMinutes + 1).toString();
      final result = applyAll(
        TextEditingValue(text: maxText),
        TextEditingValue(text: aboveMax),
      );
      expect(result.text, maxText);
    });
  });

  group('MaxIntValueFormatter', () {
    const formatter = MaxIntValueFormatter(100);

    test('keeps empty input', () {
      final result = formatter.formatEditUpdate(
        const TextEditingValue(text: '1'),
        TextEditingValue.empty,
      );
      expect(result.text, isEmpty);
    });

    test('rejects values above max', () {
      final result = formatter.formatEditUpdate(
        const TextEditingValue(text: '10'),
        const TextEditingValue(text: '101'),
      );
      expect(result.text, '10');
    });
  });
}
