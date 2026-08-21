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

    test('allows zero', () {
      final result = applyAll(
        TextEditingValue.empty,
        const TextEditingValue(text: '0'),
      );
      expect(result.text, '0');
    });

    test('allows the three-digit maximum', () {
      final maxText = AppConstants.maxManualEntryMinutes.toString();
      final result = applyAll(
        TextEditingValue.empty,
        TextEditingValue(text: maxText),
      );
      expect(result.text, maxText);
    });

    test('does not keep extra digits from a long paste', () {
      final result = applyAll(
        TextEditingValue.empty,
        const TextEditingValue(text: '999999999'),
      );
      expect(result.text.length, MinutesInput.maxDigits);
    });

    test('strips non-digits', () {
      final result = applyAll(
        TextEditingValue.empty,
        const TextEditingValue(text: '12a3'),
      );
      expect(result.text, '123');
    });
  });

  group('MinutesInput.canAdd', () {
    test('rejects zero', () {
      expect(MinutesInput.canAdd(0), isFalse);
    });

    test('accepts one minute', () {
      expect(MinutesInput.canAdd(1), isTrue);
    });

    test('rejects values above the three-digit maximum', () {
      expect(
        MinutesInput.canAdd(AppConstants.maxManualEntryMinutes + 1),
        isFalse,
      );
    });
  });
}
