import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';

class WeeklyPlanScreenViewModel extends ChangeNotifier {
  bool isBestClothingSelected = false;
  int selectedIndex = -1;
  String headerTitle = 'Daily style themes to keep you sharp';
  Map<String, dynamic> _seasonalStyle = const {};
  final List<String> _seasonKeys = [];

  /// Filled from API only; no mock fallback.
  List<String> clothingFits = [];
  List<String> recommendedFabrics = [];
  List<String> footwear = [];

  /// Select season index. clothingFits must be set from API (no fallback data).
  void selectIndex(int index) {
    if (index < 0 || index >= _seasonKeys.length) return;
    selectedIndex = index;
    final key = _seasonKeys[index];
    final seasonRaw = _seasonalStyle[key];
    final season = seasonRaw is Map
        ? Map<String, dynamic>.from(seasonRaw)
        : <String, dynamic>{};
    clothingFits = _toStringList(season['outfit_combinations']);
    recommendedFabrics = _toStringList(season['recommended_fabrics']);
    footwear = _toStringList(season['footwear']);
    notifyListeners();
  }

  /// Call when API returns clothing fits for the selected season.
  void setClothingFitsFromApi(List<String> fits) {
    clothingFits = fits;
    notifyListeners();
  }

  bool get showClothingCard => selectedIndex != -1 && clothingFits.isNotEmpty;
  bool get showRecommendedFabricsCard =>
      selectedIndex != -1 && recommendedFabrics.isNotEmpty;
  bool get showFootwearCard => selectedIndex != -1 && footwear.isNotEmpty;
  List<Map<String, dynamic>> heightRoutineList = [];
  static const List<String> _weeklyDayIcons = [
    AppAssets.dayMondayIcon,
    AppAssets.dayTuesdayIcon,
    AppAssets.dayWednesdayIcon,
    AppAssets.dayThursdayIcon,
    AppAssets.dayFridayIcon,
    AppAssets.daySaturdayIcon,
    AppAssets.daySundayIcon,
  ];

  // int selectedIndex = -1; // ✔ tick state
  int expandedIndex = -1; // ⬇️ dropdown state

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

  bool isSelected(int index) => selectedIndex == index;

  List<Map<String, dynamic>> buttonName = [];
  final List<String> titleData = [
    'Outfit Combinations',
    'Recommended Fabrics',
    'Footwear',
  ];

  String get selectedSeasonCardTitle {
    if (selectedIndex < 0 || selectedIndex >= buttonName.length) {
      return titleData.first;
    }
    return '${buttonName[selectedIndex]['title']} ${titleData.first}';
  }

  void initializeFromFlow(Map<String, dynamic>? args) {
    final rawDaily = args?['daily_plan'];
    final daily = rawDaily is Map
        ? Map<String, dynamic>.from(rawDaily)
        : <String, dynamic>{};
    final subtitle = (daily['subtitle']?.toString() ?? '').trim();
    if (subtitle.isNotEmpty) headerTitle = subtitle;

    final weeklyRaw = daily['weekly_plan'];
    heightRoutineList = [];
    if (weeklyRaw is List) {
      for (final row in weeklyRaw) {
        if (row is! Map) continue;
        final m = Map<String, dynamic>.from(row);
        final day = (m['day']?.toString() ?? '').trim();
        final theme = (m['theme']?.toString() ?? '').trim();
        if (day.isEmpty && theme.isEmpty) continue;
        heightRoutineList.add({
          'time': day,
          'activity': theme,
          'details': 'Style focus for $day: $theme',
          'image': _weeklyDayIcons[heightRoutineList.length % _weeklyDayIcons.length],
        });
      }
    }

    final seasonalRaw = daily['seasonal_style'];
    _seasonalStyle = seasonalRaw is Map
        ? Map<String, dynamic>.from(seasonalRaw)
        : <String, dynamic>{};
    final tabs = _toStringList(daily['season_tabs']);
    _seasonKeys
      ..clear()
      ..addAll(
        tabs.isNotEmpty ? tabs : _seasonalStyle.keys.map((e) => '$e').toList(),
      );

    buttonName = _seasonKeys.map((season) {
      final lower = season.toLowerCase();
      final icon = lower == 'summer'
          ? AppAssets.sunIcon
          : lower == 'monsoon'
          ? AppAssets.rainIcon
          : AppAssets.winterIcon;
      return {
        'image': icon,
        'title': '${season[0].toUpperCase()}${season.substring(1)}',
      };
    }).toList();

    final defaultSeason = (daily['default_season']?.toString() ?? '').trim();
    selectedIndex = _seasonKeys.indexWhere(
      (e) => e.toLowerCase() == defaultSeason.toLowerCase(),
    );
    if (selectedIndex < 0 && _seasonKeys.isNotEmpty) selectedIndex = 0;
    if (selectedIndex >= 0) {
      selectIndex(selectedIndex);
    } else {
      notifyListeners();
    }
  }

  List<String> _toStringList(dynamic raw) {
    if (raw is! List) return const <String>[];
    return raw
        .map((e) => (e?.toString() ?? '').trim())
        .where((e) => e.isNotEmpty)
        .toList(growable: false);
  }
}
