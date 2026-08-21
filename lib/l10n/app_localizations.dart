import 'package:flutter/material.dart';

/// Application localizations
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': _enStrings,
    'zh': _zhTWStrings,
    'zh_TW': _zhTWStrings,
    'zh_CN': _zhCNStrings,
  };

  String _getString(String key) {
    final languageCode = locale.countryCode != null
        ? '${locale.languageCode}_${locale.countryCode}'
        : locale.languageCode;
    return _localizedValues[languageCode]?[key] ??
        _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']![key] ??
        key;
  }

  // Getters for all strings
  String get appTitle => _getString('appTitle');
  String get today => _getString('today');
  String get yesterday => _getString('yesterday');
  String get history => _getString('history');
  String get analytics => _getString('analytics');
  String get settings => _getString('settings');
  
  String get balance => _getString('balance');
  String get youCanPlay => _getString('youCanPlay');
  String get lowBalance => _getString('lowBalance');
  String get noPlayTime => _getString('noPlayTime');
  String get minutes => _getString('minutes');
  String get min => _getString('min');
  String get hours => _getString('hours');
  
  String get todayProgress => _getString('todayProgress');
  String get focus => _getString('focus');
  String get play => _getString('play');
  String get delta => _getString('delta');
  
  String get quickAdd => _getString('quickAdd');
  String get stopwatch => _getString('stopwatch');
  String get addFocusTime => _getString('addFocusTime');
  String get addPlayTime => _getString('addPlayTime');
  String get enterMinutes => _getString('enterMinutes');
  String get add => _getString('add');
  
  String get focusTimer => _getString('focusTimer');
  String get playTimer => _getString('playTimer');
  String get start => _getString('start');
  String get stop => _getString('stop');
  String get reset => _getString('reset');
  String logTimeQuestion(String type) => _getString('logTimeQuestion').replaceAll('{type}', type);
  String trackedTimeMessage(String time, String type) => 
      _getString('trackedTimeMessage').replaceAll('{time}', time).replaceAll('{type}', type);
  String get discard => _getString('discard');
  String get timerRecovered => _getString('timerRecovered');
  String timerRecoveredMessage(String type, String time) => 
      _getString('timerRecoveredMessage').replaceAll('{type}', type).replaceAll('{time}', time);
  String get continueTimer => _getString('continueTimer');
  String get complete => _getString('complete');
  String completionMessage(String minutes, String type) => 
      _getString('completionMessage').replaceAll('{minutes}', minutes).replaceAll('{type}', type);
  String get addTime => _getString('addTime');
  String get tooShort => _getString('tooShort');
  String get tooShortMessage => _getString('tooShortMessage');
  String get focusTimerRunning => _getString('focusTimerRunning');
  String get playTimerRunning => _getString('playTimerRunning');
  
  String get thisWeek => _getString('thisWeek');
  String get thisMonth => _getString('thisMonth');
  String get allTime => _getString('allTime');
  String get noEntriesYet => _getString('noEntriesYet');
  String get startTrackingMessage => _getString('startTrackingMessage');
  String get editEntry => _getString('editEntry');
  String get focusMinutes => _getString('focusMinutes');
  String get playMinutes => _getString('playMinutes');
  String get saveChanges => _getString('saveChanges');
  String get deleteEntry => _getString('deleteEntry');
  String get deleteEntryConfirm => _getString('deleteEntryConfirm');
  String get cancel => _getString('cancel');
  String get delete => _getString('delete');
  
  String get weeklyOverview => _getString('weeklyOverview');
  String get balanceTrend => _getString('balanceTrend');
  String get timeDistribution => _getString('timeDistribution');
  String get totalFocus => _getString('totalFocus');
  String get totalPlay => _getString('totalPlay');
  String get avgDailyDelta => _getString('avgDailyDelta');
  String get positiveStreak => _getString('positiveStreak');
  String get days => _getString('days');
  
  String get appearance => _getString('appearance');
  String get system => _getString('system');
  String get followSystemSettings => _getString('followSystemSettings');
  String get light => _getString('light');
  String get alwaysLightTheme => _getString('alwaysLightTheme');
  String get dark => _getString('dark');
  String get alwaysDarkTheme => _getString('alwaysDarkTheme');
  
  String get language => _getString('language');
  String get english => _getString('english');
  String get traditionalChinese => _getString('traditionalChinese');
  String get simplifiedChinese => _getString('simplifiedChinese');
  
  String get balanceSettings => _getString('balanceSettings');
  String get startingBalance => _getString('startingBalance');
  String get startingBalanceDesc => _getString('startingBalanceDesc');
  String get warningThreshold => _getString('warningThreshold');
  String get warningThresholdDesc => _getString('warningThresholdDesc');
  String get maxPlayPerDay => _getString('maxPlayPerDay');
  String get maxPlayPerDayDesc => _getString('maxPlayPerDayDesc');
  
  String get behavior => _getString('behavior');
  String get allowOverdraft => _getString('allowOverdraft');
  String get allowOverdraftDesc => _getString('allowOverdraftDesc');
  
  String get data => _getString('data');
  String get exportData => _getString('exportData');
  String get exportDataDesc => _getString('exportDataDesc');
  String get resetAllData => _getString('resetAllData');
  String get resetAllDataDesc => _getString('resetAllDataDesc');
  String get resetConfirmTitle => _getString('resetConfirmTitle');
  String get resetConfirmMessage => _getString('resetConfirmMessage');
  String get resetButton => _getString('resetButton');
  String get dataResetSuccess => _getString('dataResetSuccess');
  
  String get about => _getString('about');
  String get github => _getString('github');
  String get viewSourceCode => _getString('viewSourceCode');
  String version(String ver) => _getString('version').replaceAll('{version}', ver);
  String get copyright => _getString('copyright');
  String get madeWithLove => _getString('madeWithLove');

  // Onboarding & growth
  String get skip => _getString('skip');
  String get next => _getString('next');
  String get getStarted => _getString('getStarted');
  String get onboardingEarnTitle => _getString('onboardingEarnTitle');
  String get onboardingEarnBody => _getString('onboardingEarnBody');
  String get onboardingSpendTitle => _getString('onboardingSpendTitle');
  String get onboardingSpendBody => _getString('onboardingSpendBody');
  String get onboardingStreakTitle => _getString('onboardingStreakTitle');
  String get onboardingStreakBody => _getString('onboardingStreakBody');
  String streakDays(int days) =>
      _getString('streakDays').replaceAll('{days}', days.toString());
  String get startStreak => _getString('startStreak');
  String get keepStreakAlive => _getString('keepStreakAlive');
  String get shareProgress => _getString('shareProgress');
  String get shareProgressDesc => _getString('shareProgressDesc');
  String get shareProgressHeadline => _getString('shareProgressHeadline');
  String shareProgressStats(
    String balance,
    String focus,
    String play,
    String streak,
  ) =>
      _getString('shareProgressStats')
          .replaceAll('{balance}', balance)
          .replaceAll('{focus}', focus)
          .replaceAll('{play}', play)
          .replaceAll('{streak}', streak);
  String get shareProgressCta => _getString('shareProgressCta');
  String get inviteFriends => _getString('inviteFriends');
  String get replayOnboarding => _getString('replayOnboarding');
  String get replayOnboardingDesc => _getString('replayOnboardingDesc');
  String get firstEntryTitle => _getString('firstEntryTitle');
  String get firstEntryBody => _getString('firstEntryBody');
  String get add15Focus => _getString('add15Focus');
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'zh'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

// English strings
const Map<String, String> _enStrings = {
  'appTitle': 'Earn Time To Play',
  'today': 'Today',
  'history': 'History',
  'analytics': 'Analytics',
  'settings': 'Settings',
  
  'balance': 'Balance',
  'youCanPlay': 'You can play!',
  'lowBalance': 'Running low – keep focusing!',
  'noPlayTime': 'No play time available',
  'minutes': 'minutes',
  'min': 'min',
  'hours': 'hours',
  
  'todayProgress': "Today's Progress",
  'focus': 'Focus',
  'play': 'Play',
  'delta': 'Delta',
  
  'quickAdd': 'Quick Add',
  'stopwatch': 'Stopwatch',
  'addFocusTime': 'Add Focus Time',
  'addPlayTime': 'Add Play Time',
  'enterMinutes': 'Enter minutes',
  'add': 'Add',
  
  'focusTimer': 'Focus Timer',
  'playTimer': 'Play Timer',
  'start': 'Start',
  'stop': 'Stop',
  'reset': 'Reset',
  'logTimeQuestion': 'Log {type} Time?',
  'trackedTimeMessage': 'You tracked {time} of {type} time. Do you want to add this to your balance?',
  'discard': 'Discard',
  'timerRecovered': 'Timer Recovered',
  'timerRecoveredMessage': 'You have an active {type} timer running for {time}.\n\nWould you like to continue or discard it?',
  'continueTimer': 'Continue',
  'complete': 'Complete',
  'completionMessage': 'You spent {minutes} minute(s) on {type}.\n\nAdd this time to your balance?',
  'addTime': 'Add Time',
  'tooShort': 'Too Short',
  'tooShortMessage': 'You need at least 1 minute to log time. Keep going!',
  'focusTimerRunning': 'Focus timer is running',
  'playTimerRunning': 'Play timer is running',
  
  'thisWeek': 'This Week',
  'thisMonth': 'This Month',
  'allTime': 'All Time',
  'noEntriesYet': 'No entries yet',
  'startTrackingMessage': 'Start tracking your focus and play time!',
  'editEntry': 'Edit Entry',
  'focusMinutes': 'Focus Minutes',
  'playMinutes': 'Play Minutes',
  'saveChanges': 'Save Changes',
  'deleteEntry': 'Delete Entry',
  'deleteEntryConfirm': 'Are you sure you want to delete this entry?',
  'cancel': 'Cancel',
  'delete': 'Delete',
  
  'weeklyOverview': 'Weekly Overview',
  'balanceTrend': 'Balance Trend (14 Days)',
  'timeDistribution': 'Time Distribution',
  'totalFocus': 'Total Focus',
  'totalPlay': 'Total Play',
  'avgDailyDelta': 'Avg Daily Delta',
  'positiveStreak': 'Positive Streak',
  'days': 'days',
  
  'appearance': 'Appearance',
  'system': 'System',
  'followSystemSettings': 'Follow system settings',
  'light': 'Light',
  'alwaysLightTheme': 'Always use light theme',
  'dark': 'Dark',
  'alwaysDarkTheme': 'Always use dark theme',
  
  'language': 'Language',
  'english': 'English',
  'traditionalChinese': '繁體中文',
  'simplifiedChinese': '简体中文',
  
  'balanceSettings': 'Balance Settings',
  'startingBalance': 'Starting Balance',
  'startingBalanceDesc': 'Initial balance when you started',
  'warningThreshold': 'Warning Threshold',
  'warningThresholdDesc': 'Warn when balance drops below',
  'maxPlayPerDay': 'Max Play Per Day',
  'maxPlayPerDayDesc': 'Optional daily limit (0 = unlimited)',
  
  'behavior': 'Behavior',
  'allowOverdraft': 'Allow Overdraft',
  'allowOverdraftDesc': 'Allow play even with negative balance',
  
  'data': 'Data',
  'exportData': 'Export Data',
  'exportDataDesc': 'Export all entries as CSV',
  'resetAllData': 'Reset All Data',
  'resetAllDataDesc': 'Delete all entries and settings',
  'resetConfirmTitle': 'Reset All Data',
  'resetConfirmMessage': 'This will permanently delete all your time entries and reset settings to defaults. This action cannot be undone.',
  'resetButton': 'Reset',
  'dataResetSuccess': 'All data has been reset',
  
  'about': 'About',
  'github': 'GitHub',
  'viewSourceCode': 'View source code',
  'version': 'Version {version}',
  'copyright': '© 2025 Timmy Wong',
  'madeWithLove': 'Made with ❤️ in Flutter',

  'skip': 'Skip',
  'next': 'Next',
  'getStarted': 'Get started',
  'onboardingEarnTitle': 'Earn time by focusing',
  'onboardingEarnBody':
      'Study, work, or learn — every focused minute deposits into your time bank.',
  'onboardingSpendTitle': 'Spend time by playing',
  'onboardingSpendBody':
      'Withdraw from your balance when you game. Play stays guilt-free when you have earned it.',
  'onboardingStreakTitle': 'Build a daily streak',
  'onboardingStreakBody':
      'Log a little each day to keep your streak alive. Share progress and invite friends to balance with you.',
  'streakDays': '{days}-day streak',
  'startStreak': 'Start your streak today',
  'keepStreakAlive': 'Log today to keep it',
  'shareProgress': 'Share Progress',
  'shareProgressDesc': 'Share your balance and streak with friends',
  'shareProgressHeadline': 'I balance focus and play with Earn Time To Play',
  'shareProgressStats':
      'Balance: {balance} · Focus: {focus} · Play: {play} · Streak: {streak} days',
  'shareProgressCta': 'Try it free:',
  'inviteFriends': 'Invite Friends',
  'replayOnboarding': 'How it works',
  'replayOnboardingDesc': 'Replay the short intro to the earn/spend loop',
  'firstEntryTitle': 'Make your first deposit',
  'firstEntryBody':
      'Log 15 minutes of focus to unlock play time and start your streak.',
  'add15Focus': 'Add 15 min focus',
};

// Traditional Chinese strings
const Map<String, String> _zhTWStrings = {
  'appTitle': '學習時間賺遊戲時間',
  'today': '今天',
  'history': '歷史',
  'analytics': '分析',
  'settings': '設定',
  
  'balance': '餘額',
  'youCanPlay': '可以玩遊戲了！',
  'lowBalance': '餘額偏低 – 繼續專注！',
  'noPlayTime': '沒有可用的遊戲時間',
  'minutes': '分鐘',
  'min': '分鐘',
  'hours': '小時',
  
  'todayProgress': '今日進度',
  'focus': '專注',
  'play': '遊戲',
  'delta': '差額',
  
  'quickAdd': '快速新增',
  'stopwatch': '計時器',
  'addFocusTime': '新增專注時間',
  'addPlayTime': '新增遊戲時間',
  'enterMinutes': '輸入分鐘',
  'add': '新增',
  
  'focusTimer': '專注計時器',
  'playTimer': '遊戲計時器',
  'start': '開始',
  'stop': '停止',
  'reset': '重置',
  'logTimeQuestion': '記錄{type}時間？',
  'trackedTimeMessage': '你追蹤了 {time} 的{type}時間。要加入餘額嗎？',
  'discard': '捨棄',
  'timerRecovered': '計時器已恢復',
  'timerRecoveredMessage': '你有一個進行中的{type}計時器，已運行 {time}。\n\n你要繼續還是捨棄它？',
  'continueTimer': '繼續',
  'complete': '完成',
  'completionMessage': '你花了 {minutes} 分鐘在{type}上。\n\n要把這段時間加入餘額嗎？',
  'addTime': '加入時間',
  'tooShort': '時間太短',
  'tooShortMessage': '需要至少 1 分鐘才能記錄時間。繼續加油！',
  'focusTimerRunning': '專注計時器運行中',
  'playTimerRunning': '遊戲計時器運行中',
  
  'thisWeek': '本週',
  'thisMonth': '本月',
  'allTime': '全部',
  'noEntriesYet': '尚無記錄',
  'startTrackingMessage': '開始追蹤你的專注和遊戲時間！',
  'editEntry': '編輯記錄',
  'focusMinutes': '專注分鐘數',
  'playMinutes': '遊戲分鐘數',
  'saveChanges': '儲存變更',
  'deleteEntry': '刪除記錄',
  'deleteEntryConfirm': '確定要刪除此記錄嗎？',
  'cancel': '取消',
  'delete': '刪除',
  
  'weeklyOverview': '每週概覽',
  'balanceTrend': '餘額趨勢（14天）',
  'timeDistribution': '時間分佈',
  'totalFocus': '總專注時間',
  'totalPlay': '總遊戲時間',
  'avgDailyDelta': '平均每日差額',
  'positiveStreak': '正餘額連續',
  'days': '天',
  
  'appearance': '外觀',
  'system': '系統',
  'followSystemSettings': '跟隨系統設定',
  'light': '淺色',
  'alwaysLightTheme': '始終使用淺色主題',
  'dark': '深色',
  'alwaysDarkTheme': '始終使用深色主題',
  
  'language': '語言',
  'english': 'English',
  'traditionalChinese': '繁體中文',
  'simplifiedChinese': '简体中文',
  
  'balanceSettings': '餘額設定',
  'startingBalance': '初始餘額',
  'startingBalanceDesc': '開始時的初始餘額',
  'warningThreshold': '警告門檻',
  'warningThresholdDesc': '餘額低於此值時警告',
  'maxPlayPerDay': '每日遊戲上限',
  'maxPlayPerDayDesc': '可選的每日限制（0 = 無限制）',
  
  'behavior': '行為',
  'allowOverdraft': '允許透支',
  'allowOverdraftDesc': '即使餘額為負也可以遊戲',
  
  'data': '資料',
  'exportData': '匯出資料',
  'exportDataDesc': '將所有記錄匯出為 CSV',
  'resetAllData': '重置所有資料',
  'resetAllDataDesc': '刪除所有記錄和設定',
  'resetConfirmTitle': '重置所有資料',
  'resetConfirmMessage': '這將永久刪除你的所有時間記錄並將設定重置為預設值。此操作無法撤銷。',
  'resetButton': '重置',
  'dataResetSuccess': '所有資料已重置',
  
  'about': '關於',
  'github': 'GitHub',
  'viewSourceCode': '查看原始碼',
  'version': '版本 {version}',
  'copyright': '© 2025 Timmy Wong',
  'madeWithLove': '以 ❤️ 用 Flutter 製作',

  'skip': '略過',
  'next': '下一步',
  'getStarted': '開始使用',
  'onboardingEarnTitle': '專注就能賺時間',
  'onboardingEarnBody': '讀書、工作或學習——每分鐘專注都會存進你的時間銀行。',
  'onboardingSpendTitle': '遊戲就花時間',
  'onboardingSpendBody': '想玩遊戲時從餘額提領。賺到的時間，玩起來更安心。',
  'onboardingStreakTitle': '建立每日連續紀錄',
  'onboardingStreakBody': '每天記錄一點，保持連續。分享進度，邀請朋友一起平衡。',
  'streakDays': '連續 {days} 天',
  'startStreak': '今天開始連續紀錄',
  'keepStreakAlive': '今天記一筆以延續',
  'shareProgress': '分享進度',
  'shareProgressDesc': '把餘額與連續天數分享給朋友',
  'shareProgressHeadline': '我用「學習時間賺遊戲時間」平衡專注與娛樂',
  'shareProgressStats':
      '餘額：{balance} · 專注：{focus} · 遊戲：{play} · 連續：{streak} 天',
  'shareProgressCta': '免費試試：',
  'inviteFriends': '邀請朋友',
  'replayOnboarding': '使用說明',
  'replayOnboardingDesc': '重新觀看賺/花時間的簡短介紹',
  'firstEntryTitle': '完成第一筆存入',
  'firstEntryBody': '先記錄 15 分鐘專注，解鎖遊戲時間並開始連續紀錄。',
  'add15Focus': '新增 15 分鐘專注',
};

// Simplified Chinese strings
const Map<String, String> _zhCNStrings = {
  'appTitle': '学习时间赚游戏时间',
  'today': '今天',
  'history': '历史',
  'analytics': '分析',
  'settings': '设置',
  
  'balance': '余额',
  'youCanPlay': '可以玩游戏了！',
  'lowBalance': '余额偏低 – 继续专注！',
  'noPlayTime': '没有可用的游戏时间',
  'minutes': '分钟',
  'min': '分钟',
  'hours': '小时',
  
  'todayProgress': '今日进度',
  'focus': '专注',
  'play': '游戏',
  'delta': '差额',
  
  'quickAdd': '快速添加',
  'stopwatch': '计时器',
  'addFocusTime': '添加专注时间',
  'addPlayTime': '添加游戏时间',
  'enterMinutes': '输入分钟',
  'add': '添加',
  
  'focusTimer': '专注计时器',
  'playTimer': '游戏计时器',
  'start': '开始',
  'stop': '停止',
  'reset': '重置',
  'logTimeQuestion': '记录{type}时间？',
  'trackedTimeMessage': '你追踪了 {time} 的{type}时间。要添加到余额吗？',
  'discard': '放弃',
  'timerRecovered': '计时器已恢复',
  'timerRecoveredMessage': '你有一个进行中的{type}计时器，已运行 {time}。\n\n你要继续还是放弃它？',
  'continueTimer': '继续',
  'complete': '完成',
  'completionMessage': '你花了 {minutes} 分钟在{type}上。\n\n要把这段时间加入余额吗？',
  'addTime': '加入时间',
  'tooShort': '时间太短',
  'tooShortMessage': '需要至少 1 分钟才能记录时间。继续加油！',
  'focusTimerRunning': '专注计时器运行中',
  'playTimerRunning': '游戏计时器运行中',
  
  'thisWeek': '本周',
  'thisMonth': '本月',
  'allTime': '全部',
  'noEntriesYet': '暂无记录',
  'startTrackingMessage': '开始追踪你的专注和游戏时间！',
  'editEntry': '编辑记录',
  'focusMinutes': '专注分钟数',
  'playMinutes': '游戏分钟数',
  'saveChanges': '保存更改',
  'deleteEntry': '删除记录',
  'deleteEntryConfirm': '确定要删除此记录吗？',
  'cancel': '取消',
  'delete': '删除',
  
  'weeklyOverview': '每周概览',
  'balanceTrend': '余额趋势（14天）',
  'timeDistribution': '时间分布',
  'totalFocus': '总专注时间',
  'totalPlay': '总游戏时间',
  'avgDailyDelta': '平均每日差额',
  'positiveStreak': '正余额连续',
  'days': '天',
  
  'appearance': '外观',
  'system': '系统',
  'followSystemSettings': '跟随系统设置',
  'light': '浅色',
  'alwaysLightTheme': '始终使用浅色主题',
  'dark': '深色',
  'alwaysDarkTheme': '始终使用深色主题',
  
  'language': '语言',
  'english': 'English',
  'traditionalChinese': '繁體中文',
  'simplifiedChinese': '简体中文',
  
  'balanceSettings': '余额设置',
  'startingBalance': '初始余额',
  'startingBalanceDesc': '开始时的初始余额',
  'warningThreshold': '警告阈值',
  'warningThresholdDesc': '余额低于此值时警告',
  'maxPlayPerDay': '每日游戏上限',
  'maxPlayPerDayDesc': '可选的每日限制（0 = 无限制）',
  
  'behavior': '行为',
  'allowOverdraft': '允许透支',
  'allowOverdraftDesc': '即使余额为负也可以游戏',
  
  'data': '数据',
  'exportData': '导出数据',
  'exportDataDesc': '将所有记录导出为 CSV',
  'resetAllData': '重置所有数据',
  'resetAllDataDesc': '删除所有记录和设置',
  'resetConfirmTitle': '重置所有数据',
  'resetConfirmMessage': '这将永久删除你的所有时间记录并将设置重置为默认值。此操作无法撤销。',
  'resetButton': '重置',
  'dataResetSuccess': '所有数据已重置',
  
  'about': '关于',
  'github': 'GitHub',
  'viewSourceCode': '查看源代码',
  'version': '版本 {version}',
  'copyright': '© 2025 Timmy Wong',
  'madeWithLove': '以 ❤️ 用 Flutter 制作',

  'skip': '跳过',
  'next': '下一步',
  'getStarted': '开始使用',
  'onboardingEarnTitle': '专注就能赚时间',
  'onboardingEarnBody': '读书、工作或学习——每分钟专注都会存进你的时间银行。',
  'onboardingSpendTitle': '游戏就花时间',
  'onboardingSpendBody': '想玩游戏时从余额提取。赚到的时间，玩起来更安心。',
  'onboardingStreakTitle': '建立每日连续记录',
  'onboardingStreakBody': '每天记录一点，保持连续。分享进度，邀请朋友一起平衡。',
  'streakDays': '连续 {days} 天',
  'startStreak': '今天开始连续记录',
  'keepStreakAlive': '今天记一笔以延续',
  'shareProgress': '分享进度',
  'shareProgressDesc': '把余额与连续天数分享给朋友',
  'shareProgressHeadline': '我用「学习时间赚游戏时间」平衡专注与娱乐',
  'shareProgressStats':
      '余额：{balance} · 专注：{focus} · 游戏：{play} · 连续：{streak} 天',
  'shareProgressCta': '免费试试：',
  'inviteFriends': '邀请朋友',
  'replayOnboarding': '使用说明',
  'replayOnboardingDesc': '重新观看赚/花时间的简短介绍',
  'firstEntryTitle': '完成第一笔存入',
  'firstEntryBody': '先记录 15 分钟专注，解锁游戏时间并开始连续记录。',
  'add15Focus': '添加 15 分钟专注',
};

