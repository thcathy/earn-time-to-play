import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/colors.dart';
import '../../l10n/app_localizations.dart';
import '../../models/day_entry.dart';
import '../../providers/time_bank_provider.dart';
import '../../utils/time_utils.dart';
import '../../widgets/app_card.dart';
import '../../widgets/theme_toggle.dart';

/// Filter options for history view
enum HistoryFilter { all, week, month }

/// History screen showing all past entries
class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  HistoryFilter _filter = HistoryFilter.all;

  List<({DayEntry entry, int cumulativeBalance})> _filterEntries(
    List<({DayEntry entry, int cumulativeBalance})> entries,
  ) {
    if (_filter == HistoryFilter.all) {
      return entries;
    }

    final now = DateTime.now();
    final cutoff = _filter == HistoryFilter.week
        ? now.subtract(const Duration(days: 7))
        : DateTime(now.year, now.month, 1);

    return entries.where((item) {
      final date = TimeUtils.parseDate(item.entry.date);
      return date.isAfter(cutoff) || date.isAtSameMomentAs(cutoff);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(timeBankProvider);
    final theme = Theme.of(context);

    if (state.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final filteredEntries = _filterEntries(state.entriesWithBalance);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App bar
            SliverAppBar(
              floating: true,
              title: Text(l10n?.history ?? 'History'),
              actions: const [
                ThemeToggle(),
                SizedBox(width: 8),
              ],
            ),

            // Filter chips
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    _FilterChip(
                      label: l10n?.allTime ?? 'All',
                      selected: _filter == HistoryFilter.all,
                      onTap: () => setState(() => _filter = HistoryFilter.all),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: l10n?.thisWeek ?? 'This Week',
                      selected: _filter == HistoryFilter.week,
                      onTap: () => setState(() => _filter = HistoryFilter.week),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: l10n?.thisMonth ?? 'This Month',
                      selected: _filter == HistoryFilter.month,
                      onTap: () => setState(() => _filter = HistoryFilter.month),
                    ),
                  ],
                ),
              ),
            ),

            // Entries list
            if (filteredEntries.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.calendar,
                        size: 64,
                        color: theme.colorScheme.outline.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n?.noEntriesYet ?? 'No entries yet',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n?.startTrackingMessage ?? 'Start tracking your time on the Today screen',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 32),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = filteredEntries[index];
                      return _DayCard(
                        entry: item.entry,
                        cumulativeBalance: item.cumulativeBalance,
                        onEdit: () => _showEditDialog(context, item.entry),
                      );
                    },
                    childCount: filteredEntries.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, DayEntry entry) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _EditEntrySheet(entry: entry),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
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
          ? (isDark ? AppColors.focusDark : AppColors.focusLight)
          : theme.colorScheme.surfaceVariant,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: selected
                  ? Colors.white
                  : theme.textTheme.bodyMedium?.color,
              fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  final DayEntry entry;
  final int cumulativeBalance;
  final VoidCallback onEdit;

  const _DayCard({
    required this.entry,
    required this.cumulativeBalance,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppCard(
      onTap: onEdit,
      child: Row(
        children: [
          // Date
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  TimeUtils.formatDateForDisplay(entry.date),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  entry.date,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),

          // Focus
          Expanded(
            child: Column(
              children: [
                Icon(
                  LucideIcons.bookOpen,
                  size: 16,
                  color: isDark ? AppColors.focusDark : AppColors.focusLight,
                ),
                const SizedBox(height: 4),
                Text(
                  entry.focusFormatted,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.focusDark : AppColors.focusLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Play
          Expanded(
            child: Column(
              children: [
                Icon(
                  LucideIcons.gamepad2,
                  size: 16,
                  color: isDark ? AppColors.playDark : AppColors.playLight,
                ),
                const SizedBox(height: 4),
                Text(
                  entry.playFormatted,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.playDark : AppColors.playLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Balance
          Expanded(
            child: Column(
              children: [
                Icon(
                  LucideIcons.wallet,
                  size: 16,
                  color: cumulativeBalance >= 0
                      ? (isDark ? AppColors.focusDark : AppColors.focusLight)
                      : AppColors.error,
                ),
                const SizedBox(height: 4),
                Text(
                  TimeUtils.formatMinutesWithSign(cumulativeBalance),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cumulativeBalance >= 0
                        ? (isDark ? AppColors.focusDark : AppColors.focusLight)
                        : AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EditEntrySheet extends ConsumerStatefulWidget {
  final DayEntry entry;

  const _EditEntrySheet({required this.entry});

  @override
  ConsumerState<_EditEntrySheet> createState() => _EditEntrySheetState();
}

class _EditEntrySheetState extends ConsumerState<_EditEntrySheet> {
  late TextEditingController _focusController;
  late TextEditingController _playController;

  @override
  void initState() {
    super.initState();
    _focusController = TextEditingController(
      text: widget.entry.learningMinutes.toString(),
    );
    _playController = TextEditingController(
      text: widget.entry.gamingMinutes.toString(),
    );
  }

  @override
  void dispose() {
    _focusController.dispose();
    _playController.dispose();
    super.dispose();
  }

  void _save() {
    final focus = int.tryParse(_focusController.text) ?? 0;
    final play = int.tryParse(_playController.text) ?? 0;

    ref.read(timeBankProvider.notifier).updateEntry(
          widget.entry.date,
          learningMinutes: focus,
          gamingMinutes: play,
        );

    Navigator.of(context).pop();
  }

  void _delete() {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n?.deleteEntry ?? 'Delete Entry'),
        content: Text(l10n?.deleteEntryConfirm ?? 'Are you sure you want to delete this entry?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n?.cancel ?? 'Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(timeBankProvider.notifier).deleteEntry(widget.entry.date);
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Close sheet
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(l10n?.delete ?? 'Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n?.editEntry ?? 'Edit Entry',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      TimeUtils.formatDateForDisplay(widget.entry.date),
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: _delete,
                icon: const Icon(LucideIcons.trash2),
                color: AppColors.error,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Focus input
          Text(
            l10n?.focusMinutes ?? 'Focus Minutes',
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _focusController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefixIcon: Icon(
                LucideIcons.bookOpen,
                color: isDark ? AppColors.focusDark : AppColors.focusLight,
              ),
              suffixText: l10n?.min ?? 'min',
            ),
          ),
          const SizedBox(height: 16),

          // Play input
          Text(
            l10n?.playMinutes ?? 'Play Minutes',
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _playController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefixIcon: Icon(
                LucideIcons.gamepad2,
                color: isDark ? AppColors.playDark : AppColors.playLight,
              ),
              suffixText: l10n?.min ?? 'min',
            ),
          ),
          const SizedBox(height: 24),

          // Save button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? AppColors.focusDark : AppColors.focusLight,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(l10n?.saveChanges ?? 'Save Changes'),
            ),
          ),
        ],
      ),
    );
  }
}

