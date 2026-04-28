import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';

class DietResultScreenViewModel extends ChangeNotifier {
  int selectedIndex = -1; // ✔ tick state
  int expandedIndex = -1; // ⬇️ dropdown state
  bool _initialized = false;
  Map<String, dynamic> _resultData = const {};
  List<Map<String, dynamic>> _gridData = [];
  List<Map<String, dynamic>> _focusData = [];
  String _insightTitle = 'Diet Insight';
  String _insightText = '';
  String _todayMealsTitle = '';
  String _todayMealsSubTitle = '';

  void initializeFromResult(Map<String, dynamic>? resultData) {
    if (_initialized) return;
    _initialized = true;
    _resultData = Map<String, dynamic>.from(resultData ?? const {});
    _buildFromApi();
    notifyListeners();
  }

  String _str(dynamic v) => (v?.toString() ?? '').trim();

  String _formatProgressPercent() {
    final p = _resultData['progress'];
    if (p is! Map) return '';
    final percent = p['progress_percent'];
    if (percent is num) return '${percent.toStringAsFixed(0)}%';
    final parsed = double.tryParse(_str(percent));
    if (parsed != null) return '${parsed.toStringAsFixed(0)}%';
    return '';
  }

  void _buildFromApi() {
    final progress = _resultData['progress'];
    final progressMap = progress is Map ? Map<String, dynamic>.from(progress) : {};
    final nested = progressMap['progress'];
    final nestedMap = nested is Map ? Map<String, dynamic>.from(nested) : {};
    final total = (nestedMap['total'] is num) ? (nestedMap['total'] as num).toInt() : 0;
    final answered = (nestedMap['answered'] is num)
        ? (nestedMap['answered'] as num).toInt()
        : 0;
    final progressPercent = _formatProgressPercent();

    _gridData = [
      {
        'title': 'Progress',
        'subtitle': progressPercent.isNotEmpty ? progressPercent : '${answered}/$total',
        'image': AppAssets.electricLightIcon,
      },
      {
        'title': 'Answered',
        'subtitle': '$answered/$total',
        'image': AppAssets.fatLossIcon,
      },
    ];

    final attrs = _resultData['ai_attributes'];
    if (attrs is Map) {
      final attrMap = Map<String, dynamic>.from(attrs);
      _focusData = attrMap.entries
          .map((e) {
            final rawValue = e.value;
            final value = rawValue is List
                ? rawValue.where((x) => _str(x).isNotEmpty).map((x) => _str(x)).join(', ')
                : _str(rawValue);
            if (value.isEmpty) return <String, dynamic>{};
            return {'title': value, 'image': AppAssets.mealIcon};
          })
          .where((m) => m.isNotEmpty)
          .toList();
    } else {
      _focusData = [];
    }

    _insightText = _str(_resultData['ai_message']);
    if (_insightText.isEmpty) {
      _insightText = 'Your diet analysis is ready. Follow your routine consistently for better progress.';
    }

    _todayMealsTitle = 'Today\'s Diet Plan';
    _todayMealsSubTitle = total > 0
        ? '$answered of $total questions completed'
        : 'Your personalized nutrition routine is ready';
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
}
