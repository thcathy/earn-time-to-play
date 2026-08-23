import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'services/lock_screen_timer_service.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  await StorageService.instance.initialize();
  await LockScreenTimerService.instance.initialize();

  runApp(
    const ProviderScope(
      child: TimeBankApp(),
    ),
  );
}

