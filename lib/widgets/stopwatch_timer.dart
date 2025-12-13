import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/theme/colors.dart';
import '../core/constants.dart';
import '../providers/stopwatch_provider.dart';
import '../l10n/app_localizations.dart';

/// Type of activity being timed
enum TimerType { focus, play }

/// A persistent stopwatch widget that survives app restarts
class StopwatchTimer extends ConsumerStatefulWidget {
  final TimerType type;
  final void Function(int minutes) onComplete;
  final bool enabled;

  const StopwatchTimer({
    super.key,
    required this.type,
    required this.onComplete,
    this.enabled = true,
  });

  @override
  ConsumerState<StopwatchTimer> createState() => _StopwatchTimerState();
}

class _StopwatchTimerState extends ConsumerState<StopwatchTimer>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  Timer? _timer;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    
    // Start UI updates if timer is already running
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(stopwatchProvider);
      if (state.isRunning) {
        _startUIUpdates();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
    if (lifecycleState == AppLifecycleState.resumed) {
      // App coming back - reload state to get accurate time
      ref.read(stopwatchProvider.notifier).reload();
      final state = ref.read(stopwatchProvider);
      if (state.isRunning) {
        _startUIUpdates();
      }
    }
  }

  void _startUIUpdates() {
    _timer?.cancel();
    _pulseController.repeat(reverse: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        final state = ref.read(stopwatchProvider);
        if (state.isRunning) {
          setState(() {
            // Trigger rebuild to update elapsed time
          });
        } else {
          _stopUIUpdates();
        }
      }
    });
  }

  void _stopUIUpdates() {
    _timer?.cancel();
    _pulseController.stop();
    _pulseController.reset();
  }

  Future<void> _startTimer() async {
    if (!widget.enabled && widget.type == TimerType.play) return;
    
    final mode = widget.type == TimerType.focus ? 'focus' : 'play';
    await ref.read(stopwatchProvider.notifier).start(mode);
    _startUIUpdates();
  }

  Future<void> _stopTimer() async {
    _stopUIUpdates();
    
    final state = ref.read(stopwatchProvider);
    final elapsed = state.elapsedMilliseconds;
    await ref.read(stopwatchProvider.notifier).pause();

    // Only add time if at least 1 minute elapsed
    final minutes = elapsed ~/ 60000;
    if (minutes >= 1) {
      _showCompletionDialog(minutes);
    } else if (elapsed > 0) {
      _showMinTimeDialog();
    }
  }

  Future<void> _resetTimer() async {
    _stopUIUpdates();
    await ref.read(stopwatchProvider.notifier).reset();
  }

  void _showCompletionDialog(int minutes) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final isFocus = widget.type == TimerType.focus;
    final color = isFocus
        ? (isDark ? AppColors.focusDark : AppColors.focusLight)
        : (isDark ? AppColors.playDark : AppColors.playLight);

    final typeText = isFocus ? (l10n?.focus ?? 'Focus') : (l10n?.play ?? 'Play');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              isFocus ? LucideIcons.bookOpen : LucideIcons.gamepad2,
              color: color,
            ),
            const SizedBox(width: 8),
            Text('$typeText ${l10n?.complete ?? "Complete"}!'),
          ],
        ),
        content: Text(
          l10n?.completionMessage(minutes.toString(), typeText.toLowerCase()) ??
          'You spent $minutes minute${minutes > 1 ? "s" : ""} ${isFocus ? "focusing" : "playing"}.\n\nAdd this time to your balance?',
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _resetTimer();
            },
            child: Text(l10n?.discard ?? 'Discard'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              widget.onComplete(minutes);
              await _resetTimer();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n?.addTime ?? 'Add Time'),
          ),
        ],
      ),
    );
  }

  void _showMinTimeDialog() {
    final l10n = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n?.tooShort ?? 'Too Short'),
        content: Text(
          l10n?.tooShortMessage ?? 'You need at least 1 minute to log time. Keep going!',
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              // Resume the timer
              await ref.read(stopwatchProvider.notifier).resume();
              _startUIUpdates();
            },
            child: Text(l10n?.continueTimer ?? 'Continue'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _resetTimer();
            },
            child: Text(l10n?.reset ?? 'Reset'),
          ),
        ],
      ),
    );
  }

  String _formatTime(int totalMs) {
    final totalSeconds = totalMs ~/ 1000;
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final isFocus = widget.type == TimerType.focus;
    
    // Watch the shared stopwatch state
    final stopwatchState = ref.watch(stopwatchProvider);
    
    final color = isFocus
        ? (isDark ? AppColors.focusDark : AppColors.focusLight)
        : (isDark ? AppColors.playDark : AppColors.playLight);
    final bgColor = isFocus
        ? (isDark ? AppColors.focusDarkBg : AppColors.focusLightBg)
        : (isDark ? AppColors.playDarkBg : AppColors.playLightBg);

    final isDisabled = !widget.enabled && widget.type == TimerType.play;
    final myMode = isFocus ? 'focus' : 'play';
    final isRunning = stopwatchState.isRunning && stopwatchState.mode == myMode;
    final elapsedMs = isRunning ? stopwatchState.elapsedMilliseconds : 0;

    // Check if the OTHER timer is running (show different state)
    final otherMode = isFocus ? 'play' : 'focus';
    final otherRunning = stopwatchState.isRunning && stopwatchState.mode == otherMode;

    return AnimatedOpacity(
      duration: AppConstants.shortAnimation,
      opacity: isDisabled || otherRunning ? 0.5 : 1.0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor.withOpacity(isDark ? 0.3 : 1.0),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isRunning ? color : color.withOpacity(0.3),
            width: isRunning ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            // Timer display
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Transform.scale(
                  scale: isRunning ? 1.0 + (_pulseController.value * 0.02) : 1.0,
                  child: child,
                );
              },
              child: Text(
                _formatTime(elapsedMs),
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
            const SizedBox(height: 8),
            
            // Label
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isFocus ? LucideIcons.bookOpen : LucideIcons.gamepad2,
                  size: 16,
                  color: color,
                ),
                const SizedBox(width: 6),
                Text(
                  isFocus 
                      ? (l10n?.focusTimer ?? 'Focus Timer') 
                      : (l10n?.playTimer ?? 'Play Timer'),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (isRunning) ...[
                  const SizedBox(width: 8),
                  _PulsingDot(color: color),
                ],
              ],
            ),
            const SizedBox(height: 16),
            
            // Control buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!isRunning) ...[
                  // Start button
                  _TimerButton(
                    icon: LucideIcons.play,
                    label: l10n?.start ?? 'Start',
                    color: color,
                    onPressed: (isDisabled || otherRunning) ? null : _startTimer,
                    filled: true,
                  ),
                ] else ...[
                  // Stop button
                  _TimerButton(
                    icon: LucideIcons.square,
                    label: l10n?.stop ?? 'Stop',
                    color: color,
                    onPressed: _stopTimer,
                    filled: true,
                  ),
                  const SizedBox(width: 12),
                  // Reset button
                  _TimerButton(
                    icon: LucideIcons.rotateCcw,
                    label: l10n?.reset ?? 'Reset',
                    color: AppColors.error,
                    onPressed: _resetTimer,
                    filled: false,
                  ),
                ],
              ],
            ),
            
            // Show hint if other timer is running
            if (otherRunning) ...[
              const SizedBox(height: 12),
              Text(
                otherMode == 'focus' 
                    ? (l10n?.focusTimerRunning ?? 'Focus timer is running')
                    : (l10n?.playTimerRunning ?? 'Play timer is running'),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TimerButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onPressed;
  final bool filled;

  const _TimerButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
    required this.filled,
  });

  @override
  Widget build(BuildContext context) {
    if (filled) {
      return ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }

    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  final Color color;

  const _PulsingDot({required this.color});

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: widget.color.withOpacity(0.5 + (_controller.value * 0.5)),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}
