import 'package:flutter/material.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
import 'package:looklabs/Repository/onboarding_repository.dart';

class SplashViewModel extends ChangeNotifier {
  /// After splash delay: restore session from storage if any, else create anonymous session; then go to StartScreen.
  void goTo(BuildContext context) async {
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
      }
    }

    if (!context.mounted) return;
    Navigator.pushNamed(context, RoutesName.StartScreen);
  }
}
