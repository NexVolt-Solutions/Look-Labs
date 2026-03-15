import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:looklabs/Core/Network/api_services.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
import 'package:looklabs/Features/ViewModel/auth_view_model.dart';
import 'package:looklabs/Repository/auth_repository.dart';
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

    await Future.delayed(const Duration(milliseconds: 800));

    if (!context.mounted) return;

    // User has stored token → try refresh first (token may be expired). If refresh fails, go to Auth.
    if (ApiServices.authToken != null && ApiServices.authToken!.isNotEmpty) {
      final refreshRes = await AuthRepository.instance.refreshToken();
      if (!refreshRes.success) {
        if (kDebugMode) {
          debugPrint('[Splash] Token expired/invalid, refresh failed → clearing tokens, go to Auth');
        }
        await AuthRepository.clearTokensLocally();
        if (!context.mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutesName.AuthScreen,
          (route) => false,
        );
        return;
      }
      if (kDebugMode) {
        debugPrint('[Splash] Token refreshed → navigating to Home (BottomSheetBarScreen)');
      }
      // Apply user from refresh response so name/avatar show immediately without waiting for GET users/me.
      if (refreshRes.data is Map) {
        context.read<AuthViewModel>().applyUserFromRefresh(
          Map<String, dynamic>.from(refreshRes.data as Map),
        );
      }
      // Load profile and home data in background after navigation (Home screen will also load its data).
      final authVm = context.read<AuthViewModel>();
      Future.microtask(() async {
        try {
          await authVm.fetchProfile();
        } catch (_) {}
      });
      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        RoutesName.BottomSheetBarScreen,
        (route) => false,
      );
      return;
    }

    // No token: go to Auth screen. Do not create a session – returning users (is_new_user: false) must not get a new session.
    // New users will sign in, get is_new_user: true, then we create a session and go to onboarding from the auth screen.
    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      RoutesName.AuthScreen,
      (route) => false,
    );
  }
}
