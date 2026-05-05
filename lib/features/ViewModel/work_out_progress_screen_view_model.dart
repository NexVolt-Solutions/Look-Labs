import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Network/api_response.dart';
import 'package:looklabs/Core/Network/models/workout_result_response.dart';
import 'package:looklabs/Model/sales_data.dart';
import 'package:looklabs/Repository/domain_questions_repository.dart';
import 'package:looklabs/Repository/workout_completion_repository.dart';
import 'package:looklabs/Repository/workout_progress_graph_repository.dart';

part 'work_out_progress_screen_view_model_flow.dart';
part 'work_out_progress_screen_view_model_chart.dart';
part 'work_out_progress_screen_view_model_insight.dart';

 class WorkOutProgressScreenViewModel extends ChangeNotifier {
  static const String _domainKey = 'workout';

  WorkOutProgressScreenViewModel({
    WorkoutProgressGraphRepository? graphRepository,
  }) : _graphRepository =
           graphRepository ?? WorkoutProgressGraphRepository.instance;

  final WorkoutProgressGraphRepository _graphRepository;

  List<String> buttonName = const ['Week', 'Month', 'Year'];

  /// Selected graph period (same labels as quit porn recovery chart).
  String selectedChartPeriod = 'Week';

  final Map<String, List<SalesData>> _chartByPeriod = {};
  bool chartLoading = false;

  List<SalesData> get chartDataForSelectedPeriod =>
      _chartByPeriod[selectedChartPeriod] ?? const [];

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

  /// generate-plan `insight` or flow posture (title + body for insight card).
  String? _insightCardTitle;
  String? _insightCardBody;

  /// When true, GET flow must not replace insight card (generate-plan `insight` wins).
  bool _insightLockedFromGeneratePlan = false;
  String? get insightCardTitle => _insightCardTitle;
  String? get insightCardBody => _insightCardBody;
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

  /// Workout exercise indices (same resource as recovery checklist PUT).
  Set<int> _exerciseCompletedIndices = {};
  int get todayCompleted => _todayCompleted;
  int get todayTotal => _todayTotal;
  double get todayScore => _todayScore;

  /// Weekly summary from GET weekly-summary (API). days: [{ date, score, completed, total }].
  double _weekAverage = 0.0;
  List<Map<String, dynamic>> _weeklyDays = [];

  /// True after a successful weekly-summary response (use API [week_average] for the Week avg card).
  bool _weeklySummaryLoaded = false;
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

  /// Prefer API [week_average] when weekly-summary loaded (matches backend; avoids mean-of-7-days drift).
  double get displayWorkoutWeekScore {
    if (_weeklySummaryLoaded) return _weekAverage.clamp(0.0, 100.0);
    return displayWeekAverage;
  }

  bool _progressLoading = false;
  bool get progressLoading => _progressLoading;

  Timer? _checklistSaveDebounce;
  static const Duration _checklistSaveDelay = Duration(milliseconds: 450);

  void _notify() => notifyListeners();

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

  /// `strength_gain` e.g. "+12%" → 12 for progress bar.
  int get strengthGainProgress => _parsePercentString(_strengthGain);

  /// Slider 0–100: prefer `ai_progress` from flow/API, then today/week completion scores (no static default).
  double get fitnessBarValue {
    final fromAi = fitnessConsistencyProgress;
    if (fromAi > 0) return fromAi.toDouble().clamp(0.0, 100.0);
    final fromConsistency = _parsePercentString(_consistency);
    if (fromConsistency > 0) {
      return fromConsistency.toDouble().clamp(0.0, 100.0);
    }
    if (_todayScore > 0) return _todayScore.clamp(0.0, 100.0);
    if (displayWorkoutWeekScore > 0) {
      return displayWorkoutWeekScore.clamp(0.0, 100.0);
    }
    return 0.0;
  }

  double get calorieBarValue {
    final p = calorieBalanceProgress;
    if (p > 0) return p.toDouble().clamp(0.0, 100.0);
    return 0.0;
  }

  double get hydrationBarValue {
    final p = hydrationProgress;
    if (p > 0) return p.toDouble().clamp(0.0, 100.0);
    return 0.0;
  }

  double get strengthBarValue {
    final p = strengthGainProgress;
    if (p > 0) return p.toDouble().clamp(0.0, 100.0);
    return 0.0;
  }

  bool get showStrengthProgressBar => strengthBarValue > 0;

  Future<void> loadProgressData() => _loadProgressData();

  Future<void> refreshTodayCompletionFromApi() => _refreshTodayCompletionFromApi();

  Future<void> loadChartForPeriod(
    String periodLabel, {
    bool force = false,
  }) => _loadChartForPeriod(periodLabel, force: force);

  Future<void> onChartPeriodTap(String period) => _onChartPeriodTap(period);

  void setWorkoutData(Map<String, dynamic> data) => _setWorkoutData(data);

  Future<void> toggleChecklist(int index) => _toggleChecklist(index);

  Future<void> _persistChecklistAfterDebounce() => _persistChecklistAfterDebounceImpl();


  @override
  void dispose() {
    _checklistSaveDebounce?.cancel();
    super.dispose();
  }
}
