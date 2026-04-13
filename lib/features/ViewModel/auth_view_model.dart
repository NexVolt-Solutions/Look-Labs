import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:looklabs/Core/Config/env_loader.dart';
import 'package:looklabs/Core/Network/api_error_handler.dart';
import 'package:looklabs/Core/Network/models/user_profile_response.dart';
import 'package:looklabs/Model/user_model.dart';
import 'package:looklabs/Repository/auth_repository.dart';
import 'package:looklabs/Repository/explore_domains_repository.dart';
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
  /// From last sign-in response: true = new user (show onboarding), false = returning (go to Home, do NOT create session).
  /// Default false when unknown – prefer skipping onboarding to avoid duplicate sessions for returning users.
  bool _isNewUser = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserModel? get user => _user;
  bool get isNewUser => _isNewUser;

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
        final data = response.data is Map ? response.data as Map : null;
        _user = _parseUser(response.data);
        _isNewUser = _extractIsNewUser(data);
        if (kDebugMode) {
          debugPrint('[Auth] is_new_user=$_isNewUser → ${_isNewUser ? "create session, onboarding" : "skip onboarding, go Home"}');
        }
        // Link is called in auth_screen after createAnonymousSession() for new users.
        if (!_isNewUser) {
          await OnboardingRepository.clearSession();
        }
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
          : ApiErrorHandler.userMessage(response, fallback: 'Sign in failed');
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

  /// Extract is_new_user from sign-in response. Check top-level and nested data.
  /// When absent or invalid, return false (skip onboarding) to avoid duplicate sessions for returning users.
  /// Handles bool, string "true"/"false", and int 1/0.
  bool _extractIsNewUser(Map? data) {
    if (data == null) return false;
    bool? from(dynamic v) {
      if (v == true || v == 1) return true;
      if (v == false || v == 0) return false;
      final s = v?.toString().toLowerCase();
      if (s == 'true' || s == '1') return true;
      if (s == 'false' || s == '0') return false;
      return null;
    }
    final top = from(data['is_new_user']);
    if (top != null) return top;
    final nested = data['data'];
    if (nested is Map) {
      final v = from(nested['is_new_user']);
      if (v != null) return v;
    }
    return false;
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

  /// Fetch user profile: always GET `users/me`.
  Future<void> fetchProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _authRepo.getMe();
      if (response.success && response.data is UserProfileResponse) {
        _applyProfile(response.data as UserProfileResponse);
        _errorMessage = null;
      } else {
        _errorMessage = ApiErrorHandler.userMessage(response, fallback: 'Could not load profile');
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    }
    _isLoading = false;
    notifyListeners();
  }

  void _applyProfile(UserProfileResponse p) {
    _profile = p;
    _user = UserModel(
      id: p.id?.toString() ?? '',
      email: p.email,
      name: p.name,
      profileImage: p.profileImage,
      phone: null,
    );
  }

  /// Apply user from auth/refresh response so UI can show name/avatar without awaiting GET users/me.
  void applyUserFromRefresh(Map<String, dynamic>? data) {
    if (data == null) return;
    final userJson = data['user'];
    if (userJson is! Map) return;
    try {
      final map = Map<String, dynamic>.from(userJson);
      if (map['profile_image'] == null && map['profileImage'] != null) {
        map['profile_image'] = map['profileImage'];
      }
      final p = UserProfileResponse.fromJson(map);
      _applyProfile(p);
      notifyListeners();
    } catch (_) {}
  }

  /// Logout - clears Firebase, API token, onboarding session, and all caches
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      await _authRepo.logout();
      await OnboardingRepository.clearSession();
      await OnboardingRepository.clearQuestionsCache();
      await OnboardingRepository.clearDomainsCache();
      await OnboardingRepository.clearWellnessCache();
      await OnboardingRepository.clearWeeklyProgressCache();
      await ExploreDomainsRepository.clearDomainsCache();
      _user = null;
      _profile = null;
      _errorMessage = null;
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
  }

  /// Delete account – DELETE users/me, then sign out locally.
  Future<bool> deleteAccount() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _authRepo.deleteAccount();
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      await OnboardingRepository.clearSession();
      await OnboardingRepository.clearQuestionsCache();
      await OnboardingRepository.clearDomainsCache();
      await OnboardingRepository.clearWellnessCache();
      await OnboardingRepository.clearWeeklyProgressCache();
      await ExploreDomainsRepository.clearDomainsCache();
      _user = null;
      _profile = null;
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
      return response.success;
    } catch (_) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
