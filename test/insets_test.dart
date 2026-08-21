import 'package:earn_time_to_play/utils/insets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('edgeToEdgeContentPadding', () {
    test('adds system bar padding when the keyboard is closed', () {
      const mediaQuery = MediaQueryData(
        padding: EdgeInsets.fromLTRB(8, 48, 12, 32),
        viewPadding: EdgeInsets.fromLTRB(8, 48, 12, 32),
      );

      expect(
        edgeToEdgeContentPadding(mediaQuery),
        const EdgeInsets.fromLTRB(32, 24, 36, 56),
      );
    });

    test('adds keyboard inset and keeps remaining padding', () {
      const mediaQuery = MediaQueryData(
        padding: EdgeInsets.fromLTRB(0, 48, 0, 0),
        viewPadding: EdgeInsets.fromLTRB(0, 48, 0, 32),
        viewInsets: EdgeInsets.only(bottom: 300),
      );

      expect(
        edgeToEdgeContentPadding(mediaQuery, base: 16),
        const EdgeInsets.fromLTRB(16, 16, 16, 316),
      );
    });
  });
}
