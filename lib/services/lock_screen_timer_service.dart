import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';
import '../core/theme/colors.dart';
import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';
import 'stopwatch_service.dart';

/// Keeps the lock-screen / notification shade in sync with the stopwatch.
abstract class LockScreenTimer {
  Future<void> sync(StopwatchState state);
}

/// Shows a live elapsed-time notification while Focus or Play is counting.
///
/// On Android this is an ongoing chronometer (native lock-screen timer) backed
/// by a foreground service so it survives the app moving to the background.
/// On iOS it is a time-sensitive notification; a counting Live Activity would
/// need a Widget Extension and is left as a follow-up.
class LockScreenTimerService implements LockScreenTimer {
  LockScreenTimerService({
    FlutterLocalNotificationsPlugin? plugin,
    Future<AppLocalizations> Function()? resolveL10n,
  })  : _plugin = plugin ?? FlutterLocalNotificationsPlugin(),
        _resolveL10n = resolveL10n ?? _l10nFromPrefs;

  static final LockScreenTimerService instance = LockScreenTimerService();

  final FlutterLocalNotificationsPlugin _plugin;
  final Future<AppLocalizations> Function() _resolveL10n;
  bool _initialized = false;

  static bool get isSupported {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  Future<void> initialize() async {
    if (_initialized || !isSupported) return;

    const android = AndroidInitializationSettings('@drawable/ic_stat_timer');
    const darwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      defaultPresentAlert: false,
      defaultPresentSound: false,
      defaultPresentBadge: false,
      defaultPresentBanner: false,
      defaultPresentList: true,
    );

    try {
      await _plugin.initialize(
        const InitializationSettings(android: android, iOS: darwin),
      );
      _initialized = true;
    } catch (e) {
      debugPrint('LockScreenTimerService.initialize failed: $e');
    }
  }

  @override
  Future<void> sync(StopwatchState state) async {
    if (!isSupported) return;
    await initialize();
    if (!_initialized) return;

    if (!state.isRunning) {
      await hide();
      return;
    }

    await _requestPermission();
    await _show(state);
  }

  Future<void> hide() async {
    if (!isSupported || !_initialized) return;
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        await _plugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.stopForegroundService();
      }
    } catch (e) {
      debugPrint('LockScreenTimerService.stopForegroundService failed: $e');
    }
    try {
      await _plugin.cancel(AppConstants.lockScreenTimerNotificationId);
    } catch (e) {
      debugPrint('LockScreenTimerService.cancel failed: $e');
    }
  }

  Future<void> _requestPermission() async {
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        await _plugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission();
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        await _plugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(alert: true, badge: false, sound: false);
      }
    } catch (e) {
      debugPrint('LockScreenTimerService.permission failed: $e');
    }
  }

  Future<void> _show(StopwatchState state) async {
    final l10n = await _resolveL10n();
    final isPlay = state.mode == 'play';
    final title = isPlay ? l10n.playTimer : l10n.focusTimer;
    final body = isPlay ? l10n.playTimerRunning : l10n.focusTimerRunning;
    final color = isPlay ? AppColors.playLight : AppColors.focusLight;
    final when = state.chronometerWhenMillis();

    final androidDetails = AndroidNotificationDetails(
      AppConstants.lockScreenTimerChannelId,
      l10n.lockScreenTimerChannelName,
      channelDescription: l10n.lockScreenTimerChannelDescription,
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true,
      autoCancel: false,
      playSound: false,
      enableVibration: false,
      onlyAlertOnce: true,
      showWhen: true,
      when: when,
      usesChronometer: true,
      chronometerCountDown: false,
      visibility: NotificationVisibility.public,
      category: AndroidNotificationCategory.stopwatch,
      color: color,
      colorized: true,
      icon: '@drawable/ic_stat_timer',
      channelShowBadge: false,
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: false,
      presentBanner: false,
      presentList: true,
      presentSound: false,
      presentBadge: false,
      interruptionLevel: InterruptionLevel.timeSensitive,
      threadIdentifier: AppConstants.lockScreenTimerChannelId,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );

    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        final android = _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
        if (android != null) {
          await android.startForegroundService(
            AppConstants.lockScreenTimerNotificationId,
            title,
            body,
            notificationDetails: androidDetails,
            startType: AndroidServiceStartType.startSticky,
            foregroundServiceTypes: {
              AndroidServiceForegroundType.foregroundServiceTypeSpecialUse,
            },
          );
          return;
        }
      }

      await _plugin.show(
        AppConstants.lockScreenTimerNotificationId,
        title,
        body,
        details,
      );
    } catch (e) {
      debugPrint('LockScreenTimerService.show failed: $e');
      try {
        await _plugin.show(
          AppConstants.lockScreenTimerNotificationId,
          title,
          body,
          details,
        );
      } catch (fallbackError) {
        debugPrint(
          'LockScreenTimerService.show fallback failed: $fallbackError',
        );
      }
    }
  }

  static Future<AppLocalizations> _l10nFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return AppLocalizations.fromLocaleCode(
      prefs.getString(localePreferenceKey),
    );
  }
}
