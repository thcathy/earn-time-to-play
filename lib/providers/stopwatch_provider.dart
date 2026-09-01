import 'dart:async';
import 'package:flutter/widgets.dart';
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
        _refreshLockScreen = lockScreenTimer == null,
        super(StopwatchState()) {
    initialized = _loadState();
    if (_refreshLockScreen) {
      _lifecycle = _ResumeObserver(reload);
      WidgetsBinding.instance.addObserver(_lifecycle!);
    }
  }

  static const _lockScreenRefreshInterval = Duration(minutes: 20);

  final LockScreenTimer _lockScreenTimer;
  final bool _refreshLockScreen;
  _ResumeObserver? _lifecycle;
  Timer? _lockScreenRefresh;

  /// Completes after persisted state is loaded and the lock-screen timer is synced.
  late final Future<void> initialized;

  Future<void> _loadState() => _commit(StopwatchService.load);

  Future<void> reload() => _loadState();

  Future<void> start(String mode) =>
      _commit(() => StopwatchService.start(mode));

  Future<void> pause() => _commit(() => StopwatchService.pause(state));

  Future<void> resume() => _commit(() => StopwatchService.resume(state));

  Future<void> reset() => _commit(StopwatchService.reset);

  Future<void> _commit(Future<StopwatchState> Function() update) async {
    state = await update();
    await _syncLockScreen();
  }

  Future<void> _syncLockScreen() async {
    await _lockScreenTimer.sync(state);
    _lockScreenRefresh?.cancel();
    _lockScreenRefresh = null;
    if (!_refreshLockScreen || !state.isRunning) return;
    _lockScreenRefresh = Timer.periodic(_lockScreenRefreshInterval, (_) {
      if (state.isRunning) {
        _lockScreenTimer.sync(state);
      }
    });
  }

  @override
  void dispose() {
    _lockScreenRefresh?.cancel();
    final observer = _lifecycle;
    if (observer != null) {
      WidgetsBinding.instance.removeObserver(observer);
    }
    super.dispose();
  }
}

class _ResumeObserver with WidgetsBindingObserver {
  _ResumeObserver(this._onResume);

  final Future<void> Function() _onResume;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _onResume();
    }
  }
}
