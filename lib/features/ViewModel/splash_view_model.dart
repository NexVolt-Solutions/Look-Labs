import 'package:flutter/material.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
import 'package:looklabs/Repository/onboarding_repository.dart';

class SplashViewModel extends ChangeNotifier {
  /// Set when session create fails; cleared on retry. No fallback: we only navigate when we have a session.
  String? sessionError;

  /// Restore or create session, then navigate only if we have a valid session. No fallback navigation on failure.
  void goTo(BuildContext context) async {
    sessionError = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 4));

    if (!context.mounted) return;

    final repo = OnboardingRepository.instance;
    final restored = await OnboardingRepository.loadStoredSession();
    if (restored) {
      debugPrint(
        '[SplashViewModel] Session restored from storage: ${OnboardingRepository.sessionId}',
      );
    } else {
      final response = await repo.createAnonymousSession();
      if (response.success && response.data != null) {
        debugPrint(
          '[SplashViewModel] Anonymous session created: ${OnboardingRepository.sessionId}',
        );
      } else {
        debugPrint(
          '[SplashViewModel] Anonymous session failed: statusCode=${response.statusCode} message=${response.message}',
        );
        sessionError = response.message ?? 'Failed to start. Please try again.';
        notifyListeners();
        return;
      }
    }

    if (!context.mounted) return;
    Navigator.pushNamed(context, RoutesName.StartScreen);
  }
}
