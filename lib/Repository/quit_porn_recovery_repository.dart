import 'package:looklabs/Model/quit_porn_recovery_ui_data.dart';
import 'package:looklabs/Model/sales_data.dart';
import 'package:looklabs/Repository/domain_progress_graph_repository.dart';
import 'package:looklabs/Repository/workout_completion_repository.dart';

part 'quit_porn_recovery_repository_parsing.dart';
part 'quit_porn_recovery_repository_progress.dart';

class QuitPornRecoveryRepository {
  QuitPornRecoveryRepository._();
  static final QuitPornRecoveryRepository instance =
      QuitPornRecoveryRepository._();

  RecoveryPathUiData parseUiData(Map<String, dynamic>? resultData) =>
      _parseUiData(resultData);
  Future<Map<String, List<SalesData>>> reapplyTodayOverlayToAll(
    Map<String, List<SalesData>> chartsByPeriod,
  ) => _reapplyTodayOverlayToAll(chartsByPeriod);
  Future<List<SalesData>> loadChartForPeriod(String periodLabel) =>
      _loadChartForPeriod(periodLabel);
  Future<Map<String, List<SalesData>>> loadPeriodChartsWithTodayOverlay(
    List<String> periodLabels,
  ) => _loadPeriodChartsWithTodayOverlay(periodLabels);
  Future<Set<int>?> loadCompletedToday() => _loadCompletedToday();
  Future<void> saveCheckedIndices({
    required Set<int> indices,
    required int totalExercises,
  }) => _saveCheckedIndices(indices: indices, totalExercises: totalExercises);
  Future<void> reportRelapse({required int totalExercises}) =>
      _reportRelapse(totalExercises: totalExercises);
  Future<void> completeDay({required int totalExercises}) =>
      _completeDay(totalExercises: totalExercises);
}
