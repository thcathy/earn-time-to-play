import 'package:earn_time_to_play/core/theme/app_theme.dart';
import 'package:earn_time_to_play/widgets/app_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('bottom navigation destinations stay above the system inset',
      (tester) async {
    const viewPadding = EdgeInsets.only(top: 48, bottom: 32);
    await tester.binding.setSurfaceSize(const Size(400, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(
          size: Size(400, 800),
          padding: viewPadding,
          viewPadding: viewPadding,
        ),
        child: MaterialApp.router(
          routerConfig: GoRouter(
            initialLocation: '/today',
            routes: [
              ShellRoute(
                builder: (context, state, child) => AppShell(child: child),
                routes: [
                  GoRoute(
                    path: '/today',
                    builder: (context, state) => const SizedBox.expand(),
                  ),
                  GoRoute(
                    path: '/history',
                    builder: (context, state) => const SizedBox.expand(),
                  ),
                  GoRoute(
                    path: '/analytics',
                    builder: (context, state) => const SizedBox.expand(),
                  ),
                  GoRoute(
                    path: '/settings',
                    builder: (context, state) => const SizedBox.expand(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    final iconBottom = tester.getRect(find.byIcon(LucideIcons.home)).bottom;
    expect(iconBottom, lessThanOrEqualTo(800 - 32));
    expect(find.byType(NavigationBar), findsOneWidget);
  });

  test('system overlay style keeps bars transparent for edge-to-edge', () {
    final light = AppTheme.systemUiFor(Brightness.light);
    final dark = AppTheme.systemUiFor(Brightness.dark);

    expect(light.statusBarColor, Colors.transparent);
    expect(light.systemNavigationBarColor, Colors.transparent);
    expect(light.statusBarIconBrightness, Brightness.dark);
    expect(light.systemNavigationBarIconBrightness, Brightness.dark);

    expect(dark.statusBarColor, Colors.transparent);
    expect(dark.systemNavigationBarColor, Colors.transparent);
    expect(dark.statusBarIconBrightness, Brightness.light);
    expect(dark.systemNavigationBarIconBrightness, Brightness.light);
    expect(dark.systemNavigationBarContrastEnforced, isFalse);
  });
}
