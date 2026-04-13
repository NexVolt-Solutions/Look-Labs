import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Network/api_response.dart';
import 'package:looklabs/Core/Network/models/workout_result_response.dart';
import 'package:looklabs/Model/sales_data.dart';
import 'package:looklabs/Repository/domain_questions_repository.dart';
import 'package:looklabs/Repository/workout_completion_repository.dart';
import 'package:looklabs/Repository/workout_progress_graph_repository.dart';

/// Progress + metrics UI. **Exercise completion** (`completed_indices`, score, today N/M) comes
/// from `GET/PUT completed-exercises`. **Recovery checklist** is a separate checklist (labels from
/// flow `ai_progress.recovery_checklist`; done state in `recovery_completed_indices`). Flow
/// `ai_attributes.workout_summary` is not used for exercise counts — those come from completion + plan.
class WorkOutProgressScreenViewModel extends ChangeNotifier {
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

  /// Same completion detection as [HomeViewModel] for GET `domains/workout/flow`.
  static bool _isCompletedWorkoutFlow(Map<String, dynamic> data) {
    final status = data['status']?.toString().toLowerCase().trim() ?? '';
    if (status == 'completed') return true;
    if (data['completed'] == true || data['is_completed'] == true) return true;
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
    final current = data['current'];
    final next = data['next'];
    if (status == 'ok' && current == null && next == null) return true;
    return false;
  }

  /// Fills top metric cards, sliders, recovery labels, and optional insight from flow `ai_*`.
  void _applyAiProgressFields(WorkoutAiProgress p) {
    _weeklyCalories = p.weeklyCalories;
    _consistency = p.consistency;
    _strengthGain = p.strengthGain;
    _fitnessConsistency = p.fitnessConsistency;
    _calorieBalance = p.calorieBalance;
    _hydration = p.hydration;
    if (p.recoveryChecklist.isNotEmpty) {
      _checkBoxName = p.recoveryChecklist;
      _selectedChecklist =
          List.generate(p.recoveryChecklist.length, (_) => false);
    }
    _rebuildInsightCardsFromAiProgress();
  }

  void _applyWorkoutFlowAiFromApi(Map<String, dynamic> data) {
    try {
      final result = WorkoutResultResponse.fromJson(data);
      if (result.aiProgress != null) {
        _applyAiProgressFields(result.aiProgress!);
      } else if (data['ai_progress'] is Map) {
        try {
          final p = WorkoutAiProgress.fromJson(
            Map<String, dynamic>.from(data['ai_progress'] as Map),
          );
          _applyAiProgressFields(p);
        } catch (_) {}
      }
      if (result.aiAttributes != null) {
        final a = result.aiAttributes!;
        if (a.postureInsight != null) {
          final pi = a.postureInsight!;
          _postureInsight = pi.message.isNotEmpty
              ? pi.message
              : (pi.title.isNotEmpty ? pi.title : null);
          if (!_insightLockedFromGeneratePlan) {
            final noPlanInsight =
                _insightCardTitle == null ||
                _insightCardTitle!.isEmpty ||
                (_insightCardBody == null || _insightCardBody!.isEmpty);
            if (noPlanInsight) {
              _insightCardTitle = pi.title.isNotEmpty
                  ? pi.title
                  : 'Posture insight';
              _insightCardBody = pi.message.isNotEmpty
                  ? pi.message
                  : (pi.title.isNotEmpty ? pi.title : null);
            }
          }
        }
      }
      if (result.aiMessage != null && result.aiMessage!.isNotEmpty) {
        _aiMessage = result.aiMessage;
      }
      if (!_insightLockedFromGeneratePlan) {
        final noInsightYet =
            _insightCardTitle == null ||
            _insightCardTitle!.isEmpty ||
            (_insightCardBody == null || _insightCardBody!.isEmpty);
        if (noInsightYet && _aiMessage != null && _aiMessage!.isNotEmpty) {
          _insightCardTitle = _aiMessage;
          _insightCardBody = null;
        }
      }
    } catch (_) {}
  }

  /// Load today's completed-exercises, weekly-summary, and workout flow (`ai_progress` / `ai_attributes`).
  Future<void> loadProgressData() async {
    _progressLoading = true;
    notifyListeners();
    try {
      final now = DateTime.now();
      final results = await Future.wait<Object?>([
        WorkoutCompletionRepository.instance.loadCompletedExercises(now),
        WorkoutCompletionRepository.instance.getWeeklySummary(),
        DomainQuestionsRepository.instance.getDomainFlow('workout'),
      ]);
      final todayData = results[0] as Map<String, dynamic>?;
      final weekly = results[1] as Map<String, dynamic>?;
      final flowRes = results[2] as ApiResponse;

      if (flowRes.success && flowRes.data is Map) {
        final fd = Map<String, dynamic>.from(flowRes.data as Map);
        if (_isCompletedWorkoutFlow(fd)) {
          _applyWorkoutFlowAiFromApi(fd);
        }
      }

      // Exercise totals/score/recovery checkmarks: only from completed-exercises (not flow summary).
      _ingestTodayCompletionPayload(todayData);

      if (weekly != null) {
        _weeklySummaryLoaded = true;
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
      } else {
        _weeklySummaryLoaded = false;
        _weekAverage = 0.0;
        _weeklyDays = [];
      }

      _rebuildMergedWeeklyDays(now);
      _buildProgressCardsFromApi();

      if (kDebugMode) {
        try {
          debugPrint(
            '[WorkoutProgress] screen data ← API merged for UI: '
            'today=$_todayCompleted/$_todayTotal score=$_todayScore '
            'recovery=${_recoveryIndicesFromChecklist()} '
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
      await loadChartForPeriod(selectedChartPeriod, force: true);
    } finally {
      _progressLoading = false;
      notifyListeners();
    }
  }

  void _ingestTodayCompletionPayload(Map<String, dynamic>? todayData) {
    if (todayData != null) {
      final ci = todayData['completed_indices'];
      if (ci is List) {
        _exerciseCompletedIndices = ci
            .map((e) => e is int ? e : int.tryParse(e?.toString() ?? ''))
            .whereType<int>()
            .where((i) => i >= 0)
            .toSet();
        _todayCompleted = _exerciseCompletedIndices.length;
      } else {
        _exerciseCompletedIndices = {};
        _todayCompleted = 0;
      }
      _todayTotal = todayData['total_exercises'] is int
          ? todayData['total_exercises'] as int
          : (todayData['total_exercises'] != null
                ? int.tryParse(todayData['total_exercises'].toString()) ?? 0
                : 0);
      _todayScore = (todayData['score'] is num)
          ? (todayData['score'] as num).toDouble()
          : 0.0;
      _applyRecoveryChecklistFromApi(todayData);
    } else {
      _todayCompleted = 0;
      _todayTotal = 0;
      _todayScore = 0.0;
      _exerciseCompletedIndices = {};
    }
  }

  /// After PUT completed-exercises (e.g. recovery checklist), refresh score/cards without full-screen load.
  Future<void> refreshTodayCompletionFromApi() async {
    final now = DateTime.now();
    final todayData = await WorkoutCompletionRepository.instance
        .loadCompletedExercises(now);
    _ingestTodayCompletionPayload(todayData);
    _rebuildMergedWeeklyDays(now);
    _buildProgressCardsFromApi();
    notifyListeners();
    await _syncChartOverlaysAfterCompletionChange();
  }

  Future<void> loadChartForPeriod(
    String periodLabel, {
    bool force = false,
  }) async {
    if (!force && _chartByPeriod.containsKey(periodLabel)) {
      selectedChartPeriod = periodLabel;
      notifyListeners();
      return;
    }
    if (force) {
      _chartByPeriod.remove(periodLabel);
    }
    chartLoading = true;
    notifyListeners();
    try {
      final points = await _graphRepository.loadChartForPeriod(periodLabel);
      _chartByPeriod[periodLabel] = points;
      selectedChartPeriod = periodLabel;
    } finally {
      chartLoading = false;
      notifyListeners();
    }
  }

  Future<void> onChartPeriodTap(String period) async {
    await loadChartForPeriod(period);
  }

  Future<void> _syncChartOverlaysAfterCompletionChange() async {
    if (_chartByPeriod.isEmpty) return;
    final next = await _graphRepository.reapplyTodayOverlayToAll(
      _chartByPeriod,
    );
    _chartByPeriod
      ..clear()
      ..addAll(next);
    notifyListeners();
  }

  static String _dateStr(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  void _applyRecoveryChecklistFromApi(Map<String, dynamic> todayData) {
    if (_checkBoxName.isEmpty) return;
    while (_selectedChecklist.length < _checkBoxName.length) {
      _selectedChecklist.add(false);
    }
    if (_selectedChecklist.length > _checkBoxName.length) {
      _selectedChecklist = _selectedChecklist
          .take(_checkBoxName.length)
          .toList(growable: false);
    }
    final raw = todayData['recovery_completed_indices'];
    final done = <int>{};
    if (raw is List) {
      for (final e in raw) {
        final i = e is int ? e : int.tryParse(e?.toString() ?? '');
        if (i != null && i >= 0) done.add(i);
      }
    }
    for (var i = 0; i < _selectedChecklist.length; i++) {
      _selectedChecklist[i] = done.contains(i);
    }
  }

  Set<int> _recoveryIndicesFromChecklist() {
    final out = <int>{};
    for (var i = 0; i < _selectedChecklist.length; i++) {
      if (_selectedChecklist[i]) out.add(i);
    }
    return out;
  }

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
      cards.add({'title': 'Today', 'value': '$_todayCompleted/$_todayTotal'});
      if (_todayScore > 0 || _todayTotal > 0) {
        cards.add({'title': 'Score', 'value': _todayScore.toStringAsFixed(0)});
      }
    }
    final wAvg = displayWeekAverage;
    if (_mergedWeeklyDays.isNotEmpty || wAvg > 0 || _weekAverage > 0) {
      final weekVal = _weeklySummaryLoaded ? _weekAverage : wAvg;
      cards.add({'title': 'Week avg', 'value': weekVal.toStringAsFixed(0)});
    }
    _progressCards = cards.isNotEmpty
        ? cards
        : [
            {'title': '—', 'value': '—'},
          ];
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
    if (_fitnessConsistency != null && _fitnessConsistency!.trim().isNotEmpty) {
      cards.add({
        'title': 'Fitness',
        'value': _fitnessConsistency!.trim(),
        'icon': AppAssets.muscleBodyIcon,
      });
    }
    if (_calorieBalance != null && _calorieBalance!.trim().isNotEmpty) {
      cards.add({
        'title': 'Calorie balance',
        'value': _calorieBalance!.trim(),
        'icon': AppAssets.mealIcon,
      });
    }
    if (_hydration != null && _hydration!.trim().isNotEmpty) {
      cards.add({
        'title': 'Hydration',
        'value': _hydration!.trim(),
        'icon': AppAssets.waterIcon,
      });
    }
    _insightProgressCards = cards;
  }

  /// Apply workout result (posture insight, ai message, recovery checklist, ai_progress metrics).
  /// Completion metrics still come from [loadProgressData].
  void setWorkoutData(Map<String, dynamic> data) {
    try {
      final result = WorkoutResultResponse.fromJson(data);
      _insightCardTitle = null;
      _insightCardBody = null;
      _insightLockedFromGeneratePlan = false;

      final rawInsight = data['insight'];
      if (rawInsight is Map) {
        final m = Map<String, dynamic>.from(rawInsight);
        final t = m['title']?.toString().trim() ?? '';
        final msg = m['message']?.toString().trim() ?? '';
        if (t.isNotEmpty || msg.isNotEmpty) {
          _insightLockedFromGeneratePlan = true;
          _insightCardTitle = t.isNotEmpty ? t : 'Insight';
          _insightCardBody = msg.isNotEmpty ? msg : t;
        }
      }

      if (result.aiProgress != null) {
        _applyAiProgressFields(result.aiProgress!);
      } else if (data['ai_progress'] is Map) {
        try {
          _applyAiProgressFields(
            WorkoutAiProgress.fromJson(
              Map<String, dynamic>.from(data['ai_progress'] as Map),
            ),
          );
        } catch (_) {}
      }
      if (result.aiAttributes != null) {
        final a = result.aiAttributes!;
        if (a.postureInsight != null) {
          final pi = a.postureInsight!;
          _postureInsight = pi.message.isNotEmpty
              ? pi.message
              : (pi.title.isNotEmpty ? pi.title : null);
          final noPlanInsight =
              _insightCardTitle == null ||
              _insightCardTitle!.isEmpty ||
              (_insightCardBody == null || _insightCardBody!.isEmpty);
          if (noPlanInsight) {
            _insightCardTitle = pi.title.isNotEmpty
                ? pi.title
                : 'Posture insight';
            _insightCardBody = pi.message.isNotEmpty
                ? pi.message
                : (pi.title.isNotEmpty ? pi.title : null);
          }
        }
      }
      if (result.aiMessage != null && result.aiMessage!.isNotEmpty) {
        _aiMessage = result.aiMessage;
      }
      final noInsightYet =
          _insightCardTitle == null ||
          _insightCardTitle!.isEmpty ||
          (_insightCardBody == null || _insightCardBody!.isEmpty);
      if (noInsightYet && _aiMessage != null && _aiMessage!.isNotEmpty) {
        _insightCardTitle = _aiMessage;
        _insightCardBody = null;
      }
      notifyListeners();
    } catch (_) {}
  }

  Future<void> toggleChecklist(int index) async {
    if (index < 0 || index >= _selectedChecklist.length) return;
    _selectedChecklist[index] = !_selectedChecklist[index];
    notifyListeners();

    _checklistSaveDebounce?.cancel();
    _checklistSaveDebounce = Timer(_checklistSaveDelay, () {
      _checklistSaveDebounce = null;
      unawaited(_persistChecklistAfterDebounce());
    });
  }

  Future<void> _persistChecklistAfterDebounce() async {
    final recovery = _recoveryIndicesFromChecklist();
    await WorkoutCompletionRepository.instance.saveCompleted(
      DateTime.now(),
      Set<int>.from(_exerciseCompletedIndices),
      totalExercises: _todayTotal > 0 ? _todayTotal : 0,
      recoveryCompletedIndices: recovery,
    );
    await refreshTodayCompletionFromApi();
  }

  @override
  void dispose() {
    _checklistSaveDebounce?.cancel();
    super.dispose();
  }
}
