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

    test('allows three digits', () {
      final result = applyAll(
        TextEditingValue.empty,
        const TextEditingValue(text: '999'),
      );
      expect(result.text, '999');
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
}
