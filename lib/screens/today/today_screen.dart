import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/constants.dart';
import '../../core/theme/colors.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/time_bank_provider.dart';
import '../../utils/time_utils.dart';
import '../../widgets/balance_display.dart';
import '../../widgets/time_entry_button.dart';
import '../../widgets/theme_toggle.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/stopwatch_timer.dart';

/// Input mode for time tracking
enum InputMode { quickAdd, stopwatch }

/// Main "Today" screen showing current balance and quick-add buttons
class TodayScreen extends ConsumerStatefulWidget {
  const TodayScreen({super.key});

  @override
  ConsumerState<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends ConsumerState<TodayScreen> {
  InputMode _inputMode = InputMode.quickAdd;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(timeBankProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (state.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final todayEntry = state.todayEntry;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App bar
            SliverAppBar(
              floating: true,
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AppIcon(size: 32),
                  const SizedBox(width: 10),
                  Text(l10n?.appTitle ?? 'Time Bank for Play'),
                ],
              ),
              actions: const [
                ThemeToggle(),
                SizedBox(width: 8),
              ],
            ),

            // Content
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Balance display
                  BalanceDisplay(
                    balance: state.currentBalance,
                    canPlay: state.canPlay,
                    isWarning: state.isWarning,
                    isOverdraft: state.isOverdraft,
                  ),
                  const SizedBox(height: 24),

                  // Today's stats
                  _TodayStats(
                    focusMinutes: todayEntry.learningMinutes,
                    playMinutes: todayEntry.gamingMinutes,
                    delta: todayEntry.delta,
                  ),
                  const SizedBox(height: 24),

                  // Mode toggle
                  _ModeToggle(
                    mode: _inputMode,
                    onModeChanged: (mode) => setState(() => _inputMode = mode),
                  ),
                  const SizedBox(height: 20),

                  // Content based on mode
                  if (_inputMode == InputMode.stopwatch) ...[
                    // Stopwatch mode
                    _SectionHeader(
                      title: l10n?.focusTimer ?? 'Focus Timer',
                      icon: LucideIcons.timer,
                      color: isDark ? AppColors.focusDark : AppColors.focusLight,
                    ),
                    const SizedBox(height: 12),
                    StopwatchTimer(
                      type: TimerType.focus,
                      onComplete: (minutes) => ref.read(timeBankProvider.notifier).addFocus(minutes),
                    ),
                    const SizedBox(height: 20),

                    _SectionHeader(
                      title: l10n?.playTimer ?? 'Play Timer',
                      icon: LucideIcons.timer,
                      color: isDark ? AppColors.playDark : AppColors.playLight,
                    ),
                    const SizedBox(height: 12),
                    StopwatchTimer(
                      type: TimerType.play,
                      onComplete: (minutes) => ref.read(timeBankProvider.notifier).addPlay(minutes),
                      enabled: state.canPlay || state.settings.allowOverdraft,
                    ),
                  ] else ...[
                    // Quick-add mode
                    _SectionHeader(
                      title: l10n?.addFocusTime ?? 'Add Focus Time',
                      icon: LucideIcons.bookOpen,
                      color: isDark ? AppColors.focusDark : AppColors.focusLight,
                    ),
                    const SizedBox(height: 12),
                    _QuickAddRow(
                      type: TimeEntryType.focus,
                      onAdd: (minutes) => ref.read(timeBankProvider.notifier).addFocus(minutes),
                    ),
                    const SizedBox(height: 8),
                    _ManualInput(
                      type: TimeEntryType.focus,
                      onAdd: (minutes) => ref.read(timeBankProvider.notifier).addFocus(minutes),
                    ),
                    const SizedBox(height: 24),

                    _SectionHeader(
                      title: l10n?.addPlayTime ?? 'Add Play Time',
                      icon: LucideIcons.gamepad2,
                      color: isDark ? AppColors.playDark : AppColors.playLight,
                    ),
                    const SizedBox(height: 12),
                    _QuickAddRow(
                      type: TimeEntryType.play,
                      onAdd: (minutes) => ref.read(timeBankProvider.notifier).addPlay(minutes),
                      enabled: state.canPlay || state.settings.allowOverdraft,
                    ),
                    const SizedBox(height: 8),
                    _ManualInput(
                      type: TimeEntryType.play,
                      onAdd: (minutes) => ref.read(timeBankProvider.notifier).addPlay(minutes),
                      enabled: state.canPlay || state.settings.allowOverdraft,
                    ),
                  ],
                  const SizedBox(height: 32),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Toggle between Quick Add and Stopwatch modes
class _ModeToggle extends StatelessWidget {
  final InputMode mode;
  final void Function(InputMode) onModeChanged;

  const _ModeToggle({
    required this.mode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ModeButton(
              icon: LucideIcons.zap,
              label: l10n?.quickAdd ?? 'Quick Add',
              selected: mode == InputMode.quickAdd,
              onTap: () => onModeChanged(InputMode.quickAdd),
            ),
          ),
          Expanded(
            child: _ModeButton(
              icon: LucideIcons.timer,
              label: l10n?.stopwatch ?? 'Stopwatch',
              selected: mode == InputMode.stopwatch,
              onTap: () => onModeChanged(InputMode.stopwatch),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ModeButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: selected
          ? (isDark ? AppColors.darkSurface : Colors.white)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: selected
                    ? (isDark ? AppColors.focusDark : AppColors.focusLight)
                    : theme.textTheme.bodySmall?.color,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  color: selected
                      ? (isDark ? AppColors.focusDark : AppColors.focusLight)
                      : theme.textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _SectionHeader({
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _TodayStats extends StatelessWidget {
  final int focusMinutes;
  final int playMinutes;
  final int delta;

  const _TodayStats({
    required this.focusMinutes,
    required this.playMinutes,
    required this.delta,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return AppCard(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n?.todayProgress ?? "Today's Progress",
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  label: l10n?.focus ?? 'Focus',
                  value: TimeUtils.formatMinutes(focusMinutes),
                  color: isDark ? AppColors.focusDark : AppColors.focusLight,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: theme.colorScheme.outline.withOpacity(0.2),
              ),
              Expanded(
                child: _StatItem(
                  label: l10n?.play ?? 'Play',
                  value: TimeUtils.formatMinutes(playMinutes),
                  color: isDark ? AppColors.playDark : AppColors.playLight,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: theme.colorScheme.outline.withOpacity(0.2),
              ),
              Expanded(
                child: _StatItem(
                  label: l10n?.delta ?? 'Delta',
                  value: TimeUtils.formatMinutesWithSign(delta),
                  color: delta >= 0
                      ? (isDark ? AppColors.focusDark : AppColors.focusLight)
                      : AppColors.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _QuickAddRow extends StatelessWidget {
  final TimeEntryType type;
  final void Function(int minutes) onAdd;
  final bool enabled;

  const _QuickAddRow({
    required this.type,
    required this.onAdd,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: AppConstants.quickAddOptions.map((minutes) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: minutes == AppConstants.quickAddOptions.last ? 0 : 8,
            ),
            child: TimeEntryButton(
              minutes: minutes,
              type: type,
              onPressed: () => onAdd(minutes),
              enabled: enabled,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ManualInput extends StatefulWidget {
  final TimeEntryType type;
  final void Function(int minutes) onAdd;
  final bool enabled;

  const _ManualInput({
    required this.type,
    required this.onAdd,
    this.enabled = true,
  });

  @override
  State<_ManualInput> createState() => _ManualInputState();
}

class _ManualInputState extends State<_ManualInput> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final value = int.tryParse(_controller.text);
    if (value != null && value > 0) {
      widget.onAdd(value);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final isFocus = widget.type == TimeEntryType.focus;
    final color = isFocus
        ? (isDark ? AppColors.focusDark : AppColors.focusLight)
        : (isDark ? AppColors.playDark : AppColors.playLight);

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            enabled: widget.enabled,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: l10n?.enterMinutes ?? 'Enter minutes',
              suffixText: l10n?.min ?? 'min',
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            onSubmitted: (_) => _submit(),
          ),
        ),
        const SizedBox(width: 8),
        Material(
          color: color.withOpacity(widget.enabled ? 1 : 0.5),
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: widget.enabled ? _submit : null,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(14),
              child: Icon(
                LucideIcons.plus,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

