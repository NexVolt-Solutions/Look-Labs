import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/Network/api_error_handler.dart';
import 'package:looklabs/Core/Network/api_services.dart';
import 'package:looklabs/Core/Network/models/explore_domain.dart';
import 'package:looklabs/Core/Network/models/weekly_progress_response.dart';
import 'package:looklabs/Core/Network/models/wellness_metrics.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';
import 'package:looklabs/Repository/auth_repository.dart';
import 'package:looklabs/Repository/domain_questions_repository.dart';
import 'package:looklabs/Repository/explore_domains_repository.dart';
import 'package:looklabs/Repository/onboarding_repository.dart';

part 'home_view_model_data.dart';
part 'home_view_model_flow.dart';
part 'home_view_model_flow_dialogs.dart';

class HomeViewModel extends ChangeNotifier {
  String _normalizedDomainKey(String key) {
    final d = key.trim().toLowerCase();
    switch (d) {
      case 'skin':
        return 'skincare';
      case 'skin_care':
        return 'skincare';
      case 'hair':
        return 'haircare';
      case 'hair_care':
        return 'haircare';
      default:
        return d;
    }
  }

  bool get _hasAuthToken {
    final t = ApiServices.authToken;
    return t != null && t.trim().isNotEmpty;
  }

  WellnessMetrics? _wellness;
  bool _wellnessLoading = false;
  String? _wellnessError;

  WellnessMetrics? get wellness => _wellness;
  bool get wellnessLoading => _wellnessLoading;
  String? get wellnessError => _wellnessError;

  WeeklyProgressResponse? _weeklyProgress;
  bool _weeklyProgressLoading = false;
  String? _weeklyProgressError;

  WeeklyProgressResponse? get weeklyProgress => _weeklyProgress;
  bool get weeklyProgressLoading => _weeklyProgressLoading;
  String? get weeklyProgressError => _weeklyProgressError;

  List<ExploreDomain> _domains = [];
  bool _domainsLoading = false;
  String? _domainsError;
  String? _selectedDomain;

  bool get domainsLoading => _domainsLoading;
  String? get domainsError => _domainsError;
  bool get hasExploreDomains => _domains.isNotEmpty;

  /// User's goal/domain from onboarding (goal screen or link response). Only this domain is tappable on Home.
  String? get selectedDomain => _selectedDomain;

  /// True if this domain key is enabled (tappable). When no goal is stored, none are enabled (all show Pro badge); otherwise only the selected goal is enabled.
  bool isDomainEnabled(String key) {
    if (_selectedDomain == null || _selectedDomain!.isEmpty) return false;
    return key.trim().toLowerCase() == _selectedDomain!.trim().toLowerCase();
  }

  /// True when user has not selected a goal yet (all plans show Pro badge; tap prompts to select goal).
  bool get hasNoGoalSelected =>
      _selectedDomain == null || _selectedDomain!.isEmpty;
  Future<void> loadDomainsForExplore() => _loadDomainsForExplore(this);
  Future<void> refreshDomainsForExplore() => _refreshDomainsForExplore(this);
  List<Map<String, dynamic>> get homeOverViewData => _homeOverViewData(this);
  Future<void> loadWellness() => _loadWellness(this);
  Future<void> loadWeeklyProgress() => _loadWeeklyProgress(this);
  List<Map<String, dynamic>> get listViewData => _listViewData(this);
  List<Map<String, dynamic>> get gridData => _gridData(this);

  /// Domains that have a flow API and result screen (check flow before questions).
  static const _flowDomains = {
    'workout',
    'diet',
    'height',
    'quit_porn',
    'skincare',
    'haircare',
    'fashion',
  };

  String? _loadingDomainKey;
  String? get loadingDomainKey => _loadingDomainKey;
  bool isLoadingDomain(String key) =>
      _loadingDomainKey?.toLowerCase() == key.toLowerCase();

  void _notify() => notifyListeners();

  Future<void> onItemTap(int index, BuildContext context) =>
      _onItemTap(this, index, context);
}
