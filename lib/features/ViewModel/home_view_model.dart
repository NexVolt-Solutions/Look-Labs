import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:looklabs/Core/Network/api_error_handler.dart';
import 'package:looklabs/Core/Network/api_services.dart';
import 'package:looklabs/Core/Network/models/explore_domain.dart';
import 'package:looklabs/Core/Network/models/weekly_progress_response.dart';
import 'package:looklabs/Core/Network/models/wellness_metrics.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
import 'package:looklabs/Repository/auth_repository.dart';
import 'package:looklabs/Repository/domain_questions_repository.dart';
import 'package:looklabs/Repository/explore_domains_repository.dart';
import 'package:looklabs/Repository/onboarding_repository.dart';

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

  /// Load domains for Explore your plans: always GET domains/explore (requires auth).
  Future<void> loadDomainsForExplore() async {
    if (_domainsLoading) return;
    _domainsLoading = true;
    _domainsError = null;
    _selectedDomain = await AuthRepository.getSelectedDomain();
    notifyListeners();

    if (!_hasAuthToken) {
      _domains = [];
      _domainsLoading = false;
      _domainsError = null;
      notifyListeners();
      return;
    }

    final response = await ExploreDomainsRepository.instance
        .getExploreDomains();
    _domainsLoading = false;
    if (response.success && response.data is List) {
      _domains = (response.data as List).whereType<ExploreDomain>().toList();
      _domainsError = null;
    } else {
      _domains = [];
      _domainsError = response.userMessageOrFallback(
        'Could not load explore domains',
      );
    }
    _selectedDomain = await AuthRepository.getSelectedDomain();
    notifyListeners();
  }

  /// Refresh domains from API (e.g. retry or pull-to-refresh).
  Future<void> refreshDomainsForExplore() async {
    if (!_hasAuthToken) {
      _domains = [];
      _domainsError = null;
      notifyListeners();
      return;
    }
    _domainsError = null;
    notifyListeners();

    final response = await ExploreDomainsRepository.instance
        .getExploreDomains();
    if (response.success && response.data is List) {
      _domains = (response.data as List).whereType<ExploreDomain>().toList();
      _domainsError = null;
    } else {
      if (_domains.isEmpty) {
        _domainsError = response.userMessageOrFallback(
          'Could not load explore domains',
        );
      }
    }
    _selectedDomain = await AuthRepository.getSelectedDomain();
    notifyListeners();
  }

  static String _titleCase(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }

  /// Wellness overview cards (height, weight, sleep, water). API data only.
  List<Map<String, dynamic>> get homeOverViewData {
    final w = _wellness;
    if (w == null) return [];
    return [
      if (w.height.isNotEmpty || w.heightIconUrl != null)
        {
          'title': 'Your Height',
          'subTitle': w.height,
          'iconUrl': w.heightIconUrl,
        },
      if (w.weight.isNotEmpty || w.weightIconUrl != null)
        {
          'title': 'Your Weight',
          'subTitle': w.weight,
          'iconUrl': w.weightIconUrl,
        },
      if (w.sleepHours.isNotEmpty || w.sleepHoursIconUrl != null)
        {
          'title': 'Sleep Hours',
          'subTitle': w.sleepHours,
          'iconUrl': w.sleepHoursIconUrl,
        },
      if (w.waterIntake.isNotEmpty || w.waterIntakeIconUrl != null)
        {
          'title': 'Water Intake',
          'subTitle': w.waterIntake,
          'iconUrl': w.waterIntakeIconUrl,
        },
    ];
  }

  /// Load wellness: always GET onboarding/users/me/wellness.
  Future<void> loadWellness() async {
    if (_wellnessLoading) return;
    _wellnessLoading = true;
    _wellnessError = null;
    notifyListeners();

    if (!_hasAuthToken) {
      _wellness = null;
      _wellnessLoading = false;
      _wellnessError = null;
      notifyListeners();
      return;
    }

    if (kDebugMode) {
      final t = ApiServices.authToken;
      final masked = t != null && t.length > 14
          ? '${t.substring(0, 10)}...${t.substring(t.length - 4)}'
          : (t != null ? '[${t.length} chars]' : 'null');
      debugPrint('[Wellness] authToken: $masked');
    }

    final response = await OnboardingRepository.instance.getWellnessMetrics();
    _wellnessLoading = false;
    if (response.success && response.data is WellnessMetrics) {
      _wellness = response.data as WellnessMetrics;
      _wellnessError = null;
      if (kDebugMode) {
        debugPrint(
          '[Wellness] OK: height=${_wellness!.height}, weight=${_wellness!.weight}, sleep=${_wellness!.sleepHours}, water=${_wellness!.waterIntake}, quote=${_wellness!.dailyQuote.isNotEmpty}',
        );
      }
    } else {
      _wellnessError = response.userMessageOrFallback(
        'Could not load wellness',
      );
      if (kDebugMode) {
        debugPrint(
          '[Wellness] failed: statusCode=${response.statusCode}, message=${response.message}',
        );
      }
    }
    notifyListeners();
  }

  /// Load weekly progress: always GET users/me/progress/weekly.
  Future<void> loadWeeklyProgress() async {
    if (_weeklyProgressLoading) return;
    _weeklyProgressLoading = true;
    _weeklyProgressError = null;
    notifyListeners();

    if (!_hasAuthToken) {
      _weeklyProgress = null;
      _weeklyProgressLoading = false;
      _weeklyProgressError = null;
      notifyListeners();
      return;
    }

    final response = await OnboardingRepository.instance.getWeeklyProgress();
    _weeklyProgressLoading = false;
    if (response.success && response.data is WeeklyProgressResponse) {
      _weeklyProgress = response.data as WeeklyProgressResponse;
      _weeklyProgressError = null;
    } else {
      _weeklyProgressError = response.userMessageOrFallback(
        'Could not load weekly progress',
      );
    }
    notifyListeners();
  }

  /// Weekly progress section: domains or days from API only.
  List<Map<String, dynamic>> get listViewData {
    final wp = _weeklyProgress;
    if (wp != null && wp.domains.isNotEmpty) {
      return wp.domains.map((d) {
        return {
          'title': _titleCase(d.domain),
          'subTitle': '${d.score}',
          'iconUrl': d.iconUrl,
        };
      }).toList();
    }
    if (wp != null && wp.days.isNotEmpty) {
      return wp.days
          .map(
            (d) => {'title': d.day, 'subTitle': '${d.score}', 'iconUrl': null},
          )
          .toList();
    }
    return [];
  }

  /// Explore your plans grid: API data only.
  /// Each item: { title, subTitle, iconUrl, key }.
  List<Map<String, dynamic>> get gridData {
    if (_domains.isEmpty) return [];
    return _domains.map((d) {
      return {
        'title': d.name,
        'subTitle': d.subtitle,
        'iconUrl': d.iconUrl,
        'key': d.key,
      };
    }).toList();
  }

  /// Domains that have a flow API and result screen (check flow before questions).
  static const _flowDomains = {
    'workout',
    'height',
    'quit_porn',
    'skincare',
    'haircare',
  };

  /// Key of domain currently loading (shows overlay on that card only).
  String? _loadingDomainKey;
  String? get loadingDomainKey => _loadingDomainKey;
  bool isLoadingDomain(String key) =>
      _loadingDomainKey?.toLowerCase() == key.toLowerCase();

  bool _isCompletedFlowPayload(Map<String, dynamic> data) {
    final status = data['status']?.toString().toLowerCase().trim() ?? '';
    if (status == 'completed') return true;
    if (data['completed'] == true || data['is_completed'] == true) return true;

    // Heuristic: completed payloads usually contain result/AI sections.
    const resultKeys = {
      'ai_message',
      'ai_progress',
      'ai_recovery',
      'ai_attributes',
      'ai_exercises',
      'result',
      'recommendations',
    };
    for (final k in resultKeys) {
      if (data.containsKey(k) && data[k] != null) return true;
    }

    // Another common completion shape: no current/next question left.
    final current = data['current'];
    final next = data['next'];
    if (status == 'ok' && current == null && next == null) return true;

    return false;
  }

  /// From Home when flow is completed: always open review scans for hair/skin so users can
  /// capture new angles and re-run analysis for an updated routine.
  Future<void> _openCompletedScanDomainFromHome({
    required BuildContext context,
    required String domainKey,
    required Map<String, dynamic> flowPayload,
    required String reviewScansRoute,
  }) async {
    if (!context.mounted) return;
    Navigator.pushNamed(
      context,
      reviewScansRoute,
      arguments: flowPayload,
    );
  }

  Future<void> onItemTap(int index, BuildContext context) async {
    if (_domains.isEmpty || index < 0 || index >= _domains.length) return;
    final key = _normalizedDomainKey(_domains[index].key);
    if (!isDomainEnabled(key)) {
      final message = hasNoGoalSelected
          ? 'Please select your goal first to unlock plans.'
          : 'This plan is not your selected goal. Only your chosen goal is available to use.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          action: hasNoGoalSelected
              ? SnackBarAction(
                  label: 'Select goal',
                  onPressed: () {
                    Navigator.pushNamed(context, RoutesName.GaolScreen);
                  },
                )
              : null,
        ),
      );
      return;
    }

    final resultRoute = RoutesName.routeForDomain(key);
    final isFlowDomain = _flowDomains.contains(key) && resultRoute != null;

    if (_loadingDomainKey == key) return;

    _loadingDomainKey = key;
    notifyListeners();

    try {
      if (isFlowDomain) {
        final flowRes = await DomainQuestionsRepository.instance.getDomainFlow(
          key,
        );
        if (!context.mounted) return;
        if (flowRes.success && flowRes.data is Map) {
          final data = Map<String, dynamic>.from(flowRes.data as Map);
          final status = data['status']?.toString() ?? '';
          final isCompleted = _isCompletedFlowPayload(data);
          // Only navigate to result when the backend says the flow is completed.
          // status "ok" means there are questions to answer (current/next provided).
          if (isCompleted) {
            _loadingDomainKey = null;
            notifyListeners();
            await _openCompletedScanDomainFromHome(
              context: context,
              domainKey: key,
              flowPayload: data,
              reviewScansRoute: resultRoute,
            );
            return;
          }
          if (status == 'ok') {
            _loadingDomainKey = null;
            notifyListeners();
            Navigator.pushNamed(
              context,
              RoutesName.DomainQuestionScreen,
              arguments: key,
            );
            return;
          }
          if (status == 'processing') {
            _showFlowLoading(context);
            final completed = await DomainQuestionsRepository.instance
                .pollDomainFlowUntilCompleted(key, lastKnownResponse: data);
            if (context.mounted) Navigator.of(context).pop();
            if (!context.mounted) return;
            _loadingDomainKey = null;
            notifyListeners();
            if (completed != null) {
              await _openCompletedScanDomainFromHome(
                context: context,
                domainKey: key,
                flowPayload: Map<String, dynamic>.from(completed),
                reviewScansRoute: resultRoute,
              );
              return;
            }
            ApiErrorHandler.showSnackBar(
              context,
              fallback: 'Processing timed out. Please try again.',
            );
            return;
          }
        }
      }

      _loadingDomainKey = null;
      notifyListeners();
      Navigator.pushNamed(
        context,
        RoutesName.DomainQuestionScreen,
        arguments: key,
      );
    } catch (_) {
      _loadingDomainKey = null;
      notifyListeners();
    }
  }

  void _showFlowLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PopScope(
        canPop: false,
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Loading your plan...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(ctx).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
