import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
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
/// On iOS this starts a Live Activity (lock screen + Dynamic Island) and falls
/// back to a time-sensitive notification if Live Activities are unavailable.
class LockScreenTimerService implements LockScreenTimer {
  LockScreenTimerService({
    FlutterLocalNotificationsPlugin? plugin,
    Future<AppLocalizations> Function()? resolveL10n,
  })  : _plugin = plugin ?? FlutterLocalNotificationsPlugin(),
        _resolveL10n = resolveL10n ?? _l10nFromPrefs;

  static final LockScreenTimerService instance = LockScreenTimerService();
  static const _liveActivityChannel = MethodChannel(
    'com.thcathy.earntimetoplay/live_activity',
  );
  static const _initTimeout = Duration(seconds: 5);
  static const _channelTimeout = Duration(seconds: 3);

  final FlutterLocalNotificationsPlugin _plugin;
  final Future<AppLocalizations> Function() _resolveL10n;
  bool _initialized = false;
  StopwatchState? _queued;
  Future<void> _syncChain = Future.value();

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
      await _plugin
          .initialize(
            const InitializationSettings(android: android, iOS: darwin),
          )
          .timeout(_initTimeout);
      _initialized = true;
    } catch (e) {
      debugPrint('LockScreenTimerService.initialize failed: $e');
    }
  }

  @override
  Future<void> sync(StopwatchState state) async {
    if (!isSupported) return;
    _queued = state;
    final previous = _syncChain;
    _syncChain = () async {
      try {
        await previous;
      } catch (_) {}
      await _flush();
    }();
    await _syncChain;
  }

  Future<void> _flush() async {
    while (_queued != null) {
      final next = _queued!;
      _queued = null;
      try {
        await _apply(next);
      } catch (e) {
        debugPrint('LockScreenTimerService.sync failed: $e');
      }
    }
  }

  Future<void> _apply(StopwatchState state) async {
    if (!state.isRunning) {
      await _dismiss();
      return;
    }

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final l10n = await _resolveL10n();
      final started = await _startLiveActivity(
        mode: state.mode,
        title: state.isPlay ? l10n.playTimer : l10n.focusTimer,
        startedAtMillis: state.chronometerWhenMillis(),
      );
      if (started) {
        await _cancelNotification();
        return;
      }
    }

    await initialize();
    if (!_initialized) return;

    await _requestPermission();
    await _show(state);
  }

  Future<void> _dismiss() async {
    if (!isSupported) return;
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      await _endLiveActivity();
    }
    if (!_initialized) return;
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
    await _cancelNotification();
  }

  Future<void> _cancelNotification() async {
    if (!_initialized) return;
    try {
      await _plugin.cancel(AppConstants.lockScreenTimerNotificationId);
    } catch (e) {
      debugPrint('LockScreenTimerService.cancel failed: $e');
    }
  }

  Future<bool> _startLiveActivity({
    required String mode,
    required String title,
    required int startedAtMillis,
  }) async {
    try {
      final started = await _liveActivityChannel.invokeMethod<bool>(
        'start',
        {
          'mode': mode,
          'title': title,
          'startedAtMillis': startedAtMillis,
        },
      ).timeout(_channelTimeout);
      return started == true;
    } catch (e) {
      debugPrint('LockScreenTimerService.liveActivity start failed: $e');
      return false;
    }
  }

  Future<void> _endLiveActivity() async {
    try {
      await _liveActivityChannel
          .invokeMethod<bool>('end')
          .timeout(_channelTimeout);
    } catch (e) {
      debugPrint('LockScreenTimerService.liveActivity end failed: $e');
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
    final title = state.isPlay ? l10n.playTimer : l10n.focusTimer;
    final body = state.isPlay ? l10n.playTimerRunning : l10n.focusTimerRunning;
    final color = state.isPlay ? AppColors.playLight : AppColors.focusLight;
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

    if (defaultTargetPlatform == TargetPlatform.android) {
      try {
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
      } catch (e) {
        debugPrint('LockScreenTimerService.show failed: $e');
      }
    }

    try {
      await _plugin.show(
        AppConstants.lockScreenTimerNotificationId,
        title,
        body,
        details,
      );
    } catch (e) {
      debugPrint('LockScreenTimerService.show failed: $e');
    }
  }

  static Future<AppLocalizations> _l10nFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return AppLocalizations.fromLocaleCode(
      prefs.getString(localePreferenceKey),
    );
  }
}
