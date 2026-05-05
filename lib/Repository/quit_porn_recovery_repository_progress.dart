part of 'quit_porn_recovery_repository.dart';

extension _QuitPornRecoveryRepositoryProgress on QuitPornRecoveryRepository {
  static const String _domain = 'quit_porn';

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

  Future<Map<String, List<SalesData>>> _reapplyTodayOverlayToAll(
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

  Future<List<SalesData>> _loadChartForPeriod(String periodLabel) async {
    final completion = await WorkoutCompletionRepository.instance
        .loadCompletedExercises(DateTime.now(), domain: _domain);
    return _graphWithTodayOverlay(periodLabel, completion);
  }

  Future<Map<String, List<SalesData>>> _loadPeriodChartsWithTodayOverlay(
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

  Future<Set<int>?> _loadCompletedToday() {
    return WorkoutCompletionRepository.instance.loadCompleted(
      DateTime.now(),
      domain: _domain,
    );
  }

  Future<void> _saveCheckedIndices({
    required Set<int> indices,
    required int totalExercises,
  }) {
    return WorkoutCompletionRepository.instance.saveCompleted(
      DateTime.now(),
      indices,
      domain: _domain,
      totalExercises: totalExercises,
    );
  }

  Future<void> _reportRelapse({required int totalExercises}) {
    return WorkoutCompletionRepository.instance.saveCompleted(
      DateTime.now(),
      <int>{},
      domain: _domain,
      totalExercises: totalExercises,
    );
  }

  Future<void> _completeDay({required int totalExercises}) {
    final all = <int>{for (var i = 0; i < totalExercises; i++) i};
    return WorkoutCompletionRepository.instance.saveCompleted(
      DateTime.now(),
      all,
      domain: _domain,
      totalExercises: totalExercises,
    );
  }
}
