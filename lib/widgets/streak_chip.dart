import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/theme/colors.dart';
import '../l10n/app_localizations.dart';

/// Compact habit-streak indicator for the Today screen.
class StreakChip extends StatelessWidget {
  final int streak;
  final bool hasLoggedToday;

  const StreakChip({
    super.key,
    required this.streak,
    required this.hasLoggedToday,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final accent = isDark ? AppColors.playDark : AppColors.playLight;
    final muted = theme.colorScheme.outline.withValues(alpha: 0.55);

    final label = streak > 0
        ? (l10n?.streakDays(streak) ?? '$streak-day streak')
        : (l10n?.startStreak ?? 'Start your streak today');

    final showKeepAlive = streak > 0 && !hasLoggedToday;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: (streak > 0 ? accent : muted).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: (streak > 0 ? accent : muted).withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          Icon(
            LucideIcons.flame,
            size: 18,
            color: streak > 0 ? accent : muted,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color:
                        streak > 0 ? accent : theme.textTheme.bodySmall?.color,
                  ),
                ),
                if (showKeepAlive)
                  Text(
                    l10n?.keepStreakAlive ?? 'Log today to keep it',
                    style: theme.textTheme.bodySmall,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
