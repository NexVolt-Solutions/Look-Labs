import 'package:flutter/material.dart';
import 'package:looklabs/Repository/onboarding_repository.dart';

class GaolScreenViewModel extends ChangeNotifier {
  List<String> _domains = [];
  bool _isLoading = false;
  String? _error;
  String? _selectedDomain;

  List<String> get domains => List.unmodifiable(_domains);
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Display labels for the grid (title-case of each domain).
  List<String> get buttonName {
    return _domains.map(_titleCase).toList();
  }

  static String _titleCase(String s) {
    if (s.isEmpty) return s;
    final parts = s.split(RegExp(r'\s+'));
    return parts
        .map((p) =>
            p.isEmpty ? p : p[0].toUpperCase() + p.substring(1).toLowerCase())
        .join(' ');
  }

  /// API domain value for the currently selected option, or null if none.
  String? get selectedDomain => _selectedDomain;

  /// Load domains from GET onboarding/domains. Call when the goal screen is shown.
  Future<void> loadDomains() async {
    if (_isLoading) return;
    _isLoading = true;
    _error = null;
    notifyListeners();

    final response = await OnboardingRepository.instance.getOnboardingDomains();

    _isLoading = false;
    if (response.success && response.data is List) {
      _domains = List<String>.from(response.data as List);
      _error = null;
    } else {
      _domains = [];
      _error = response.message ?? 'Failed to load goals.';
    }
    notifyListeners();
  }

  void selectIndex(int index) {
    if (index < 0 || index >= _domains.length) return;
    final domain = _domains[index];
    if (_selectedDomain == domain) {
      _selectedDomain = null;
    } else {
      _selectedDomain = domain;
    }
    notifyListeners();
  }

  /// Whether the option at [index] is selected.
  bool isSelected(int index) {
    if (index < 0 || index >= _domains.length) return false;
    return _selectedDomain == _domains[index];
  }
}
