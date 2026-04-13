import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Model/quit_porn_recovery_ui_data.dart';
import 'package:looklabs/Model/sales_data.dart';
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
    notifyListeners();
    _persistChecklistState();
  }

  void toggleExerciseDoneAt(int index) {
    if (index < 0 || index >= exerciseDone.length) return;
    exerciseDone[index] = !exerciseDone[index];
    notifyListeners();
    _persistChecklistState();
  }

  Future<void> loadChartForPeriod(
    String periodLabel, {
    bool force = false,
  }) async {
    if (!force && hasChartPeriod(periodLabel)) return;
    if (force) {
      chartByPeriod.remove(periodLabel);
    }
    setChartLoading(true);
    final points = await _repository.loadChartForPeriod(periodLabel);
    putChartPeriod(periodLabel, points);
    setChartLoading(false);
  }

  /// Refetch Week/Month/Year graphs after progress changes (one completion GET + parallel graphs).
  Future<void> _refreshAllPeriodCharts() async {
    chartByPeriod.clear();
    notifyListeners();
    setChartLoading(true);
    notifyListeners();
    final map = await _repository.loadPeriodChartsWithTodayOverlay(
      periodButtons,
    );
    for (final e in map.entries) {
      putChartPeriod(e.key, e.value);
    }
    setChartLoading(false);
  }

  Future<void> _syncChartOverlaysAfterChecklist() async {
    if (chartByPeriod.isEmpty) return;
    final next = await _repository.reapplyTodayOverlayToAll(chartByPeriod);
    chartByPeriod
      ..clear()
      ..addAll(next);
    notifyListeners();
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
      return;
    }
    _persistInFlight = true;
    try {
      do {
        _persistCoalesce = false;
        await _repository.saveCheckedIndices(
          indices: _combinedCheckedIndices(),
          totalExercises: _totalChecklistItems,
        );
      } while (_persistCoalesce);
      await _syncChartOverlaysAfterChecklist();
    } finally {
      _persistInFlight = false;
    }
  }

  Future<String> reportRelapse() async {
    final total = uiData.dailyPlanItems.length + uiData.exerciseItems.length;
    await _repository.reportRelapse(totalExercises: total);
    setSelectedAction(0);
    setDailyDone(List<bool>.filled(uiData.dailyPlanItems.length, false));
    setExerciseDone(List<bool>.filled(uiData.exerciseItems.length, false));
    await _refreshAllPeriodCharts();
    return 'Relapse reported. Progress reset for today.';
  }

  Future<String> completeDay() async {
    final total = uiData.dailyPlanItems.length + uiData.exerciseItems.length;
    await _repository.completeDay(totalExercises: total);
    setSelectedAction(1);
    setDailyDone(List<bool>.filled(uiData.dailyPlanItems.length, true));
    setExerciseDone(List<bool>.filled(uiData.exerciseItems.length, true));
    await _refreshAllPeriodCharts();
    return 'Day marked as completed.';
  }

  Future<void> onPeriodTap(String period) async {
    setSelectedPeriod(period);
    await loadChartForPeriod(period);
  }

  Future<String> onActionTap(int actionIndex) async {
    if (actionIndex == 0) {
      return reportRelapse();
    }
    return completeDay();
  }
}
