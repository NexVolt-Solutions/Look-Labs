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

  /// Load domains for Explore your plans: from cache first, then GET domains/explore (requires auth).
  /// Restores selected domain from storage first so same-account re-login shows the correct plan as enabled.
  Future<void> loadDomainsForExplore() async {
    if (_domainsLoading) return;
    _domainsLoading = true;
    _domainsError = null;
    // Restore selected domain from storage immediately so UI is correct after re-login.
    _selectedDomain = await AuthRepository.getSelectedDomain();
    notifyListeners();

    final cached = await ExploreDomainsRepository.loadCachedDomains();
    if (cached != null && cached.isNotEmpty) {
      _domains = cached;
      _selectedDomain = await AuthRepository.getSelectedDomain();
      _domainsLoading = false;
      notifyListeners();
      _refreshDomainsInBackground();
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

  Future<void> _refreshDomainsInBackground() async {
    final response = await ExploreDomainsRepository.instance
        .getExploreDomains();
    if (response.success && response.data is List) {
      final fresh = (response.data as List).whereType<ExploreDomain>().toList();
      if (fresh.isEmpty) return;
      bool changed = _domains.length != fresh.length;
      if (!changed) {
        for (var i = 0; i < _domains.length && i < fresh.length; i++) {
          final a = _domains[i];
          final b = fresh[i];
          if (a.key != b.key || a.name != b.name || a.iconUrl != b.iconUrl) {
            changed = true;
            break;
          }
        }
      }
      final selected = await AuthRepository.getSelectedDomain();
      if (changed || _selectedDomain != selected) {
        _domains = fresh;
        _selectedDomain = selected;
        notifyListeners();
      }
    }
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

  /// Load wellness: cache-first, then background refresh to detect backend changes.
  Future<void> loadWellness() async {
    if (_wellnessLoading) return;
    _wellnessLoading = true;
    _wellnessError = null;
    notifyListeners();

    final cached = await OnboardingRepository.loadCachedWellness();
    if (cached != null) {
      final cachedHasData =
          cached.height.isNotEmpty ||
          cached.weight.isNotEmpty ||
          cached.sleepHours.isNotEmpty ||
          cached.waterIntake.isNotEmpty;
      if (cachedHasData) {
        _wellness = cached;
        _wellnessLoading = false;
        notifyListeners();
        _refreshWellnessInBackground();
        return;
      }
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

  Future<void> _refreshWellnessInBackground() async {
    final response = await OnboardingRepository.instance.getWellnessMetrics();
    if (response.success && response.data is WellnessMetrics) {
      final fresh = response.data as WellnessMetrics;
      final freshHasData =
          fresh.height.isNotEmpty ||
          fresh.weight.isNotEmpty ||
          fresh.sleepHours.isNotEmpty ||
          fresh.waterIntake.isNotEmpty;
      if (!freshHasData && _wellness != null) {
        return;
      }
      final changed =
          _wellness == null ||
          _wellness!.height != fresh.height ||
          _wellness!.weight != fresh.weight ||
          _wellness!.sleepHours != fresh.sleepHours ||
          _wellness!.waterIntake != fresh.waterIntake ||
          _wellness!.dailyQuote != fresh.dailyQuote;
      if (changed) {
        _wellness = fresh;
        notifyListeners();
      }
    }
  }

  /// Load weekly progress: cache-first, then background refresh to detect backend changes.
  Future<void> loadWeeklyProgress() async {
    if (_weeklyProgressLoading) return;
    _weeklyProgressLoading = true;
    _weeklyProgressError = null;
    notifyListeners();

    final cached = await OnboardingRepository.loadCachedWeeklyProgress();
    if (cached != null) {
      _weeklyProgress = cached;
      _weeklyProgressLoading = false;
      notifyListeners();
      _refreshWeeklyProgressInBackground();
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

  Future<void> _refreshWeeklyProgressInBackground() async {
    final response = await OnboardingRepository.instance.getWeeklyProgress();
    if (response.success && response.data is WeeklyProgressResponse) {
      final fresh = response.data as WeeklyProgressResponse;
      final changed =
          _weeklyProgress == null ||
          _weeklyProgress!.domains.length != fresh.domains.length ||
          _weeklyProgress!.days.length != fresh.days.length ||
          (_weeklyProgress!.weekAverage ?? 0) != (fresh.weekAverage ?? 0);
      if (changed) {
        _weeklyProgress = fresh;
        notifyListeners();
      }
    }
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
  static const _flowDomains = {'workout', 'height'};

  /// Key of domain currently loading (shows overlay on that card only).
  String? _loadingDomainKey;
  String? get loadingDomainKey => _loadingDomainKey;
  bool isLoadingDomain(String key) =>
      _loadingDomainKey?.toLowerCase() == key.toLowerCase();

  /// Navigate to domain questions or result screen. For flow domains (workout, height),
  /// checks GET domains/{domain}/flow first: if completed → go to result; else → questions.
  Future<void> onItemTap(int index, BuildContext context) async {
    if (_domains.isEmpty || index < 0 || index >= _domains.length) return;
    final key = _domains[index].key.toLowerCase().trim();
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

    _loadingDomainKey = key;
    notifyListeners();

    try {
      if (isFlowDomain) {
        final flowRes = await DomainQuestionsRepository.instance
            .getDomainFlow(key);
        if (!context.mounted) return;
        if (flowRes.success && flowRes.data is Map) {
          final data = Map<String, dynamic>.from(flowRes.data as Map);
          final status = data['status']?.toString() ?? '';
          if (status == 'completed' || status == 'ok') {
            _loadingDomainKey = null;
            notifyListeners();
            Navigator.pushNamed(context, resultRoute, arguments: data);
            return;
          }
          if (status == 'processing') {
            _showFlowLoading(context);
            final completed = await DomainQuestionsRepository.instance
                .pollDomainFlowUntilCompleted(key);
            if (context.mounted) Navigator.of(context).pop();
            if (!context.mounted) return;
            _loadingDomainKey = null;
            notifyListeners();
            if (completed != null) {
              Navigator.pushNamed(context, resultRoute, arguments: completed);
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
