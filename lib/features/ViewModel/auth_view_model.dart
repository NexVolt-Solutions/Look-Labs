import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:looklabs/Core/Config/env_loader.dart';
import 'package:looklabs/Model/user_model.dart';
import 'package:looklabs/Repository/auth_repository.dart';
import 'package:looklabs/Repository/onboarding_repository.dart';

const String? _kWebClientIdOverride = null;

String? get _googleWebClientId =>
    _kWebClientIdOverride ?? env('GOOGLE_WEB_CLIENT_ID');

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepo = AuthRepository.instance;
  late final GoogleSignIn _googleSignIn = () {
    final serverClientId = _googleWebClientId;
    if (kDebugMode) {
      if (serverClientId != null) {
        debugPrint(
          '[AuthViewModel] GoogleSignIn with serverClientId (required on Android for idToken)',
        );
      } else {
        debugPrint(
          '[AuthViewModel] GoogleSignIn without serverClientId - idToken may be null on Android. Add GOOGLE_WEB_CLIENT_ID to api.env',
        );
      }
    }
    return GoogleSignIn(
      scopes: ['email', 'profile'],
      serverClientId: serverClientId,
    );
  }();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static void _log(String message, [Object? error, StackTrace? st]) {
    debugPrint('[AuthViewModel] $message');
    if (error != null) debugPrint('[AuthViewModel] error: $error');
    if (st != null) debugPrint('[AuthViewModel] stack: $st');
  }

  /// In debug, log id_token aud/iss so backend can be configured to accept this client ID.
  static void _logGoogleTokenAudience(String idToken) {
    try {
      final parts = idToken.split('.');
      if (parts.length != 3) return;
      String payloadB64 = parts[1];
      payloadB64 += ('=' * ((4 - payloadB64.length % 4) % 4));
      final payload = utf8.decode(base64Url.decode(payloadB64));
      final map = jsonDecode(payload) as Map<String, dynamic>?;
      if (map != null) {
        final aud = map['aud'];
        final iss = map['iss'];
        final exp = map['exp'];
        debugPrint(
          '[AuthViewModel] Google id_token payload: aud=$aud iss=$iss exp=$exp',
        );
        debugPrint(
          '[AuthViewModel] Backend must verify token with this client ID (aud): $aud',
        );
      }
    } catch (_) {}
  }

  bool _isLoading = false;
  String? _errorMessage;
  UserModel? _user;
  bool _isSelected = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserModel? get user => _user;
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
    _log('signInWithGoogle started');

    try {
      _log('calling _googleSignIn.signIn() - account picker should appear');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _log('user cancelled or picker dismissed without selection');
        _isLoading = false;
        notifyListeners();
        return false;
      }
      _log('user selected: ${googleUser.email}');

      _log('getting authentication (googleUser.authentication)');
      final GoogleSignInAuthentication auth = await googleUser.authentication;
      final idToken = auth.idToken;
      final accessToken = auth.accessToken;

      _log(
        'auth result: idToken=${idToken != null ? "present (${idToken.length} chars)" : "NULL"}, accessToken=${accessToken != null ? "present" : "null"}',
      );
      if (idToken == null) {
        _log(
          'idToken is null - on Android add GOOGLE_WEB_CLIENT_ID (Web client ID) to api.env and rebuild',
        );
        _errorMessage =
            'Failed to get Google credentials. On Android, add Web client ID to api.env (see README).';
        _isLoading = false;
        notifyListeners();
        return false;
      }
      _log('got idToken, signing in to Firebase');

      final credential = GoogleAuthProvider.credential(
        idToken: idToken,
        accessToken: accessToken,
      );

      await _firebaseAuth.signInWithCredential(credential);
      _log('Firebase signInWithCredential success');

      // Backend expects Google id_token (not Firebase token). Firebase token has different aud and fails backend validation.
      if (kDebugMode) _logGoogleTokenAudience(idToken);
      _log('calling backend with Google id_token');
      final response = await _authRepo.signInWithGoogle(
        idToken: idToken,
        accessToken: accessToken,
      );
      _log(
        'backend response: success=${response.success}, statusCode=${response.statusCode}, message=${response.message}',
      );

      if (response.success && response.data != null) {
        _user = _parseUser(response.data);
        await OnboardingRepository.clearSession();
        _errorMessage = null;
        _isLoading = false;
        notifyListeners();
        _log('signInWithGoogle completed successfully');
        return true;
      }

      _errorMessage = response.message ?? 'Sign in failed';
      _log('backend sign-in failed: $_errorMessage');
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e, st) {
      _log('signInWithGoogle exception', e, st);
      final msg = e.toString();
      if (msg.contains('ApiException: 10') || msg.contains('sign_in_failed')) {
        _errorMessage =
            'Google Sign-In config error. Use a Web application client ID (not Android) in api.env as GOOGLE_WEB_CLIENT_ID. Create one in Google Cloud Console → Credentials → OAuth client ID → Web application.';
      } else {
        _errorMessage = msg.replaceFirst('Exception: ', '');
      }
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

  /// Fetch user profile from API
  Future<void> fetchProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _authRepo.getProfile();
      if (response.success && response.data != null) {
        _user = _parseUser(response.data);
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
      _errorMessage = null;
    } catch (_) {}
    _isLoading = false;
    notifyListeners();
  }
}
