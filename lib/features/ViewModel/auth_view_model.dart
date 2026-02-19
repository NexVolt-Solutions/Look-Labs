import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:looklabs/Model/user_model.dart';
import 'package:looklabs/Repository/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepo = AuthRepository.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static void _log(String message, [Object? error, StackTrace? st]) {
    debugPrint('[AuthViewModel] $message');
    if (error != null) debugPrint('[AuthViewModel] error: $error');
    if (st != null) debugPrint('[AuthViewModel] stack: $st');
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

      _log('getting authentication');
      final GoogleSignInAuthentication auth = await googleUser.authentication;
      final idToken = auth.idToken;
      final accessToken = auth.accessToken;

      if (idToken == null) {
        _log('idToken is null');
        _errorMessage = 'Failed to get Google credentials';
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

      final firebaseUser = _firebaseAuth.currentUser;
      final token = await firebaseUser?.getIdToken();

      if (token != null) {
        _log('calling backend signInWithGoogle with Firebase token');
        final response = await _authRepo.signInWithGoogle(
          idToken: token,
          accessToken: accessToken,
        );
        _log('backend response: success=${response.success}, statusCode=${response.statusCode}');

        if (response.success && response.data != null) {
          _user = _parseUser(response.data);
          _errorMessage = null;
          _isLoading = false;
          notifyListeners();
          _log('signInWithGoogle completed successfully');
          return true;
        } else {
          _errorMessage = response.message ?? 'Sign in failed';
          _log('backend sign-in failed: $_errorMessage');
          _isLoading = false;
          notifyListeners();
          return false;
        }
      }

      _log('no Firebase token, trying backend with Google idToken');
      final response = await _authRepo.signInWithGoogle(
        idToken: idToken,
        accessToken: accessToken,
      );

      if (response.success && response.data != null) {
        _user = _parseUser(response.data);
        _errorMessage = null;
        _isLoading = false;
        notifyListeners();
        _log('signInWithGoogle completed successfully (with idToken)');
        return true;
      }

      _errorMessage = response.message ?? 'Sign in failed';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e, st) {
      _log('signInWithGoogle exception', e, st);
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
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
