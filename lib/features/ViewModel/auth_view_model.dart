import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:looklabs/Core/Config/env_loader.dart';
import 'package:looklabs/Core/Network/models/user_profile_response.dart';
import 'package:looklabs/Model/user_model.dart';
import 'package:looklabs/Repository/auth_repository.dart';
import 'package:looklabs/Repository/onboarding_repository.dart';

const String? _kWebClientIdOverride = null;

String? get _googleWebClientId =>
    _kWebClientIdOverride ?? env('GOOGLE_WEB_CLIENT_ID');

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepo = AuthRepository.instance;
  late final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId: _googleWebClientId,
  );

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool _isLoading = false;
  String? _errorMessage;
  UserModel? _user;
  UserProfileResponse? _profile;
  bool _isSelected = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserModel? get user => _user;

  /// Full profile from GET users/me (name, email, age, gender, profile_image, subscription, etc.).
  UserProfileResponse? get profile => _profile;
  bool get isLoggedIn => _user != null;
  bool get isSelected => _isSelected;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void toggleSubscriptionSelected() {
    _isSelected = !_isSelected;
    notifyListeners();
  }

  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final GoogleSignInAuthentication auth = await googleUser.authentication;
      final idToken = auth.idToken;
      final accessToken = auth.accessToken;

      if (idToken == null) {
        _errorMessage =
            'Failed to get Google credentials. Add GOOGLE_WEB_CLIENT_ID to api.env (Web client ID, not Android).';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      await _firebaseAuth.signInWithCredential(
        GoogleAuthProvider.credential(
          idToken: idToken,
          accessToken: accessToken,
        ),
      );

      final response = await _authRepo.signInWithGoogle(
        idToken: idToken,
        accessToken: accessToken,
        name: googleUser.displayName,
        profileImage: googleUser.photoUrl,
      );

      if (response.success && response.data != null) {
        _user = _parseUser(response.data);
        final sessionId = OnboardingRepository.sessionId;
        if (sessionId != null && sessionId.isNotEmpty) {
          await OnboardingRepository.instance.linkSessionToUser(sessionId);
        }
        await OnboardingRepository.clearSession();
        _errorMessage = null;
        _isLoading = false;
        notifyListeners();
        return true;
      }

      final detail = response.data is Map
          ? (response.data as Map)['detail']?.toString() ?? ''
          : '';
      final isServerError =
          detail.contains('MissingGreenlet') ||
          detail.contains('greenlet_spawn') ||
          detail.contains('await_only()');
      _errorMessage = isServerError
          ? 'Sign-in failed due to a server error. Please try again later.'
          : (response.message ?? 'Sign in failed');
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e, _) {
      final msg = e.toString();
      _errorMessage =
          (msg.contains('ApiException: 10') || msg.contains('sign_in_failed'))
          ? 'Google Sign-In config error. Use Web client ID in api.env as GOOGLE_WEB_CLIENT_ID.'
          : msg.replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  UserModel? _parseUser(dynamic data) {
    if (data == null || data is! Map) return null;
    final userData = data['user'] ?? data['data']?['user'] ?? data;
    if (userData is Map) {
      try {
        return UserModel.fromJson(Map<String, dynamic>.from(userData));
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  /// Fetch user profile from GET users/me. Sets [user] and [profile].
  Future<void> fetchProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _authRepo.getMe();
      if (response.success && response.data is UserProfileResponse) {
        final p = response.data as UserProfileResponse;
        _profile = p;
        _user = UserModel(
          id: p.id?.toString() ?? '',
          email: p.email,
          name: p.name,
          profileImage: p.profileImage,
          phone: null,
        );
        _errorMessage = null;
      } else {
        _errorMessage = response.message;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    }
    _isLoading = false;
    notifyListeners();
  }

  /// Logout - clears Firebase and API token
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      await _authRepo.logout();
      _user = null;
      _profile = null;
      _errorMessage = null;
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
  }
}
