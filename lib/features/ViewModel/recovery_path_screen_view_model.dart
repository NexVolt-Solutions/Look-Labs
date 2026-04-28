import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Model/quit_porn_recovery_ui_data.dart';
import 'package:looklabs/Model/sales_data.dart';
import 'package:looklabs/Repository/domain_progress_graph_repository.dart';
import 'package:looklabs/Repository/quit_porn_recovery_repository.dart';

class RecoveryPathScreenViewModel extends ChangeNotifier {
  RecoveryPathScreenViewModel({QuitPornRecoveryRepository? repository})
    : _repository = repository ?? QuitPornRecoveryRepository.instance;

  final QuitPornRecoveryRepository _repository;
  bool _initialized = false;

  RecoveryPathUiData uiData = RecoveryPathUiData.empty();
  final List<String> periodButtons = const ['Week', 'Month', 'Year'];
  final List<Map<String, String>> repButtons = const [
    {'image': AppAssets.reportIcon, 'text': 'Report Relapse'},
    {'image': AppAssets.doneIcon, 'text': 'Complete day'},
  ];
  String selectedSection = 'Daily Plan';
  String selectedPeriod = 'Week';
  int selectedAction = -1;
  bool chartLoading = false;
  bool completionLoaded = false;
  List<bool> dailyDone = [];
  List<bool> exerciseDone = [];
  final Map<String, List<SalesData>> chartByPeriod = {};
  bool _persistInFlight = false;
  bool _persistCoalesce = false;
  final Set<String> _chartLoadInFlight = <String>{};
  bool _actionInFlight = false;

  void _log(String message) {
    debugPrint('[RecoveryPathVM] $message');
  }

  String _lastPointLabel(List<SalesData> points) {
    if (points.isEmpty) return 'empty';
    final p = points.last;
    return '${p.month}:${p.sales.toStringAsFixed(1)}';
  }

  String _bucketValueLabel(List<SalesData> points, String key) {
    for (final p in points) {
      if (p.month == key) return '${p.month}:${p.sales.toStringAsFixed(1)}';
    }
    return '$key:missing';
  }

  List<RecoveryTaskItem> get selectedTaskItems {
    return selectedSection == 'Daily Plan'
        ? uiData.dailyPlanItems
        : uiData.exerciseItems;
  }

  List<bool> get selectedTaskDone {
    return selectedSection == 'Daily Plan' ? dailyDone : exerciseDone;
  }

  String get taskSectionTitle {
    return selectedSection == 'Daily Plan'
        ? 'Your Daily Tasks'
        : 'Mental & Physical Exercises';
  }

  Future<void> initialize(Map<String, dynamic>? resultData) async {
    if (_initialized) return;
    _initialized = true;
    uiData = _repository.parseUiData(resultData);
    dailyDone = uiData.dailyPlanItems.map((e) => e.completed).toList();
    exerciseDone = uiData.exerciseItems.map((e) => e.completed).toList();
    _log(
      'initialize dailyItems=${uiData.dailyPlanItems.length} '
      'exerciseItems=${uiData.exerciseItems.length}',
    );
    notifyListeners();
    await Future.wait([
      loadCompletionForToday(),
      loadChartForPeriod(selectedPeriod),
    ]);
  }

  void setSelectedSection(String section) {
    selectedSection = section;
    notifyListeners();
  }

  void setSelectedPeriod(String period) {
    selectedPeriod = period;
    notifyListeners();
  }

  void setSelectedAction(int index) {
    selectedAction = index;
    notifyListeners();
  }

  void setChartLoading(bool value) {
    chartLoading = value;
    notifyListeners();
  }

  void putChartPeriod(String period, List<SalesData> data) {
    chartByPeriod[period] = data;
    notifyListeners();
  }

  bool hasChartPeriod(String period) => chartByPeriod.containsKey(period);

  List<SalesData>? chartFor(String period) => chartByPeriod[period];

  void ensureChecklistLengths(int dailyLen, int exerciseLen) {
    if (dailyDone.length != dailyLen) {
      dailyDone = List<bool>.filled(dailyLen, false);
    }
    if (exerciseDone.length != exerciseLen) {
      exerciseDone = List<bool>.filled(exerciseLen, false);
    }
    notifyListeners();
  }

  void setCompletionLoaded(bool value) {
    completionLoaded = value;
    notifyListeners();
  }

  void setDailyDone(List<bool> value) {
    dailyDone = value;
    notifyListeners();
  }

  void setExerciseDone(List<bool> value) {
    exerciseDone = value;
    notifyListeners();
  }

  void toggleDailyDoneAt(int index) {
    if (index < 0 || index >= dailyDone.length) return;
    dailyDone[index] = !dailyDone[index];
    _log('toggleDaily index=$index checked=${dailyDone[index]}');
    _applyLocalOverlayToLoadedCharts(notify: false);
    notifyListeners();
    _persistChecklistState();
  }

  void toggleExerciseDoneAt(int index) {
    if (index < 0 || index >= exerciseDone.length) return;
    exerciseDone[index] = !exerciseDone[index];
    _log('toggleExercise index=$index checked=${exerciseDone[index]}');
    _applyLocalOverlayToLoadedCharts(notify: false);
    notifyListeners();
    _persistChecklistState();
  }

  Future<void> loadChartForPeriod(
    String periodLabel, {
    bool force = false,
  }) async {
    if (!force && hasChartPeriod(periodLabel)) return;
    if (_chartLoadInFlight.contains(periodLabel)) return;
    _chartLoadInFlight.add(periodLabel);
    _log('loadChart start period=$periodLabel force=$force');
    if (force) {
      chartByPeriod.remove(periodLabel);
    }
    final shouldShowLoader = force && chartByPeriod.isEmpty;
    if (shouldShowLoader) {
      setChartLoading(true);
    }
    try {
      final points = await _repository.loadChartForPeriod(periodLabel);
      _log(
        'loadChart api period=$periodLabel count=${points.length} '
        'last=${_lastPointLabel(points)}',
      );
      putChartPeriod(periodLabel, points);
      _applyLocalOverlayToLoadedCharts(notify: false);
    } finally {
      _chartLoadInFlight.remove(periodLabel);
      _log('loadChart end period=$periodLabel loading=$chartLoading');
      if (shouldShowLoader) {
        setChartLoading(false);
      }
    }
  }

  double get _localCompletionPercent {
    final total = _totalChecklistItems;
    if (total <= 0) return 0;
    final done = _combinedCheckedIndices().length;
    return (done * 100.0 / total).clamp(0.0, 100.0);
  }

  void _applyLocalOverlayToLoadedCharts({bool notify = true}) {
    if (chartByPeriod.isEmpty) return;
    final now = DateTime.now();
    final score = _localCompletionPercent;
    _log(
      'overlay start score=${score.toStringAsFixed(1)} '
      'checked=${_combinedCheckedIndices().length}/$_totalChecklistItems',
    );
    final next = <String, List<SalesData>>{};
    for (final e in chartByPeriod.entries) {
      final bucketKey = DomainProgressGraphRepository.bucketKeyForLocalDate(
        now,
        e.key,
      );
      final before = _lastPointLabel(e.value);
      final beforeBucket = _bucketValueLabel(e.value, bucketKey);
      next[e.key] = DomainProgressGraphRepository.overlayTodayRoutineScore(
        points: e.value,
        periodLabel: e.key,
        today: now,
        score: score,
      );
      final after = _lastPointLabel(next[e.key]!);
      final afterBucket = _bucketValueLabel(next[e.key]!, bucketKey);
      _log(
        'overlay period=${e.key} bucket=$bucketKey '
        'bucketBefore=$beforeBucket bucketAfter=$afterBucket '
        'lastBefore=$before lastAfter=$after',
      );
    }
    chartByPeriod
      ..clear()
      ..addAll(next);
    if (notify) notifyListeners();
  }

  Future<void> loadCompletionForToday() async {
    final done = await _repository.loadCompletedToday();
    ensureChecklistLengths(
      uiData.dailyPlanItems.length,
      uiData.exerciseItems.length,
    );
    if (done == null) {
      dailyDone = List<bool>.generate(
        uiData.dailyPlanItems.length,
        (i) => uiData.dailyPlanItems[i].completed,
      );
      exerciseDone = List<bool>.generate(
        uiData.exerciseItems.length,
        (i) => uiData.exerciseItems[i].completed,
      );
    } else {
      dailyDone = List<bool>.generate(uiData.dailyPlanItems.length, (i) {
        return uiData.dailyPlanItems[i].completed || done.contains(i);
      });
      final exerciseOffset = uiData.dailyPlanItems.length;
      exerciseDone = List<bool>.generate(uiData.exerciseItems.length, (i) {
        return uiData.exerciseItems[i].completed ||
            done.contains(exerciseOffset + i);
      });
    }
    completionLoaded = true;
    _log(
      'completionLoaded doneFromApi=${done?.length ?? 0} '
      'combinedChecked=${_combinedCheckedIndices().length}/$_totalChecklistItems',
    );
    notifyListeners();
  }

  Set<int> _combinedCheckedIndices() {
    final indices = <int>{};
    for (var i = 0; i < dailyDone.length; i++) {
      if (dailyDone[i]) indices.add(i);
    }
    final offset = dailyDone.length;
    for (var i = 0; i < exerciseDone.length; i++) {
      if (exerciseDone[i]) indices.add(offset + i);
    }
    return indices;
  }

  int get _totalChecklistItems => dailyDone.length + exerciseDone.length;

  Future<void> _persistChecklistState() async {
    if (_persistInFlight) {
      _persistCoalesce = true;
      _log('persist coalesced');
      return;
    }
    _persistInFlight = true;
    _log(
      'persist start indices=${_combinedCheckedIndices().toList()} '
      'total=$_totalChecklistItems',
    );
    try {
      do {
        _persistCoalesce = false;
        await _repository.saveCheckedIndices(
          indices: _combinedCheckedIndices(),
          totalExercises: _totalChecklistItems,
        );
        _log('persist round saved');
      } while (_persistCoalesce);
      _applyLocalOverlayToLoadedCharts();
    } finally {
      _persistInFlight = false;
      _log('persist end');
    }
  }

  Future<String> reportRelapse() async {
    final total = uiData.dailyPlanItems.length + uiData.exerciseItems.length;
    await _repository.reportRelapse(totalExercises: total);
    _log('action reportRelapse total=$total');
    setSelectedAction(0);
    setDailyDone(List<bool>.filled(uiData.dailyPlanItems.length, false));
    setExerciseDone(List<bool>.filled(uiData.exerciseItems.length, false));
    _applyLocalOverlayToLoadedCharts();
    return 'Relapse reported. Progress reset for today.';
  }

  Future<String> completeDay() async {
    final total = uiData.dailyPlanItems.length + uiData.exerciseItems.length;
    await _repository.completeDay(totalExercises: total);
    _log('action completeDay total=$total');
    setSelectedAction(1);
    setDailyDone(List<bool>.filled(uiData.dailyPlanItems.length, true));
    setExerciseDone(List<bool>.filled(uiData.exerciseItems.length, true));
    _applyLocalOverlayToLoadedCharts();
    return 'Day marked as completed.';
  }

  Future<void> onPeriodTap(String period) async {
    if (selectedPeriod == period) return;
    if (hasChartPeriod(period)) {
      setSelectedPeriod(period);
      return;
    }
    // Keep current chart visible while loading next period.
    await loadChartForPeriod(period);
    setSelectedPeriod(period);
  }

  Future<String> onActionTap(int actionIndex) async {
    if (_actionInFlight) {
      _log('action ignored: already in flight');
      return 'Please wait...';
    }
    _actionInFlight = true;
    try {
    if (actionIndex == 0) {
      return reportRelapse();
    }
    return completeDay();
    } finally {
      _actionInFlight = false;
    }
  }
}
