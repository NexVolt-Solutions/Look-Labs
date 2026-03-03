import 'package:flutter/material.dart';
import 'package:looklabs/Core/Network/models/privacy_policy_response.dart';
import 'package:looklabs/Repository/legal_repository.dart';

class TermsOfServiceViewModel extends ChangeNotifier {
  PrivacyPolicyResponse? _terms;
  bool _loading = false;
  String? _error;

  PrivacyPolicyResponse? get terms => _terms;
  bool get loading => _loading;
  String? get error => _error;

  List<PrivacyPolicySection> get sections => _terms?.sections ?? const [];

  /// Load terms of service from API. Call once when screen opens.
  Future<void> load() async {
    if (_loading) return;
    _loading = true;
    _error = null;
    notifyListeners();

    final response = await LegalRepository.instance.getTermsOfService();
    _loading = false;
    if (response.success && response.data is PrivacyPolicyResponse) {
      _terms = response.data as PrivacyPolicyResponse;
      _error = null;
    } else {
      _error = response.message ?? 'Could not load terms of service';
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
