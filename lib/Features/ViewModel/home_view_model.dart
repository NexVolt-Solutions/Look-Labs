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
  static const Set<String> _flowDomains = <String>{
    'skincare',
    'haircare',
    'workout',
    'fashion',
    'diet',
    'height',
    'quit_porn',
  };

  List<ExploreDomain> _domains = <ExploreDomain>[];
  bool _domainsLoading = false;
  String? _domainsError;
  String? _selectedDomain;
  String? _loadingDomainKey;

  WellnessMetrics? _wellness;
  bool _wellnessLoading = false;
  String? _wellnessError;

  WeeklyProgressResponse? _weeklyProgress;
  bool _weeklyProgressLoading = false;
  String? _weeklyProgressError;

  bool get _hasAuthToken => (ApiServices.authToken ?? '').trim().isNotEmpty;

  List<Map<String, dynamic>> get gridData => _gridData(this);
  List<Map<String, dynamic>> get homeOverViewData => _homeOverViewData(this);
  List<Map<String, dynamic>> get listViewData => _listViewData(this);

  bool get domainsLoading => _domainsLoading;
  String? get domainsError => _domainsError;
  bool get hasExploreDomains => _domains.isNotEmpty;
  bool get hasNoGoalSelected => (_selectedDomain ?? '').trim().isEmpty;

  WellnessMetrics? get wellness => _wellness;
  bool get wellnessLoading => _wellnessLoading;
  String? get wellnessError => _wellnessError;

  WeeklyProgressResponse? get weeklyProgress => _weeklyProgress;
  bool get weeklyProgressLoading => _weeklyProgressLoading;
  String? get weeklyProgressError => _weeklyProgressError;

  bool isLoadingDomain(String key) =>
      _loadingDomainKey == _normalizedDomainKey(key);

  String _normalizedDomainKey(String domain) {
    var d = domain.trim().toLowerCase();
    if (d == 'skin' || d == 'skin_care') return 'skincare';
    if (d == 'hair' || d == 'hair_care') return 'haircare';
    if (d == 'quitporn' || d == 'quit-porn') return 'quit_porn';
    return d;
  }

  bool isDomainEnabled(String domainKey) {
    final selected = _normalizedDomainKey(_selectedDomain ?? '');
    if (selected.isEmpty) return false;
    return selected == _normalizedDomainKey(domainKey);
  }

  void _notify() => notifyListeners();

  Future<void> loadDomainsForExplore() => _loadDomainsForExplore(this);

  Future<void> refreshDomainsForExplore() => _refreshDomainsForExplore(this);

  Future<void> loadWellness() => _loadWellness(this);

  Future<void> loadWeeklyProgress() => _loadWeeklyProgress(this);

  Future<void> onItemTap(int index, BuildContext context) =>
      _onItemTap(this, index, context);
}
