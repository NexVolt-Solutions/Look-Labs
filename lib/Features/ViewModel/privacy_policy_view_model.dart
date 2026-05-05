import 'package:flutter/material.dart';
import 'package:looklabs/Core/Network/api_error_handler.dart';
import 'package:looklabs/Core/Network/models/privacy_policy_response.dart';
import 'package:looklabs/Repository/legal_repository.dart';

class PrivacyPolicyViewModel extends ChangeNotifier {
  PrivacyPolicyResponse? _policy;
  bool _loading = false;
  String? _error;

  PrivacyPolicyResponse? get policy => _policy;
  bool get loading => _loading;
  String? get error => _error;

  List<PrivacyPolicySection> get sections => _policy?.sections ?? const [];

  /// Load privacy policy from API. Call once when screen opens.
  Future<void> load() async {
    if (_loading) return;
    _loading = true;
    _error = null;
    notifyListeners();

    final response = await LegalRepository.instance.getPrivacyPolicy();
    _loading = false;
    if (response.success && response.data is PrivacyPolicyResponse) {
      _policy = response.data as PrivacyPolicyResponse;
      _error = null;
    } else {
      _error = response.userMessageOrFallback('Could not load privacy policy');
    }
    notifyListeners();
  }

  /// Retry after error.
  Future<void> retry() async {
    _error = null;
    notifyListeners();
    await load();
  }
}
