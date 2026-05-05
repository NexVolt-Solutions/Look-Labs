import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Repository/diet_repository.dart';
import 'package:looklabs/Repository/domain_questions_repository.dart';

class DietResultScreenViewModel extends ChangeNotifier {
  int selectedIndex = -1; // ✔ tick state
  int expandedIndex = -1; // ⬇️ dropdown state
  bool _initialized = false;
  Map<String, dynamic> _resultData = const {};
  List<Map<String, dynamic>> _gridData = [];
  List<Map<String, dynamic>> _focusData = [];
  String _insightTitle = '';
  String _insightText = '';
  String _todayMealsTitle = '';
  String _todayMealsSubTitle = '';
  String _subtitle = '';
  bool _loading = false;
  List<String> _badgeIcons = [];
  String _flowDomain = 'diet';

  bool get loading => _loading;
  String get subtitle => _subtitle;
  List<String> get badgeIcons => _badgeIcons;

  Future<void> initializeFromResult(Map<String, dynamic>? resultData) async {
    if (_initialized) return;
    _initialized = true;
    _loading = true;
    notifyListeners();
    await DietRepository.instance.ensureFlowCacheLoaded();

    final incoming = Map<String, dynamic>.from(resultData ?? const {});
    if (incoming.isNotEmpty) {
      _flowDomain = _detectDomain(incoming);
      _resultData = incoming;
      DietRepository.instance.setFlowCache(incoming);
    } else {
      final cached = DietRepository.instance.cachedFlowPayload;
      if (cached != null && cached.isNotEmpty) {
        _flowDomain = _detectDomain(cached);
        _resultData = cached;
      }
    }

    final status = _str(_resultData['status']).toLowerCase();
    final hasIncomingCompleted = incoming.isNotEmpty && status == 'completed';
    final shouldFetchFlow =
        _resultData.isEmpty ||
        status == 'processing' ||
        status == 'pending' ||
        status == 'in_progress' ||
        (!hasIncomingCompleted && !DietRepository.instance.hasFreshFlowCache());

    if (shouldFetchFlow) {
      final flowRes = await DomainQuestionsRepository.instance.getDomainFlow(
        _flowDomain,
      );
      if (flowRes.success && flowRes.data is Map) {
        final map = Map<String, dynamic>.from(flowRes.data as Map);
        final s = _str(map['status']).toLowerCase();
        if (s == 'completed') {
          _resultData = map;
          DietRepository.instance.setFlowCache(_resultData);
        } else if (s == 'processing' || s == 'pending' || s == 'in_progress') {
          final completed = await DomainQuestionsRepository.instance
              .pollDomainFlowUntilCompleted(
                _flowDomain,
                lastKnownResponse: map,
              );
          if (completed != null) {
            _resultData = Map<String, dynamic>.from(completed);
            DietRepository.instance.setFlowCache(_resultData);
          }
        }
      }
    }
    _buildFromApi();
    _loading = false;
    notifyListeners();
  }

  String _str(dynamic v) => (v?.toString() ?? '').trim();

  void _buildFromApi() {
    final dailyPlanRaw = _resultData['daily_plan'];
    final dailyPlan = dailyPlanRaw is Map
        ? Map<String, dynamic>.from(dailyPlanRaw)
        : <String, dynamic>{};
    final aiSummaryRaw = _resultData['ai_summary'];
    final aiSummary = aiSummaryRaw is Map
        ? Map<String, dynamic>.from(aiSummaryRaw)
        : <String, dynamic>{};
    _subtitle = _str(aiSummary['subtitle']);
    if (_subtitle.isEmpty) _subtitle = _str(aiSummary['title']);
    if (_subtitle.isEmpty) _subtitle = _str(dailyPlan['subtitle']);

    _gridData = [];
    final cardsRaw = aiSummary['cards'];
    if (cardsRaw is List) {
      for (final row in cardsRaw) {
        if (row is! Map) continue;
        final m = Map<String, dynamic>.from(row);
        final title = _str(m['title']);
        if (title.isEmpty) continue;
        _gridData.add({
          'title': title,
          'subtitle': '${_str(m['value'])} ${_str(m['unit'])}'.trim(),
          'image': AppAssets.fatLossIcon,
          'icon_url': _str(m['icon_url']),
        });
      }
    }
    if (_gridData.isEmpty) {
      final traitsRaw = aiSummary['profile_traits'];
      if (traitsRaw is List) {
        for (final row in traitsRaw) {
          if (row is! Map) continue;
          final m = Map<String, dynamic>.from(row);
          final title = _str(m['label']);
          final value = _str(m['value']);
          if (title.isEmpty || value.isEmpty) continue;
          _gridData.add({
            'title': value,
            'subtitle': title,
            'image': AppAssets.fatLossIcon,
            'icon_url': _str(m['icon_url']),
          });
        }
      }
    }
    _focusData = [];
    final attrs = _resultData['ai_attributes'];
    if (attrs is Map) {
      final attrMap = Map<String, dynamic>.from(attrs);
      final todayFocus = attrMap['today_focus'];
      if (todayFocus is List) {
        for (final e in todayFocus) {
          final value = _str(e);
          if (value.isEmpty) continue;
          _focusData.add({'title': value, 'image': AppAssets.mealIcon});
        }
      }
      if (_focusData.isEmpty) {
        for (final entry in attrMap.entries) {
          final value = _str(entry.value);
          if (value.isEmpty) continue;
          _focusData.add({'title': value, 'image': AppAssets.mealIcon});
        }
      }
    }
    if (_focusData.isEmpty) {
      for (final value in _listOfStrings(aiSummary['analyzing_insights'])) {
        _focusData.add({'title': value, 'image': AppAssets.mealIcon});
      }
    }
    if (_focusData.isEmpty) {
      for (final value in _listOfStrings(aiSummary['best_clothing_fits'])) {
        _focusData.add({'title': value, 'image': AppAssets.mealIcon});
      }
    }

    final postureInsightRaw = aiSummary['posture_insight'];
    final postureInsight = postureInsightRaw is Map
        ? Map<String, dynamic>.from(postureInsightRaw)
        : <String, dynamic>{};
    _insightTitle = _str(postureInsight['title']);
    if (_insightTitle.isEmpty) _insightTitle = _str(aiSummary['title']);
    _insightText = _str(postureInsight['text']);
    if (_insightText.isEmpty) _insightText = _str(_resultData['ai_message']);

    final todayMealsRaw = aiSummary['today_meals'];
    final todayMeals = todayMealsRaw is Map
        ? Map<String, dynamic>.from(todayMealsRaw)
        : <String, dynamic>{};
    _todayMealsTitle = _str(todayMeals['title']);
    _todayMealsSubTitle = _str(todayMeals['subtitle']);
    if (_todayMealsTitle.isEmpty) _todayMealsTitle = _str(dailyPlan['title']);
    if (_todayMealsSubTitle.isEmpty) {
      _todayMealsSubTitle = _str(dailyPlan['subtitle']);
    }
    _badgeIcons = [];
    final badgeRaw = todayMeals['badge_icons'];
    if (badgeRaw is List) {
      for (final e in badgeRaw) {
        final s = _str(e);
        if (s.isNotEmpty) _badgeIcons.add(s);
      }
    }
    if (_badgeIcons.isEmpty) {
      final scans = _listOfMaps(aiSummary['review_scans']);
      for (final scan in scans) {
        final url = _str(scan['url']);
        if (url.isNotEmpty) _badgeIcons.add(url);
      }
    }
  }

  /// ✔ Tick logic (circle tap only)
  void selectPlan(int index) {
    selectedIndex = selectedIndex == index ? -1 : index;
    notifyListeners();
  }

  /// ⬇️ Expand logic (arrow tap only)
  void toggleExpand(int index) {
    expandedIndex = expandedIndex == index ? -1 : index;
    notifyListeners();
  }

  bool isPlanSelected(int index) => selectedIndex == index;
  bool isExpanded(int index) => expandedIndex == index;

  List<Map<String, dynamic>> get gridData => _gridData;
  List<Map<String, dynamic>> get exData => _focusData;
  String get insightTitle => _insightTitle;
  String get insightText => _insightText;
  String get todayMealsTitle => _todayMealsTitle;
  String get todayMealsSubTitle => _todayMealsSubTitle;

  /// ✔ selected item index

  void selectExercise(int index) {
    selectedIndex = selectedIndex == index ? -1 : index;
    notifyListeners();
  }

  bool isSelected(int index) => selectedIndex == index;

  String _detectDomain(Map<String, dynamic> payload) {
    final progressRaw = payload['progress'];
    if (progressRaw is Map) {
      final d = _str(progressRaw['domain']).toLowerCase();
      if (d.isNotEmpty) return d;
    }
    final d = _str(payload['domain']).toLowerCase();
    return d.isEmpty ? 'diet' : d;
  }

  List<String> _listOfStrings(dynamic raw) {
    if (raw is! List) return const <String>[];
    return raw
        .map((e) => _str(e))
        .where((e) => e.isNotEmpty)
        .toList(growable: false);
  }

  List<Map<String, dynamic>> _listOfMaps(dynamic raw) {
    if (raw is! List) return const <Map<String, dynamic>>[];
    return raw
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList(growable: false);
  }
}
