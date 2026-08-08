import 'package:share_plus/share_plus.dart';
import '../core/constants.dart';
import '../l10n/app_localizations.dart';
import '../providers/time_bank_provider.dart';
import 'time_utils.dart';

/// Builds and shares a short progress blurb for word-of-mouth growth.
class ShareProgress {
  ShareProgress._();

  static String buildMessage(TimeBankState state, AppLocalizations? l10n) {
    final balance = TimeUtils.formatMinutesWithSign(state.currentBalance);
    final focus = TimeUtils.formatMinutes(state.totalFocusMinutes);
    final play = TimeUtils.formatMinutes(state.totalPlayMinutes);
    final streak = state.trackingStreak;

    final headline = l10n?.shareProgressHeadline ??
        'I balance focus and play with Earn Time To Play';
    final stats = l10n?.shareProgressStats(balance, focus, play, streak.toString()) ??
        'Balance: $balance · Focus: $focus · Play: $play · Streak: $streak days';
    final cta = l10n?.shareProgressCta ?? 'Try it free:';

    return '$headline\n$stats\n$cta ${AppConstants.webAppUrl}';
  }

  static Future<void> share(TimeBankState state, AppLocalizations? l10n) {
    return Share.share(
      buildMessage(state, l10n),
      subject: l10n?.appTitle ?? 'Earn Time To Play',
    );
  }
}
