import 'package:looklabs/Model/sales_data.dart';
import 'package:looklabs/Repository/domain_progress_graph_repository.dart';
import 'package:looklabs/Repository/workout_completion_repository.dart';

/// Workout domain charts via [DomainProgressGraphRepository], with today's
/// score overlaid from GET `domains/workout/completed-exercises` (same pattern as quit porn).
class WorkoutProgressGraphRepository {
  WorkoutProgressGraphRepository._();
  static final WorkoutProgressGraphRepository instance =
      WorkoutProgressGraphRepository._();

  static const String _domain = 'workout';

  double? _scoreFromCompletionPayload(Map<String, dynamic>? raw) {
    if (raw == null) return null;
    final s = raw['score'];
    if (s is! num) return null;
    return s.toDouble().clamp(0.0, 100.0);
  }

  List<SalesData> _applyOverlayToPoints(
    List<SalesData> points,
    String periodLabel,
    Map<String, dynamic>? completionPayload,
  ) {
    final todayScore = _scoreFromCompletionPayload(completionPayload);
    if (todayScore == null) return points;
    return DomainProgressGraphRepository.overlayTodayRoutineScore(
      points: points,
      periodLabel: periodLabel,
      today: DateTime.now(),
      score: todayScore,
    );
  }

  Future<List<SalesData>> _graphWithTodayOverlay(
    String periodLabel,
    Map<String, dynamic>? completionPayload,
  ) async {
    final pts = await DomainProgressGraphRepository.instance
        .getDomainChartPoints(domain: _domain, periodLabel: periodLabel);
    return _applyOverlayToPoints(pts, periodLabel, completionPayload);
  }

  Future<List<SalesData>> loadChartForPeriod(String periodLabel) async {
    try {
      final completion = await WorkoutCompletionRepository.instance
          .loadCompletedExercises(DateTime.now(), domain: _domain);
      return await _graphWithTodayOverlay(periodLabel, completion);
    } catch (_) {
      return DomainProgressGraphRepository.emptyChartBuckets(periodLabel);
    }
  }

  Future<Map<String, List<SalesData>>> loadPeriodChartsWithTodayOverlay(
    List<String> periodLabels,
  ) async {
    final completion = await WorkoutCompletionRepository.instance
        .loadCompletedExercises(DateTime.now(), domain: _domain);
    final lists = await Future.wait(
      periodLabels.map((p) => _graphWithTodayOverlay(p, completion)),
    );
    return {
      for (var i = 0; i < periodLabels.length; i++) periodLabels[i]: lists[i],
    };
  }

  Future<Map<String, List<SalesData>>> reapplyTodayOverlayToAll(
    Map<String, List<SalesData>> chartsByPeriod,
  ) async {
    if (chartsByPeriod.isEmpty) return chartsByPeriod;
    final completion = await WorkoutCompletionRepository.instance
        .loadCompletedExercises(DateTime.now(), domain: _domain);
    return {
      for (final e in chartsByPeriod.entries)
        e.key: _applyOverlayToPoints(e.value, e.key, completion),
    };
  }
}
