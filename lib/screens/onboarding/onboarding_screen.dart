import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/colors.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/onboarding_provider.dart';
import '../../widgets/app_icon.dart';

/// First-run walkthrough that explains the earn → spend loop.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  static const _pageCount = 3;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await ref.read(onboardingCompletedProvider.notifier).complete();
    if (!mounted) return;
    // When shown as MaterialApp.home there is no GoRouter; the parent
    // rebuilds into the main shell. When opened from Settings, navigate back.
    final router = GoRouter.maybeOf(context);
    if (router != null) {
      context.go('/today');
    }
  }

  void _next() {
    if (_page >= _pageCount - 1) {
      _finish();
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final focusColor = isDark ? AppColors.focusDark : AppColors.focusLight;
    final playColor = isDark ? AppColors.playDark : AppColors.playLight;

    final pages = [
      _OnboardingPageData(
        icon: LucideIcons.bookOpen,
        color: focusColor,
        title: l10n?.onboardingEarnTitle ?? 'Earn time by focusing',
        body: l10n?.onboardingEarnBody ??
            'Study, work, or learn — every focused minute deposits into your time bank.',
      ),
      _OnboardingPageData(
        icon: LucideIcons.gamepad2,
        color: playColor,
        title: l10n?.onboardingSpendTitle ?? 'Spend time by playing',
        body: l10n?.onboardingSpendBody ??
            'Withdraw from your balance when you game. Play stays guilt-free when you have earned it.',
      ),
      _OnboardingPageData(
        icon: LucideIcons.flame,
        color: focusColor,
        title: l10n?.onboardingStreakTitle ?? 'Build a daily streak',
        body: l10n?.onboardingStreakBody ??
            'Log a little each day to keep your streak alive. Share progress and invite friends to balance with you.',
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _finish,
                child: Text(l10n?.skip ?? 'Skip'),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (index) => setState(() => _page = index),
                itemBuilder: (context, index) {
                  final page = pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (index == 0) ...[
                          const AppIcon(size: 72),
                          const SizedBox(height: 20),
                          Text(
                            l10n?.appTitle ?? 'Earn Time To Play',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 28),
                        ],
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            color: page.color.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(page.icon, size: 48, color: page.color),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          page.body,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.textTheme.bodySmall?.color,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pageCount, (index) {
                      final selected = index == _page;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: selected ? 22 : 8,
                        decoration: BoxDecoration(
                          color: selected
                              ? focusColor
                              : theme.colorScheme.outline.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _next,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: focusColor,
                      ),
                      child: Text(
                        _page == _pageCount - 1
                            ? (l10n?.getStarted ?? 'Get started')
                            : (l10n?.next ?? 'Next'),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPageData {
  final IconData icon;
  final Color color;
  final String title;
  final String body;

  const _OnboardingPageData({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
  });
}
