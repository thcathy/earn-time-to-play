import 'package:flutter_test/flutter_test.dart';
import 'package:earn_time_to_play/utils/time_utils.dart';

void main() {
  group('TimeUtils.calculateTrackingStreak', () {
    test('returns 0 for empty activity', () {
      expect(
        TimeUtils.calculateTrackingStreak(
          [],
          now: DateTime(2026, 8, 8),
        ),
        0,
      );
    });

    test('counts consecutive days ending today', () {
      expect(
        TimeUtils.calculateTrackingStreak(
          ['2026-08-08', '2026-08-07', '2026-08-06'],
          now: DateTime(2026, 8, 8),
        ),
        3,
      );
    });

    test('allows streak to continue from yesterday if today is empty', () {
      expect(
        TimeUtils.calculateTrackingStreak(
          ['2026-08-07', '2026-08-06'],
          now: DateTime(2026, 8, 8),
        ),
        2,
      );
    });

    test('breaks on a gap', () {
      expect(
        TimeUtils.calculateTrackingStreak(
          ['2026-08-08', '2026-08-06'],
          now: DateTime(2026, 8, 8),
        ),
        1,
      );
    });

    test('returns 0 when last activity is older than yesterday', () {
      expect(
        TimeUtils.calculateTrackingStreak(
          ['2026-08-05'],
          now: DateTime(2026, 8, 8),
        ),
        0,
      );
    });
  });
}
