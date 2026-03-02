import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:looklabs/Core/Network/api_services.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
import 'package:looklabs/Features/ViewModel/auth_view_model.dart';
import 'package:looklabs/Repository/auth_repository.dart';
import 'package:looklabs/Repository/onboarding_repository.dart';
import 'package:provider/provider.dart';

class SplashViewModel extends ChangeNotifier {
  /// Set when session create fails; cleared on retry. No fallback: we only navigate when we have a session.
  String? sessionError;

  /// Restore persisted auth token, then navigate: if token exists go to Home (no onboarding); else create/restore session and go to Start.
  void goTo(BuildContext context) async {
    sessionError = null;
    notifyListeners();

    // Restore API token so subsequent calls use it; if present we skip onboarding.
    await AuthRepository.restoreAuthToken();

    await Future.delayed(const Duration(seconds: 4));

    if (!context.mounted) return;

    // User already signed in and session was linked → go straight to Home (no onboarding APIs).
    if (ApiServices.authToken != null && ApiServices.authToken!.isNotEmpty) {
      if (kDebugMode) {
        debugPrint('[Splash] Has token → navigating to Home (BottomSheetBarScreen)');
      }
      try {
        await context.read<AuthViewModel>().fetchProfile();
      } catch (_) {}
      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        RoutesName.BottomSheetBarScreen,
        (route) => false,
      );
      return;
    }

    // No token: anonymous flow – restore or create session, then StartScreen.
    final restored = await OnboardingRepository.loadStoredSession();
    if (!restored) {
      final response = await OnboardingRepository.instance.createAnonymousSession();
      if (!response.success || response.data == null) {
        sessionError = response.message ?? 'Failed to start. Please try again.';
        notifyListeners();
        return;
      }
    }

    if (!context.mounted) return;
    Navigator.pushNamed(context, RoutesName.StartScreen);
  }
}
