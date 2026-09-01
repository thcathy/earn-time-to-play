import 'package:earn_time_to_play/services/stopwatch_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StopwatchState.elapsedAt', () {
    test('returns accumulated time when not running', () {
      final state = StopwatchState(
        isRunning: false,
        accumulatedMs: 90 * 1000,
      );
      expect(state.elapsedAt(DateTime(2026, 8, 23, 12)), 90 * 1000);
      expect(state.elapsedMilliseconds, 90 * 1000);
    });

    test('adds wall-clock time while running', () {
      final start = DateTime(2026, 8, 23, 12);
      final state = StopwatchState(
        isRunning: true,
        startTime: start,
        mode: 'focus',
        accumulatedMs: 30 * 1000,
      );
      expect(state.elapsedAt(start.add(const Duration(minutes: 2))), 150 * 1000);
    });

    test('isPlay follows mode', () {
      expect(StopwatchState(mode: 'play').isPlay, isTrue);
      expect(StopwatchState(mode: 'focus').isPlay, isFalse);
    });
  });

  group('StopwatchState.chronometerWhenMillis', () {
    test('is now minus elapsed so a native chronometer starts at current elapsed',
        () {
      final now = DateTime(2026, 8, 23, 12);
      final start = now.subtract(const Duration(minutes: 5));
      final state = StopwatchState(
        isRunning: true,
        startTime: start,
        mode: 'focus',
        accumulatedMs: 0,
      );

      expect(
        state.chronometerWhenMillis(now),
        now.millisecondsSinceEpoch - (5 * 60 * 1000),
      );
    });

    test('accounts for accumulated time after a pause and resume', () {
      final now = DateTime(2026, 8, 23, 12);
      final state = StopwatchState(
        isRunning: true,
        startTime: now,
        mode: 'play',
        accumulatedMs: 90 * 1000,
      );

      expect(
        state.chronometerWhenMillis(now),
        now.millisecondsSinceEpoch - (90 * 1000),
      );
    });
  });
}
