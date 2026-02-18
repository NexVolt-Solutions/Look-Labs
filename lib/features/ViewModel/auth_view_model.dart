import 'package:flutter/material.dart';
import 'package:looklabs/Repository/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final bool isSelected = false;
  AuthRepository get _authRepo => AuthRepository.instance;

  Future<void> signInWithGoogle({
    required String idToken,
    String? accessToken,
  }) async {
    final response = await _authRepo.signInWithGoogle(
      idToken: idToken,
      accessToken: accessToken,
    );
    notifyListeners();
  }
}
