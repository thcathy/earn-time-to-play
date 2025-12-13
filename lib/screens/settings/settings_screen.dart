import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/theme/colors.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/theme_provider.dart';
import '../../providers/locale_provider.dart';
import '../../providers/time_bank_provider.dart';
import '../../widgets/app_card.dart';
import '../../widgets/theme_toggle.dart';

/// Settings screen for app configuration
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(timeBankProvider);
    final themeMode = ref.watch(themeModeProvider);
    final currentLocale = ref.watch(localeProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App bar
            SliverAppBar(
              floating: true,
              title: Text(l10n?.settings ?? 'Settings'),
              actions: const [
                ThemeToggle(),
                SizedBox(width: 8),
              ],
            ),

            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Theme section
                  _SectionTitle(title: l10n?.appearance ?? 'Appearance'),
                  const SizedBox(height: 8),
                  AppCard(
                    margin: EdgeInsets.zero,
                    child: Column(
                      children: [
                        _ThemeOption(
                          title: l10n?.system ?? 'System',
                          subtitle: l10n?.followSystemSettings ?? 'Follow system settings',
                          icon: LucideIcons.monitor,
                          selected: themeMode == ThemeMode.system,
                          onTap: () => ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.system),
                        ),
                        const Divider(height: 1),
                        _ThemeOption(
                          title: l10n?.light ?? 'Light',
                          subtitle: l10n?.alwaysLightTheme ?? 'Always use light theme',
                          icon: LucideIcons.sun,
                          selected: themeMode == ThemeMode.light,
                          onTap: () => ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.light),
                        ),
                        const Divider(height: 1),
                        _ThemeOption(
                          title: l10n?.dark ?? 'Dark',
                          subtitle: l10n?.alwaysDarkTheme ?? 'Always use dark theme',
                          icon: LucideIcons.moon,
                          selected: themeMode == ThemeMode.dark,
                          onTap: () => ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.dark),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Language section
                  _SectionTitle(title: l10n?.language ?? 'Language'),
                  const SizedBox(height: 8),
                  AppCard(
                    margin: EdgeInsets.zero,
                    child: Column(
                      children: [
                        _ThemeOption(
                          title: l10n?.system ?? 'System',
                          subtitle: l10n?.followSystemSettings ?? 'Follow system language',
                          icon: LucideIcons.globe,
                          selected: currentLocale == AppLocale.system,
                          onTap: () => ref.read(localeProvider.notifier).setLocale(AppLocale.system),
                        ),
                        const Divider(height: 1),
                        _ThemeOption(
                          title: l10n?.english ?? 'English',
                          subtitle: 'English',
                          icon: LucideIcons.languages,
                          selected: currentLocale == AppLocale.english,
                          onTap: () => ref.read(localeProvider.notifier).setLocale(AppLocale.english),
                        ),
                        const Divider(height: 1),
                        _ThemeOption(
                          title: l10n?.traditionalChinese ?? '繁體中文',
                          subtitle: 'Traditional Chinese',
                          icon: LucideIcons.languages,
                          selected: currentLocale == AppLocale.traditionalChinese,
                          onTap: () => ref.read(localeProvider.notifier).setLocale(AppLocale.traditionalChinese),
                        ),
                        const Divider(height: 1),
                        _ThemeOption(
                          title: l10n?.simplifiedChinese ?? '简体中文',
                          subtitle: 'Simplified Chinese',
                          icon: LucideIcons.languages,
                          selected: currentLocale == AppLocale.simplifiedChinese,
                          onTap: () => ref.read(localeProvider.notifier).setLocale(AppLocale.simplifiedChinese),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Balance settings
                  _SectionTitle(title: l10n?.balanceSettings ?? 'Balance Settings'),
                  const SizedBox(height: 8),
                  AppCard(
                    margin: EdgeInsets.zero,
                    child: Column(
                      children: [
                        _NumberSetting(
                          title: l10n?.startingBalance ?? 'Starting Balance',
                          subtitle: l10n?.startingBalanceDesc ?? 'Initial balance when you started',
                          value: state.settings.startingBalance,
                          suffix: l10n?.min ?? 'min',
                          onChanged: (value) {
                            ref.read(timeBankProvider.notifier).setStartingBalance(value);
                          },
                        ),
                        const Divider(height: 1),
                        _NumberSetting(
                          title: l10n?.warningThreshold ?? 'Warning Threshold',
                          subtitle: l10n?.warningThresholdDesc ?? 'Warn when balance drops below',
                          value: state.settings.warningThreshold,
                          suffix: l10n?.min ?? 'min',
                          onChanged: (value) {
                            ref.read(timeBankProvider.notifier).setWarningThreshold(value);
                          },
                        ),
                        const Divider(height: 1),
                        _NumberSetting(
                          title: l10n?.maxPlayPerDay ?? 'Max Play Per Day',
                          subtitle: l10n?.maxPlayPerDayDesc ?? 'Optional daily limit (0 = unlimited)',
                          value: state.settings.maxGamingPerDay ?? 0,
                          suffix: l10n?.min ?? 'min',
                          onChanged: (value) {
                            ref.read(timeBankProvider.notifier).setMaxPlayPerDay(
                                  value == 0 ? null : value,
                                );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Behavior settings
                  _SectionTitle(title: l10n?.behavior ?? 'Behavior'),
                  const SizedBox(height: 8),
                  AppCard(
                    margin: EdgeInsets.zero,
                    child: _SwitchSetting(
                      title: l10n?.allowOverdraft ?? 'Allow Overdraft',
                      subtitle: l10n?.allowOverdraftDesc ?? 'Allow play even with negative balance',
                      value: state.settings.allowOverdraft,
                      onChanged: (value) {
                        ref.read(timeBankProvider.notifier).toggleAllowOverdraft();
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Data section
                  _SectionTitle(title: l10n?.data ?? 'Data'),
                  const SizedBox(height: 8),
                  AppCard(
                    margin: EdgeInsets.zero,
                    child: Column(
                      children: [
                        _ActionTile(
                          title: l10n?.exportData ?? 'Export Data',
                          subtitle: l10n?.exportDataDesc ?? 'Export all entries as CSV',
                          icon: LucideIcons.download,
                          onTap: () => _exportData(context, ref),
                        ),
                        const Divider(height: 1),
                        _ActionTile(
                          title: l10n?.resetAllData ?? 'Reset All Data',
                          subtitle: l10n?.resetAllDataDesc ?? 'Delete all entries and settings',
                          icon: LucideIcons.trash2,
                          color: AppColors.error,
                          onTap: () => _showResetDialog(context, ref),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // App info footer
                  Center(
                    child: Column(
                      children: [
                        Text(
                          l10n?.appTitle ?? 'Time Bank for Play',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: theme.textTheme.bodySmall?.color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n?.version('1.0.0') ?? 'Version 1.0.0',
                          style: theme.textTheme.bodySmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n?.copyright ?? '© 2025 Timmy Wong',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _exportData(BuildContext context, WidgetRef ref) async {
    final csv = ref.read(timeBankProvider.notifier).exportToCsv();
    await Share.share(csv, subject: 'Time Bank Data Export');
  }

  void _showResetDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n?.resetConfirmTitle ?? 'Reset All Data'),
        content: Text(
          l10n?.resetConfirmMessage ?? 'This will permanently delete all your time entries and reset settings to defaults. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n?.cancel ?? 'Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(timeBankProvider.notifier).resetAllData();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n?.dataResetSuccess ?? 'All data has been reset')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(l10n?.resetButton ?? 'Reset'),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.bodyLarge),
                  Text(subtitle, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            if (selected)
              Icon(
                LucideIcons.check,
                size: 20,
                color: theme.colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }
}

class _NumberSetting extends StatelessWidget {
  final String title;
  final String subtitle;
  final int value;
  final String suffix;
  final void Function(int) onChanged;

  const _NumberSetting({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.suffix,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.bodyLarge),
                Text(subtitle, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 100,
            child: TextField(
              controller: TextEditingController(text: value.toString()),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                suffixText: suffix,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              onSubmitted: (text) {
                final newValue = int.tryParse(text) ?? value;
                onChanged(newValue);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SwitchSetting extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final void Function(bool) onChanged;

  const _SwitchSetting({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.bodyLarge),
                Text(subtitle, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color? color;
  final VoidCallback onTap;

  const _ActionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = color ?? theme.textTheme.bodyLarge?.color;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(color: textColor),
                  ),
                  Text(subtitle, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            Icon(
              LucideIcons.chevronRight,
              size: 20,
              color: theme.textTheme.bodySmall?.color,
            ),
          ],
        ),
      ),
    );
  }
}

