import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Network/api_services.dart';
import 'package:looklabs/Core/Network/models/weekly_progress_response.dart';
import 'package:looklabs/Core/Network/models/wellness_metrics.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
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

  List<String> _domains = [];
  bool _domainsLoading = false;

  bool get domainsLoading => _domainsLoading;

  /// Load domains for Explore your plans: from secure storage first (API only once), else GET onboarding/domains then cache.
  Future<void> loadDomainsForExplore() async {
    if (_domainsLoading) return;
    _domainsLoading = true;
    notifyListeners();

    final cached = await OnboardingRepository.loadCachedDomains();
    if (cached != null && cached.isNotEmpty) {
      _domains = cached;
      _domainsLoading = false;
      notifyListeners();
      return;
    }

    final response = await OnboardingRepository.instance.getOnboardingDomains();
    if (response.success && response.data is List) {
      _domains = List<String>.from(response.data as List);
    } else {
      _domains = [];
    }
    _domainsLoading = false;
    notifyListeners();
  }

  /// Domain key (e.g. skincare) -> grid entry and route for Explore your plans.
  static Map<String, Map<String, dynamic>> get _domainConfig {
    return {
      'skincare': {'title': 'SkinCare', 'subTitle': 'Daily glow routine', 'image': AppAssets.skinCare, 'route': RoutesName.SkinCareScreen},
      'hair': {'title': 'Hair', 'subTitle': 'Daily glow routine', 'image': AppAssets.hair, 'route': RoutesName.HairCareScreen},
      'workout': {'title': 'WorkOut', 'subTitle': 'Daily glow routine', 'image': AppAssets.workOut, 'route': RoutesName.WorkOutScreen},
      'diet': {'title': 'Diet', 'subTitle': 'Daily glow routine', 'image': AppAssets.diet, 'route': RoutesName.DietScreen},
      'facial': {'title': 'Facial', 'subTitle': 'Daily glow routine', 'image': AppAssets.facial, 'route': RoutesName.FacialScreen},
      'fashion': {'title': 'Fashion', 'subTitle': 'Daily glow routine', 'image': AppAssets.fashion, 'route': RoutesName.FashionScreen},
      'height': {'title': 'Height', 'subTitle': 'Daily glow routine', 'image': AppAssets.height, 'route': RoutesName.HeightScreen},
      'quit porn': {'title': 'QuitPorn', 'subTitle': 'Daily glow routine', 'image': AppAssets.quitPorn, 'route': RoutesName.QuitPornScreen},
      'quitporn': {'title': 'QuitPorn', 'subTitle': 'Daily glow routine', 'image': AppAssets.quitPorn, 'route': RoutesName.QuitPornScreen},
    };
  }

  static String _titleCase(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }

  /// Wellness overview cards (height, weight, sleep, water). Uses API data when available.
  List<Map<String, dynamic>> get homeOverViewData {
    final w = _wellness;
    return [
      {
        'title': 'Your Height',
        'subTitle': w?.height.isNotEmpty == true ? w!.height : '—',
        'image': AppAssets.heightIcon,
      },
      {
        'title': 'Your Weight',
        'subTitle': w?.weight.isNotEmpty == true ? w!.weight : '—',
        'image': AppAssets.weightIcon,
      },
      {
        'title': 'Sleep Hours',
        'subTitle': w?.sleepHours.isNotEmpty == true ? w!.sleepHours : '—',
        'image': AppAssets.sleepIcon,
      },
      {
        'title': 'Water Intake',
        'subTitle': w?.waterIntake.isNotEmpty == true ? w!.waterIntake : '—',
        'image': AppAssets.waterIcon,
      },
    ];
  }

  /// Load wellness from GET onboarding/users/me/wellness. No-op if already loading or already have data.
  Future<void> loadWellness() async {
    if (_wellnessLoading || _wellness != null) return;
    _wellnessLoading = true;
    _wellnessError = null;
    notifyListeners();

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
      _wellnessError = response.message ?? 'Could not load wellness';
      if (kDebugMode) {
        debugPrint(
          '[Wellness] failed: statusCode=${response.statusCode}, message=${response.message}',
        );
      }
    }
    notifyListeners();
  }

  /// Load weekly progress from GET users/me/progress/weekly. No-op if already loading or already have data.
  Future<void> loadWeeklyProgress() async {
    if (_weeklyProgressLoading || _weeklyProgress != null) return;
    _weeklyProgressLoading = true;
    _weeklyProgressError = null;
    notifyListeners();

    final response = await OnboardingRepository.instance.getWeeklyProgress();
    _weeklyProgressLoading = false;
    if (response.success && response.data is WeeklyProgressResponse) {
      _weeklyProgress = response.data as WeeklyProgressResponse;
      _weeklyProgressError = null;
    } else {
      _weeklyProgressError =
          response.message ?? 'Could not load weekly progress';
    }
    notifyListeners();
  }

  /// Weekly progress section: 7 days (Mon–Sun) from API when available, else fallback list with placeholder.
  List<Map<String, dynamic>> get listViewData {
    final wp = _weeklyProgress;
    if (wp != null && wp.days.isNotEmpty) {
      return wp.days
          .map(
            (d) => {
              'title': d.day,
              'subTitle': '${d.score}',
              'image': AppAssets.skinCare,
            },
          )
          .toList();
    }
    return _listViewDataFallback;
  }

  static final List<Map<String, dynamic>> _listViewDataFallback = [
    {'title': 'Skin', 'subTitle': '34/100', 'image': AppAssets.skinCare},
    {'title': 'Hair', 'subTitle': '34/100', 'image': AppAssets.hair},
    {'title': 'Height', 'subTitle': '34/100', 'image': AppAssets.height},
    {'title': 'Diet', 'subTitle': '34/100', 'image': AppAssets.diet},
    {'title': 'facial', 'subTitle': '34/100', 'image': AppAssets.facial},
    {'title': 'Fashion', 'subTitle': '34/100', 'image': AppAssets.fashion},
    {'title': 'QuitPorn', 'subTitle': '34/100', 'image': AppAssets.quitPorn},
    {'title': 'WorkOut', 'subTitle': '34/100', 'image': AppAssets.workOut},
  ];

  static final List<Map<String, dynamic>> _gridDataFallback = [
    {'title': 'SkinCare', 'subTitle': 'Daily glow routine', 'image': AppAssets.skinCare},
    {'title': 'Hair', 'subTitle': 'Daily glow routine', 'image': AppAssets.hair},
    {'title': 'WorkOut', 'subTitle': 'Daily glow routine', 'image': AppAssets.workOut},
    {'title': 'Diet', 'subTitle': 'Daily glow routine', 'image': AppAssets.diet},
    {'title': 'Facial', 'subTitle': 'Daily glow routine', 'image': AppAssets.facial},
    {'title': 'Fashion', 'subTitle': 'Daily glow routine', 'image': AppAssets.fashion},
    {'title': 'Height', 'subTitle': 'Daily glow routine', 'image': AppAssets.height},
    {'title': 'QuitPorn', 'subTitle': 'Daily glow routine', 'image': AppAssets.quitPorn},
  ];

  /// Explore your plans grid: from cached/API domains when available, else fallback list.
  List<Map<String, dynamic>> get gridData {
    if (_domains.isEmpty) return _gridDataFallback;
    final config = _domainConfig;
    return _domains.map((d) {
      final key = d.toLowerCase().trim();
      final entry = config[key];
      if (entry != null) {
        return {'title': entry['title'], 'subTitle': entry['subTitle']!, 'image': entry['image']};
      }
      return {'title': _titleCase(d), 'subTitle': 'Daily glow routine', 'image': AppAssets.skinCare};
    }).toList();
  }

  void onItemTap(int index, BuildContext context) {
    if (_domains.isNotEmpty && index >= 0 && index < _domains.length) {
      final key = _domains[index].toLowerCase().trim();
      final route = _domainConfig[key]?['route'] as String?;
      if (route != null && route.isNotEmpty) {
        Navigator.pushNamed(context, route);
        return;
      }
    }
    if (index == 0) {
      Navigator.pushNamed(context, RoutesName.SkinCareScreen);
    } else if (index == 1) {
      Navigator.pushNamed(context, RoutesName.HairCareScreen);
    } else if (index == 2) {
      Navigator.pushNamed(context, RoutesName.WorkOutScreen);
    } else if (index == 3) {
      Navigator.pushNamed(context, RoutesName.DietScreen);
    } else if (index == 4) {
      Navigator.pushNamed(context, RoutesName.FacialScreen);
    } else if (index == 5) {
      Navigator.pushNamed(context, RoutesName.FashionScreen);
    } else if (index == 6) {
      Navigator.pushNamed(context, RoutesName.HeightScreen);
    } else if (index == 7) {
      Navigator.pushNamed(context, RoutesName.QuitPornScreen);
    }
  }
}
