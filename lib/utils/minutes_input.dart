import 'package:flutter/services.dart';

/// Digits only, three characters — one field cannot take a long number.
class MinutesInput {
  MinutesInput._();

  static const int maxDigits = 3;

  static final List<TextInputFormatter> formatters = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(maxDigits),
  ];
}
