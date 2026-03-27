import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Network/models/workout_result_response.dart';
import 'package:looklabs/Model/sales_data.dart';
import 'package:looklabs/Repository/workout_completion_repository.dart';

class WorkOutProgressScreenViewModel extends ChangeNotifier {
  int currentStep = 0;
  String selectedIndex = '';

  List<String> buttonName = ['Week', 'Month', 'Year'];

  List<String> _checkBoxName = [
    'Got 7+ hours of sleep',
    'Drank 8+ glasses of water',
    'Stretched for 10 minutes',
    'Took a rest if needed',
  ];
  List<String> get checkBoxName => _checkBoxName;

  List<bool> _selectedChecklist = List.generate(4, (_) => false);
  List<bool> get selectedChecklist => _selectedChecklist;

  String? _weeklyCalories;
  String? _consistency;
  String? _strengthGain;
  String? _fitnessConsistency;
  String? _calorieBalance;
  String? _hydration;
  String? _postureInsight;
  String? _aiMessage;
  String? get weeklyCalories => _weeklyCalories;
  String? get consistency => _consistency;
  String? get strengthGain => _strengthGain;
  String? get fitnessConsistency => _fitnessConsistency;
  String? get postureInsight => _postureInsight;
  String? get aiMessage => _aiMessage;

  /// Top row: Weekly Cal / Consistency / Strength from flow `ai_progress` (when backend sends them).
  List<Map<String, String>> _insightProgressCards = [];
  List<Map<String, String>> get insightProgressCards => _insightProgressCards;

  List<Map<String, String>> _progressCards = [];
  List<Map<String, String>> get progressCards => _progressCards;

  /// Insight cards (if any) + completion API cards (Today, Score, Week avg) for horizontal strip.
  List<Map<String, String>> get combinedTopCards => [
        ..._insightProgressCards,
        ..._progressCards,
      ];

  /// Today's completion from GET completed-exercises (API).
  int _todayCompleted = 0;
  int _todayTotal = 0;
  double _todayScore = 0.0;
  int get todayCompleted => _todayCompleted;
  int get todayTotal => _todayTotal;
  double get todayScore => _todayScore;

  /// Weekly summary from GET weekly-summary (API). days: [{ date, score, completed, total }].
  double _weekAverage = 0.0;
  List<Map<String, dynamic>> _weeklyDays = [];
  double get weekAverage => _weekAverage;
  List<Map<String, dynamic>> get weeklyDays => _weeklyDays;

  /// Merged API days + today's completed-exercises so chart and week avg align with "Today".
  List<Map<String, dynamic>> _mergedWeeklyDays = [];

  /// Week average derived from [_mergedWeeklyDays] (includes today's score). Falls back to API [_weekAverage].
  double get displayWeekAverage {
    if (_mergedWeeklyDays.isEmpty) return _weekAverage;
    double sum = 0;
    for (final d in _mergedWeeklyDays) {
      final s = (d['score'] is num)
          ? (d['score'] as num).toDouble()
          : (double.tryParse(d['score']?.toString() ?? '') ?? 0.0);
      sum += s;
    }
    return sum / _mergedWeeklyDays.length;
  }

  /// Chart: current calendar week Mon–Sun; scores from merged weekly API + today (0 if no row).
  List<SalesData> get workoutChartData {
    return _expandToCalendarWeek(DateTime.now())
        .map(
          (d) => SalesData(
            d['day_label']?.toString() ?? '—',
            (d['score'] is num)
                ? (d['score'] as num).toDouble()
                : (double.tryParse(d['score']?.toString() ?? '') ?? 0.0),
          ),
        )
        .toList();
  }

  List<Map<String, dynamic>> _expandToCalendarWeek(DateTime now) {
    final byDate = <String, Map<String, dynamic>>{};
    for (final d in _mergedWeeklyDays) {
      final k = d['date']?.toString() ?? '';
      if (k.isNotEmpty) byDate[k] = d;
    }
    final monday = now.subtract(Duration(days: now.weekday - DateTime.monday));
    const weekdayShort = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final list = <Map<String, dynamic>>[];
    for (var i = 0; i < 7; i++) {
      final day = monday.add(Duration(days: i));
      final key = _dateStr(day);
      final existing = byDate[key];
      final score = existing != null
          ? ((existing['score'] is num)
              ? (existing['score'] as num).toDouble()
              : (double.tryParse(existing['score']?.toString() ?? '') ?? 0.0))
          : 0.0;
      list.add({
        'date': key,
        'score': score,
        'day_label': weekdayShort[i],
      });
    }
    return list;
  }

  bool _progressLoading = false;
  bool get progressLoading => _progressLoading;

  /// Parse percentage from string (e.g. "98%" -> 98, "95%" -> 95).
  static int _parsePercentString(String? s) {
    if (s == null || s.isEmpty) return 0;
    final n = int.tryParse(s.replaceAll(RegExp(r'[^\d]'), ''));
    return n ?? 0;
  }

  int get fitnessConsistencyProgress {
    return _parsePercentString(_fitnessConsistency ?? _consistency);
  }

  int get calorieBalanceProgress => _parsePercentString(_calorieBalance);

  int get hydrationProgress => _parsePercentString(_hydration);

  /// Slider value 0–100 for Fitness / Calorie / Hydration rows (falls back to live workout scores).
  double get fitnessBarValue {
    if (_todayScore > 0) return _todayScore.clamp(0.0, 100.0);
    if (displayWeekAverage > 0) return displayWeekAverage.clamp(0.0, 100.0);
    final p = fitnessConsistencyProgress;
    return p > 0 ? p.toDouble() : 10.0;
  }

  double get calorieBarValue {
    final p = calorieBalanceProgress;
    if (p > 0) return p.toDouble();
    return fitnessBarValue;
  }

  double get hydrationBarValue {
    final p = hydrationProgress;
    if (p > 0) return p.toDouble();
    return fitnessBarValue;
  }

  /// Load today's completed-exercises and weekly-summary from API.
  Future<void> loadProgressData() async {
    _progressLoading = true;
    notifyListeners();
    try {
      final now = DateTime.now();
      final todayData = await WorkoutCompletionRepository.instance
          .loadCompletedExercises(now);
      final weekly = await WorkoutCompletionRepository.instance
          .getWeeklySummary();

      _todayCompleted = (todayData['completed_indices'] is List)
          ? (todayData['completed_indices'] as List).length
          : 0;
      _todayTotal = todayData['total_exercises'] is int
          ? todayData['total_exercises'] as int
          : (todayData['total_exercises'] != null
              ? int.tryParse(todayData['total_exercises'].toString()) ?? 0
              : 0);
      _todayScore = (todayData['score'] is num)
          ? (todayData['score'] as num).toDouble()
          : 0.0;

      if (weekly['week_average'] is num) {
        _weekAverage = (weekly['week_average'] as num).toDouble();
      }
      _weeklyDays = [];
      if (weekly['days'] is List) {
        for (final d in weekly['days'] as List) {
          if (d is Map) {
            _weeklyDays.add(Map<String, dynamic>.from(d));
          }
        }
      }

      _rebuildMergedWeeklyDays(now);
      _buildProgressCardsFromApi();

      if (kDebugMode) {
        try {
          debugPrint(
            '[WorkoutProgress] screen data ← API merged for UI: '
            'today=$_todayCompleted/$_todayTotal score=$_todayScore '
            'weekAvg(raw)=$_weekAverage displayWeekAvg=${displayWeekAverage.toStringAsFixed(1)} '
            'mergedDays=${jsonEncode(_mergedWeeklyDays)} '
            'cards=${jsonEncode(_progressCards)}',
          );
        } catch (_) {
          debugPrint(
            '[WorkoutProgress] screen data ← today=$_todayCompleted/$_todayTotal '
            'score=$_todayScore displayWeekAvg=$displayWeekAverage',
          );
        }
      }
    } finally {
      _progressLoading = false;
      notifyListeners();
    }
  }

  static String _dateStr(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  /// Merge weekly-summary days with today's completed-exercises so week avg/chart include today.
  void _rebuildMergedWeeklyDays(DateTime now) {
    final todayStr = _dateStr(now);
    final merged = <Map<String, dynamic>>[];
    bool todayInApi = false;

    for (final d in _weeklyDays) {
      final date = d['date']?.toString() ?? '';
      if (date == todayStr) {
        todayInApi = true;
        merged.add({
          ...Map<String, dynamic>.from(d),
          'score': _todayScore,
          'completed': _todayCompleted,
          'total': _todayTotal,
        });
      } else {
        merged.add(Map<String, dynamic>.from(d));
      }
    }

    if (!todayInApi) {
      merged.add({
        'date': todayStr,
        'score': _todayScore,
        'completed': _todayCompleted,
        'total': _todayTotal,
      });
    }

    merged.sort(
      (a, b) =>
          (a['date']?.toString() ?? '').compareTo(b['date']?.toString() ?? ''),
    );
    _mergedWeeklyDays = merged;
  }

  void _buildProgressCardsFromApi() {
    final cards = <Map<String, String>>[];
    if (_todayTotal >= 0) {
      cards.add({
        'title': 'Today',
        'value': '$_todayCompleted/$_todayTotal',
      });
      if (_todayScore > 0 || _todayTotal > 0) {
        cards.add({
          'title': 'Score',
          'value': _todayScore.toStringAsFixed(0),
        });
      }
    }
    final wAvg = displayWeekAverage;
    if (_mergedWeeklyDays.isNotEmpty || wAvg > 0 || _weekAverage > 0) {
      cards.add({
        'title': 'Week avg',
        'value': wAvg.toStringAsFixed(0),
      });
    }
    _progressCards = cards.isNotEmpty ? cards : [{'title': '—', 'value': '—'}];
  }

  void _rebuildInsightCardsFromAiProgress() {
    final cards = <Map<String, String>>[];
    if (_weeklyCalories != null && _weeklyCalories!.trim().isNotEmpty) {
      cards.add({
        'title': 'Weekly Cal',
        'value': _weeklyCalories!.trim(),
        'icon': AppAssets.fireIcon,
      });
    }
    if (_consistency != null && _consistency!.trim().isNotEmpty) {
      cards.add({
        'title': 'Consistency',
        'value': _consistency!.trim(),
        'icon': AppAssets.electricLightIcon,
      });
    }
    if (_strengthGain != null && _strengthGain!.trim().isNotEmpty) {
      cards.add({
        'title': 'Strength',
        'value': _strengthGain!.trim(),
        'icon': AppAssets.actionWorkOutIcon,
      });
    }
    _insightProgressCards = cards;
  }

  /// Apply workout result (posture insight, ai message, recovery checklist, ai_progress metrics).
  /// Completion metrics still come from [loadProgressData].
  void setWorkoutData(Map<String, dynamic> data) {
    try {
      final result = WorkoutResultResponse.fromJson(data);
      if (result.aiProgress != null) {
        final p = result.aiProgress!;
        _weeklyCalories = p.weeklyCalories;
        _consistency = p.consistency;
        _strengthGain = p.strengthGain;
        _fitnessConsistency = p.fitnessConsistency;
        _calorieBalance = p.calorieBalance;
        _hydration = p.hydration;
        if (p.recoveryChecklist.isNotEmpty) {
          _checkBoxName = p.recoveryChecklist;
          _selectedChecklist = List.generate(
            p.recoveryChecklist.length,
            (_) => false,
          );
        }
        _rebuildInsightCardsFromAiProgress();
      }
      if (result.aiAttributes != null) {
        final a = result.aiAttributes!;
        if (a.postureInsight != null) {
          final pi = a.postureInsight!;
          _postureInsight = pi.message.isNotEmpty
              ? pi.message
              : (pi.title.isNotEmpty ? pi.title : null);
        }
      }
      if (result.aiMessage != null && result.aiMessage!.isNotEmpty) {
        _aiMessage = result.aiMessage;
      }
      notifyListeners();
    } catch (_) {}
  }

  void selectIndex(int index) {
    if (selectedIndex == buttonName[index]) {
      selectedIndex = '';
    } else {
      selectedIndex = buttonName[index];
    }
    notifyListeners();
  }

  void toggleChecklist(int index) {
    if (index >= 0 && index < _selectedChecklist.length) {
      _selectedChecklist[index] = !_selectedChecklist[index];
    }
    notifyListeners();
  }
}
