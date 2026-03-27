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

  RecoveryPathUiData uiData = RecoveryPathUiData.fallback();
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
  }

  void toggleExerciseDoneAt(int index) {
    if (index < 0 || index >= exerciseDone.length) return;
    exerciseDone[index] = !exerciseDone[index];
    notifyListeners();
  }

  Future<void> loadChartForPeriod(String periodLabel) async {
    if (hasChartPeriod(periodLabel)) return;
    setChartLoading(true);
    final points = await _repository.loadChartForPeriod(periodLabel);
    putChartPeriod(periodLabel, points);
    setChartLoading(false);
  }

  Future<void> loadCompletionForToday() async {
    final done = await _repository.loadCompletedToday();
    ensureChecklistLengths(
      uiData.dailyPlanItems.length,
      uiData.exerciseItems.length,
    );
    dailyDone = List<bool>.generate(uiData.dailyPlanItems.length, (i) {
      return uiData.dailyPlanItems[i].completed || done.contains(i);
    });
    completionLoaded = true;
    notifyListeners();
  }

  Future<String> reportRelapse() async {
    await _repository.reportRelapse(
      totalExercises: uiData.dailyPlanItems.length,
    );
    setSelectedAction(0);
    setDailyDone(List<bool>.filled(uiData.dailyPlanItems.length, false));
    setExerciseDone(List<bool>.filled(uiData.exerciseItems.length, false));
    return 'Relapse reported. Progress reset for today.';
  }

  Future<String> completeDay() async {
    await _repository.completeDay(totalExercises: uiData.dailyPlanItems.length);
    setSelectedAction(1);
    setDailyDone(List<bool>.filled(uiData.dailyPlanItems.length, true));
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
