import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Repository/domain_questions_repository.dart';

class FashionProfileScreenViewModel extends ChangeNotifier {
  bool isExerciseSelected = false;
  bool isBestClothingSelected = false;
  bool _loading = false;

  bool get loading => _loading;
  String subtitle = 'AI analysis complete';
  String profileTitle = 'Your Style Profile';
  String weeklyTitle = 'Weekly Plan';
  String weeklySubtitle = 'Style themes to keep you sharp';
  Map<String, dynamic> dailyPlan = const {};
  List<Map<String, dynamic>> profileTraits = const [];
  List<Map<String, dynamic>> reviewScans = const [];
  List<String> stylesToAvoid = const [];
  List<String> bestClothingFits = const [];
  List<String> warmPalette = const [];

  Future<void> initializeFromResult(Map<String, dynamic>? resultData) async {
    _loading = true;
    notifyListeners();
    Map<String, dynamic>? payload;
    if (resultData != null && resultData.isNotEmpty) {
      payload = Map<String, dynamic>.from(resultData);
    } else {
      final flowRes = await DomainQuestionsRepository.instance.getDomainFlow(
        'fashion',
      );
      if (flowRes.success && flowRes.data is Map) {
        payload = Map<String, dynamic>.from(flowRes.data as Map);
      }
    }
    if (payload != null) {
      _applyPayload(payload);
    }
    _loading = false;
    notifyListeners();
  }

  void _applyPayload(Map<String, dynamic> payload) {
    final summaryRaw = payload['ai_summary'];
    final summary = summaryRaw is Map
        ? Map<String, dynamic>.from(summaryRaw)
        : <String, dynamic>{};
    final dailyRaw = payload['daily_plan'];
    dailyPlan = dailyRaw is Map
        ? Map<String, dynamic>.from(dailyRaw)
        : <String, dynamic>{};

    final title = (summary['title']?.toString() ?? '').trim();
    if (title.isNotEmpty) profileTitle = title;
    final sub = (summary['subtitle']?.toString() ?? '').trim();
    if (sub.isNotEmpty) subtitle = sub;
    final weeklyT = (dailyPlan['title']?.toString() ?? '').trim();
    if (weeklyT.isNotEmpty) weeklyTitle = weeklyT;
    final weeklyS = (dailyPlan['subtitle']?.toString() ?? '').trim();
    if (weeklyS.isNotEmpty) weeklySubtitle = weeklyS;

    profileTraits = _toMapList(summary['profile_traits']);
    reviewScans = _toMapList(summary['review_scans']);
    stylesToAvoid = _toStrings(summary['styles_to_avoid']);
    bestClothingFits = _toStrings(summary['best_clothing_fits']);
    warmPalette = _toStrings(summary['warm_palette']);
  }

  void selectExercise() {
    isExerciseSelected = true;
    notifyListeners();
  }

  void toggleBestClothingSelection() {
    isBestClothingSelected = !isBestClothingSelected;
    notifyListeners();
  }

  List<Map<String, dynamic>> facialData = [
    {
      'image': AppAssets.toothIcon,
      'title': 'Jawline',
      'subtitle': 'Narrow',
      'per': 78,
    },
    {
      'image': AppAssets.noseIcon,
      'title': 'Nose',
      'subtitle': 'Straight',
      'per': 78,
    },
    {
      'image': AppAssets.lipsIcon,
      'title': 'Lips',
      'subtitle': 'Medium',
      'per': 78,
    },
    {
      'image': AppAssets.boneIcon,
      'title': 'Cheek bones',
      'subtitle': 'High',
      'per': 78,
    },
    {
      'image': AppAssets.eyeIcon,
      'title': 'Eyes',
      'subtitle': 'Almond',
      'per': 78,
    },
    {
      'image': AppAssets.earIcon,
      'title': 'Ears',
      'subtitle': 'Proportional',
      'per': 78,
    },
    {
      'image': AppAssets.faceIcon,
      'title': 'Face Shape',
      'subtitle': 'Diamond Face Shape',
      'per': 78,
    },
  ];

  List<Map<String, dynamic>> _toMapList(dynamic raw) {
    if (raw is! List) return const <Map<String, dynamic>>[];
    return raw
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList(growable: false);
  }

  List<String> _toStrings(dynamic raw) {
    if (raw is! List) return const <String>[];
    return raw
        .map((e) => (e?.toString() ?? '').trim())
        .where((e) => e.isNotEmpty)
        .toList(growable: false);
  }
}
