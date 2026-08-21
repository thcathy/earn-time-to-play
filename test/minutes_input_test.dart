import 'package:earn_time_to_play/core/constants.dart';
import 'package:earn_time_to_play/utils/minutes_input.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TextEditingValue applyAll(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var value = newValue;
    for (final formatter in MinutesInput.formatters) {
      value = formatter.formatEditUpdate(oldValue, value);
    }
    return value;
  }

  group('MinutesInput.formatters', () {
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
      expect(result.text.length, lessThanOrEqualTo(MinutesInput.maxDigits));
    });

    test('strips non-digits', () {
      final result = applyAll(
        TextEditingValue.empty,
        const TextEditingValue(text: '12a3'),
      );
      expect(result.text, '123');
    });

    test('does not keep a fourth digit', () {
      final result = applyAll(
        const TextEditingValue(text: '999'),
        const TextEditingValue(text: '9991'),
      );
      expect(result.text, '999');
    });
  });

  group('MinutesInput.isValid', () {
    test('accepts zero when min is zero', () {
      expect(MinutesInput.isValid(0), isTrue);
    });

    test('rejects zero when min is one', () {
      expect(MinutesInput.isValid(0, min: 1), isFalse);
    });

    test('rejects values above the per-entry maximum', () {
      expect(
        MinutesInput.isValid(AppConstants.maxManualEntryMinutes + 1),
        isFalse,
      );
    });
  });
}
