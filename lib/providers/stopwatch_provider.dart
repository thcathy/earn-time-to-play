import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/stopwatch_service.dart';

/// Provider for shared stopwatch state across all timer widgets
final stopwatchProvider = StateNotifierProvider<StopwatchNotifier, StopwatchState>((ref) {
  return StopwatchNotifier();
});

class StopwatchNotifier extends StateNotifier<StopwatchState> {
  StopwatchNotifier() : super(StopwatchState()) {
    _loadState();
  }

  Future<void> _loadState() async {
    state = await StopwatchService.load();
  }

  /// Reload state from storage (useful when app resumes)
  Future<void> reload() async {
    state = await StopwatchService.load();
  }

  /// Start the stopwatch with given mode
  Future<void> start(String mode) async {
    state = await StopwatchService.start(mode);
  }

  /// Pause the stopwatch
  Future<void> pause() async {
    state = await StopwatchService.pause(state);
  }

  /// Resume the stopwatch
  Future<void> resume() async {
    state = await StopwatchService.resume(state);
  }

  /// Reset the stopwatch
  Future<void> reset() async {
    state = await StopwatchService.reset();
  }
}
