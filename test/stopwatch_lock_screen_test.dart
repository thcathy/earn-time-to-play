import 'package:earn_time_to_play/l10n/app_localizations.dart';
import 'package:earn_time_to_play/providers/stopwatch_provider.dart';
import 'package:earn_time_to_play/services/lock_screen_timer_service.dart';
import 'package:earn_time_to_play/services/stopwatch_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _RecordingLockScreenTimer implements LockScreenTimer {
  final calls = <StopwatchState>[];

  @override
  Future<void> sync(StopwatchState state) async {
    calls.add(state);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('StopwatchNotifier lock-screen sync', () {
    test('syncs after start, pause, resume, and reset', () async {
      final lockScreen = _RecordingLockScreenTimer();
      final notifier = StopwatchNotifier(lockScreenTimer: lockScreen);
      await notifier.initialized;

      expect(lockScreen.calls, isNotEmpty);
      expect(lockScreen.calls.last.isRunning, isFalse);

      await notifier.start('focus');
      expect(lockScreen.calls.last.isRunning, isTrue);
      expect(lockScreen.calls.last.mode, 'focus');

      await notifier.pause();
      expect(lockScreen.calls.last.isRunning, isFalse);

      await notifier.resume();
      expect(lockScreen.calls.last.isRunning, isTrue);
      expect(lockScreen.calls.last.mode, 'focus');

      await notifier.reset();
      expect(lockScreen.calls.last.isRunning, isFalse);
      expect(lockScreen.calls.last.accumulatedMs, 0);
    });

    test('restores a running session onto the lock screen', () async {
      await StopwatchService.start('play');
      final lockScreen = _RecordingLockScreenTimer();
      final notifier = StopwatchNotifier(lockScreenTimer: lockScreen);
      await notifier.initialized;

      expect(lockScreen.calls.last.isRunning, isTrue);
      expect(lockScreen.calls.last.mode, 'play');
    });
  });

  group('LockScreenTimerService platform support', () {
    tearDown(() {
      debugDefaultTargetPlatformOverride = null;
    });

    test('is supported on Android and iOS', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      expect(LockScreenTimerService.isSupported, isTrue);

      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      expect(LockScreenTimerService.isSupported, isTrue);
    });

    test('is not supported on web-style desktop targets', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.linux;
      expect(LockScreenTimerService.isSupported, isFalse);
    });
  });

  group('AppLocalizations lock-screen copy', () {
    test('English titles describe the running timer', () {
      final l10n = AppLocalizations(const Locale('en'));
      expect(l10n.focusTimer, 'Focus Timer');
      expect(l10n.playTimer, 'Play Timer');
      expect(l10n.lockScreenTimerChannelName, 'Timer');
      expect(l10n.lockScreenTimerChannelDescription, contains('lock screen'));
    });

    test('fromLocaleCode reads zh_TW', () {
      final l10n = AppLocalizations.fromLocaleCode('zh_TW');
      expect(l10n.focusTimer, '專注計時器');
      expect(l10n.lockScreenTimerChannelName, '計時器');
    });
  });
}
