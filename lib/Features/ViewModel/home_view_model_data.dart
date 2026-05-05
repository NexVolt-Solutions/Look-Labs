part of 'home_view_model.dart';

String _titleCase(String s) {
  if (s.isEmpty) return s;
  return s[0].toUpperCase() + s.substring(1).toLowerCase();
}

Future<void> _loadDomainsForExplore(HomeViewModel vm) async {
  if (vm._domainsLoading) return;
  vm._domainsLoading = true;
  vm._domainsError = null;
  vm._selectedDomain = await AuthRepository.getSelectedDomain();
  vm._notify();

  if (!vm._hasAuthToken) {
    vm._domains = [];
    vm._domainsLoading = false;
    vm._domainsError = null;
    vm._notify();
    return;
  }

  final response = await ExploreDomainsRepository.instance.getExploreDomains();
  vm._domainsLoading = false;
  if (response.success && response.data is List) {
    vm._domains = (response.data as List).whereType<ExploreDomain>().toList();
    vm._domainsError = null;
  } else {
    vm._domains = [];
    vm._domainsError = response.userMessageOrFallback(
      'Could not load explore domains',
    );
  }
  vm._selectedDomain = await AuthRepository.getSelectedDomain();
  vm._notify();
}

Future<void> _refreshDomainsForExplore(HomeViewModel vm) async {
  if (!vm._hasAuthToken) {
    vm._domains = [];
    vm._domainsError = null;
    vm._notify();
    return;
  }
  vm._domainsError = null;
  vm._notify();

  final response = await ExploreDomainsRepository.instance.getExploreDomains();
  if (response.success && response.data is List) {
    vm._domains = (response.data as List).whereType<ExploreDomain>().toList();
    vm._domainsError = null;
  } else if (vm._domains.isEmpty) {
    vm._domainsError = response.userMessageOrFallback(
      'Could not load explore domains',
    );
  }
  vm._selectedDomain = await AuthRepository.getSelectedDomain();
  vm._notify();
}

List<Map<String, dynamic>> _homeOverViewData(HomeViewModel vm) {
  final w = vm._wellness;
  if (w == null) return [];
  return [
    if (w.height.isNotEmpty || w.heightIconUrl != null)
      {'title': 'Your Height', 'subTitle': w.height, 'iconUrl': w.heightIconUrl},
    if (w.weight.isNotEmpty || w.weightIconUrl != null)
      {'title': 'Your Weight', 'subTitle': w.weight, 'iconUrl': w.weightIconUrl},
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

Future<void> _loadWellness(HomeViewModel vm) async {
  if (vm._wellnessLoading) return;
  vm._wellnessLoading = true;
  vm._wellnessError = null;
  vm._notify();

  if (!vm._hasAuthToken) {
    vm._wellness = null;
    vm._wellnessLoading = false;
    vm._wellnessError = null;
    vm._notify();
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
  vm._wellnessLoading = false;
  if (response.success && response.data is WellnessMetrics) {
    vm._wellness = response.data as WellnessMetrics;
    vm._wellnessError = null;
    if (kDebugMode) {
      debugPrint(
        '[Wellness] OK: height=${vm._wellness!.height}, weight=${vm._wellness!.weight}, sleep=${vm._wellness!.sleepHours}, water=${vm._wellness!.waterIntake}, quote=${vm._wellness!.dailyQuote.isNotEmpty}',
      );
    }
  } else {
    vm._wellnessError = response.userMessageOrFallback('Could not load wellness');
    if (kDebugMode) {
      debugPrint(
        '[Wellness] failed: statusCode=${response.statusCode}, message=${response.message}',
      );
    }
  }
  vm._notify();
}

Future<void> _loadWeeklyProgress(HomeViewModel vm) async {
  if (vm._weeklyProgressLoading) return;
  vm._weeklyProgressLoading = true;
  vm._weeklyProgressError = null;
  vm._notify();

  if (!vm._hasAuthToken) {
    vm._weeklyProgress = null;
    vm._weeklyProgressLoading = false;
    vm._weeklyProgressError = null;
    vm._notify();
    return;
  }

  final response = await OnboardingRepository.instance.getWeeklyProgress();
  vm._weeklyProgressLoading = false;
  if (response.success && response.data is WeeklyProgressResponse) {
    vm._weeklyProgress = response.data as WeeklyProgressResponse;
    vm._weeklyProgressError = null;
  } else {
    vm._weeklyProgressError = response.userMessageOrFallback(
      'Could not load weekly progress',
    );
  }
  vm._notify();
}

List<Map<String, dynamic>> _listViewData(HomeViewModel vm) {
  final wp = vm._weeklyProgress;
  if (wp != null && wp.domains.isNotEmpty) {
    return wp.domains
        .map(
          (d) => {
            'title': _titleCase(d.domain),
            'subTitle': '${d.score}',
            'iconUrl': d.iconUrl,
          },
        )
        .toList();
  }
  if (wp != null && wp.days.isNotEmpty) {
    return wp.days
        .map((d) => {'title': d.day, 'subTitle': '${d.score}', 'iconUrl': null})
        .toList();
  }
  return [];
}

List<Map<String, dynamic>> _gridData(HomeViewModel vm) {
  if (vm._domains.isEmpty) return [];
  return vm._domains
      .map(
        (d) => {
          'title': d.name,
          'subTitle': d.subtitle,
          'iconUrl': d.iconUrl,
          'key': d.key,
        },
      )
      .toList();
}
