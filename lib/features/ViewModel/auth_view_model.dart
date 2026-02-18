import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:looklabs/Model/user_model.dart';
import 'package:looklabs/Repository/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepo = AuthRepository.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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
        _errorMessage = 'Failed to get Google credentials';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final credential = GoogleAuthProvider.credential(
        idToken: idToken,
        accessToken: accessToken,
      );

      await _firebaseAuth.signInWithCredential(credential);

      final firebaseUser = _firebaseAuth.currentUser;
      final token = await firebaseUser?.getIdToken();

      if (token != null) {
        final response = await _authRepo.signInWithGoogle(
          idToken: token,
          accessToken: accessToken,
        );

        if (response.success && response.data != null) {
          _user = _parseUser(response.data);
          _errorMessage = null;
          _isLoading = false;
          notifyListeners();
          return true;
        } else {
          _errorMessage = response.message ?? 'Sign in failed';
          _isLoading = false;
          notifyListeners();
          return false;
        }
      }

      final response = await _authRepo.signInWithGoogle(
        idToken: idToken,
        accessToken: accessToken,
      );

      if (response.success && response.data != null) {
        _user = _parseUser(response.data);
        _errorMessage = null;
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _errorMessage = response.message ?? 'Sign in failed';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
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
