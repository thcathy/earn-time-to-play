import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'providers/theme_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/onboarding_provider.dart';
import 'screens/today/today_screen.dart';
import 'screens/history/history_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/analytics/analytics_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'widgets/app_shell.dart';

/// App router configuration
final _router = GoRouter(
  initialLocation: '/today',
  routes: [
    GoRoute(
      path: '/onboarding',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const OnboardingScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/today',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const TodayScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: '/history',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const HistoryScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: '/analytics',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const AnalyticsScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const SettingsScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),
      ],
    ),
  ],
);

/// Main app widget
class TimeBankApp extends ConsumerWidget {
  const TimeBankApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final appLocale = ref.watch(localeProvider);
    final onboardingCompleted = ref.watch(onboardingCompletedProvider);

    // First-run onboarding before the main shell — critical for activation.
    if (!onboardingCompleted) {
      return MaterialApp(
        title: 'Earn Time To Play',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeMode,
        locale: appLocale.locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('zh'),
          Locale('zh', 'TW'),
          Locale('zh', 'CN'),
        ],
        builder: _edgeToEdgeBuilder,
        home: const OnboardingScreen(),
      );
    }

    return MaterialApp.router(
      title: 'Earn Time To Play',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: _router,
      
      // Localization
      locale: appLocale.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('zh'),
        Locale('zh', 'TW'),
        Locale('zh', 'CN'),
      ],
      builder: _edgeToEdgeBuilder,
    );
  }
}

Widget _edgeToEdgeBuilder(BuildContext context, Widget? child) {
  return AnnotatedRegion<SystemUiOverlayStyle>(
    value: AppTheme.systemUiFor(Theme.of(context).brightness),
    child: child ?? const SizedBox.shrink(),
  );
}
