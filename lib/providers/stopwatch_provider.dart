import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/lock_screen_timer_service.dart';
import '../services/stopwatch_service.dart';

/// Provider for shared stopwatch state across all timer widgets
final stopwatchProvider =
    StateNotifierProvider<StopwatchNotifier, StopwatchState>((ref) {
  return StopwatchNotifier();
});

class StopwatchNotifier extends StateNotifier<StopwatchState> {
  StopwatchNotifier({LockScreenTimer? lockScreenTimer})
      : _lockScreenTimer = lockScreenTimer ?? LockScreenTimerService.instance,
        super(StopwatchState()) {
    initialized = _loadState();
  }

  final LockScreenTimer _lockScreenTimer;

  /// Completes after persisted state is loaded and the lock-screen timer is synced.
  late final Future<void> initialized;

  Future<void> _loadState() async {
    state = await StopwatchService.load();
    await _lockScreenTimer.sync(state);
  }

  /// Reload state from storage (useful when app resumes)
  Future<void> reload() async {
    state = await StopwatchService.load();
    await _lockScreenTimer.sync(state);
  }

  /// Start the stopwatch with given mode
  Future<void> start(String mode) async {
    state = await StopwatchService.start(mode);
    await _lockScreenTimer.sync(state);
  }

  /// Pause the stopwatch
  Future<void> pause() async {
    state = await StopwatchService.pause(state);
    await _lockScreenTimer.sync(state);
  }

  /// Resume the stopwatch
  Future<void> resume() async {
    state = await StopwatchService.resume(state);
    await _lockScreenTimer.sync(state);
  }

  /// Reset the stopwatch
  Future<void> reset() async {
    state = await StopwatchService.reset();
    await _lockScreenTimer.sync(state);
  }
}
