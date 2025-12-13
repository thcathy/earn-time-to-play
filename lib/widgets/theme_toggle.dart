import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/theme_provider.dart';
import '../core/constants.dart';

/// A toggle button for switching between light and dark theme
class ThemeToggle extends ConsumerWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    IconData icon;
    String tooltip;

    switch (themeMode) {
      case ThemeMode.system:
        icon = LucideIcons.monitor;
        tooltip = 'System theme';
        break;
      case ThemeMode.light:
        icon = LucideIcons.sun;
        tooltip = 'Light theme';
        break;
      case ThemeMode.dark:
        icon = LucideIcons.moon;
        tooltip = 'Dark theme';
        break;
    }

    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => ref.read(themeModeProvider.notifier).cycleTheme(),
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: AppConstants.mediumAnimation,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.black.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: AnimatedSwitcher(
              duration: AppConstants.mediumAnimation,
              child: Icon(
                icon,
                key: ValueKey(themeMode),
                size: 20,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

