import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../l10n/app_localizations.dart';

/// Main app shell with bottom navigation
class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: const _BottomNavBar(),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/today')) return 0;
    if (location.startsWith('/history')) return 1;
    if (location.startsWith('/analytics')) return 2;
    if (location.startsWith('/settings')) return 3;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/today');
        break;
      case 1:
        context.go('/history');
        break;
      case 2:
        context.go('/analytics');
        break;
      case 3:
        context.go('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) => _onItemTapped(context, index),
        backgroundColor: theme.colorScheme.surface,
        indicatorColor: theme.colorScheme.primary.withOpacity(0.1),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        height: 70,
        destinations: [
          NavigationDestination(
            icon: const Icon(LucideIcons.home),
            selectedIcon: const Icon(LucideIcons.home),
            label: l10n?.today ?? 'Today',
          ),
          NavigationDestination(
            icon: const Icon(LucideIcons.calendar),
            selectedIcon: const Icon(LucideIcons.calendar),
            label: l10n?.history ?? 'History',
          ),
          NavigationDestination(
            icon: const Icon(LucideIcons.barChart3),
            selectedIcon: const Icon(LucideIcons.barChart3),
            label: l10n?.analytics ?? 'Analytics',
          ),
          NavigationDestination(
            icon: const Icon(LucideIcons.settings),
            selectedIcon: const Icon(LucideIcons.settings),
            label: l10n?.settings ?? 'Settings',
          ),
        ],
      ),
    );
  }
}
