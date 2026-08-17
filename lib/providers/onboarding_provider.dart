import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';

/// Whether the user has completed first-run onboarding.
final onboardingCompletedProvider =
    StateNotifierProvider<OnboardingNotifier, bool>((ref) {
  return OnboardingNotifier();
});

class OnboardingNotifier extends StateNotifier<bool> {
  OnboardingNotifier()
      : super(StorageService.instance.isOnboardingCompleted());

  Future<void> complete() async {
    await StorageService.instance.setOnboardingCompleted(true);
    state = true;
  }

  /// Allows replaying onboarding from Settings (does not clear data).
  Future<void> reset() async {
    await StorageService.instance.setOnboardingCompleted(false);
    state = false;
  }
}
