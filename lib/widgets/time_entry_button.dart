import 'package:flutter/material.dart';
import '../core/theme/colors.dart';
import '../core/constants.dart';

/// Button type for time entry
enum TimeEntryType { focus, play }

/// A button for quick time entry
class TimeEntryButton extends StatefulWidget {
  final int minutes;
  final TimeEntryType type;
  final VoidCallback onPressed;
  final bool enabled;

  const TimeEntryButton({
    super.key,
    required this.minutes,
    required this.type,
    required this.onPressed,
    this.enabled = true,
  });

  @override
  State<TimeEntryButton> createState() => _TimeEntryButtonState();
}

class _TimeEntryButtonState extends State<TimeEntryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppConstants.shortAnimation,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatMinutes(int minutes) {
    if (minutes >= 60) {
      return '${minutes ~/ 60}h';
    }
    return '${minutes}m';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final isFocus = widget.type == TimeEntryType.focus;
    final color = isFocus
        ? (isDark ? AppColors.focusDark : AppColors.focusLight)
        : (isDark ? AppColors.playDark : AppColors.playLight);
    final bgColor = isFocus
        ? (isDark ? AppColors.focusDarkBg : AppColors.focusLightBg)
        : (isDark ? AppColors.playDarkBg : AppColors.playLightBg);

    return GestureDetector(
      onTapDown: widget.enabled ? (_) => _controller.forward() : null,
      onTapUp: widget.enabled
          ? (_) {
              _controller.reverse();
              widget.onPressed();
            }
          : null,
      onTapCancel: widget.enabled ? () => _controller.reverse() : null,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: AnimatedOpacity(
          duration: AppConstants.shortAnimation,
          opacity: widget.enabled ? 1.0 : 0.5,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                '+${_formatMinutes(widget.minutes)}',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
