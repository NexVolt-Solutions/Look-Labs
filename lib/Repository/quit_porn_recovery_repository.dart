import 'package:looklabs/Model/quit_porn_recovery_ui_data.dart';
import 'package:looklabs/Model/sales_data.dart';
import 'package:looklabs/Repository/domain_progress_graph_repository.dart';
import 'package:looklabs/Repository/workout_completion_repository.dart';

class QuitPornRecoveryRepository {
  QuitPornRecoveryRepository._();
  static final QuitPornRecoveryRepository instance =
      QuitPornRecoveryRepository._();

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

  /// One GET completed-exercises; re-overlay every cached period (after toggling items).
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

  int _intFrom(dynamic v, {int fallback = 0}) {
    if (v is num) return v.toInt();
    return int.tryParse(v?.toString() ?? '') ?? fallback;
  }

  bool _boolFrom(dynamic v, {bool fallback = false}) {
    if (v is bool) return v;
    final s = v?.toString().toLowerCase().trim();
    if (s == 'true' || s == '1') return true;
    if (s == 'false' || s == '0') return false;
    return fallback;
  }

  String _strFrom(dynamic v, {String fallback = ''}) {
    final s = v?.toString().trim() ?? '';
    return s.isEmpty ? fallback : s;
  }

  /// Backend often sends `seq`; some payloads use `order`.
  int _orderFromMap(Map<String, dynamic> m, int listIndex) {
    return _intFrom(m['order'] ?? m['seq'], fallback: listIndex + 1);
  }

  RecoveryPathUiData parseUiData(Map<String, dynamic>? resultData) {
    final streakMapRaw = resultData?['ai_recovery']?['streak'];
    final streakMap = streakMapRaw is Map
        ? Map<String, dynamic>.from(streakMapRaw)
        : <String, dynamic>{};

    final streak = RecoveryStreakData(
      currentStreak: _intFrom(streakMap['current_streak']),
      longestStreak: _intFrom(streakMap['longest_streak']),
      nextGoal: _intFrom(streakMap['next_goal']),
      streakMessage: _strFrom(streakMap['streak_message']),
    );

    final insight = _strFrom(resultData?['ai_message']);

    final daily = _parseDaily(resultData);
    final exercise = _parseExercise(resultData);

    return RecoveryPathUiData(
      insightText: insight,
      streak: streak,
      dailyPlanItems: daily,
      exerciseItems: exercise,
    );
  }

  List<RecoveryTaskItem> _parseDaily(Map<String, dynamic>? resultData) {
    final raw = resultData?['ai_progress']?['recovery_checklist'];
    if (raw is! List || raw.isEmpty) return const [];

    final items = <RecoveryTaskItem>[];
    for (var i = 0; i < raw.length; i++) {
      final e = raw[i];
      if (e is Map) {
        final m = Map<String, dynamic>.from(e);
        final title = _strFrom(m['title'] ?? m['text']);
        if (title.isEmpty) continue;
        final durationMin = m['duration_min'];
        final order = _orderFromMap(m, i);
        items.add(
          RecoveryTaskItem(
            id: _strFrom(m['id'], fallback: 'daily_$order'),
            title: title,
            subtitle: _strFrom(m['subtitle'] ?? m['description']),
            duration: durationMin == null
                ? _strFrom(m['duration'])
                : '${_intFrom(durationMin)} min',
            completed: _boolFrom(m['completed']),
            order: order,
          ),
        );
      } else {
        final title = _strFrom(e);
        if (title.isEmpty) continue;
        items.add(
          RecoveryTaskItem(
            id: 'daily_$i',
            title: title,
            subtitle: '',
            duration: '',
            completed: false,
            order: i + 1,
          ),
        );
      }
    }
    if (items.isEmpty) return const [];
    items.sort((a, b) => a.order.compareTo(b.order));
    return items;
  }

  List<RecoveryTaskItem> _parseExercise(Map<String, dynamic>? resultData) {
    final raw = resultData?['ai_recovery']?['daily_tasks'];
    if (raw is! List || raw.isEmpty) return const [];

    final items = <RecoveryTaskItem>[];
    for (var i = 0; i < raw.length; i++) {
      final row = raw[i];
      if (row is! Map) continue;
      final m = Map<String, dynamic>.from(row);
      final title = _strFrom(m['title'] ?? m['text']);
      if (title.isEmpty) continue;
      final durationMin = m['duration_min'];
      final order = _orderFromMap(m, i);
      items.add(
        RecoveryTaskItem(
          id: _strFrom(m['id'], fallback: 'exercise_$order'),
          title: title,
          subtitle: _strFrom(m['description'] ?? m['details'] ?? m['activity']),
          duration: durationMin == null
              ? _strFrom(m['duration'] ?? m['time'])
              : '${_intFrom(durationMin)} min',
          completed: _boolFrom(m['completed']),
          order: order,
        ),
      );
    }
    if (items.isEmpty) return const [];
    items.sort((a, b) => a.order.compareTo(b.order));
    return items;
  }

  Future<List<SalesData>> loadChartForPeriod(String periodLabel) async {
    final completion = await WorkoutCompletionRepository.instance
        .loadCompletedExercises(DateTime.now(), domain: _domain);
    return _graphWithTodayOverlay(periodLabel, completion);
  }

  /// One completion GET, then parallel graph fetches — for refresh after actions.
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

  Future<Set<int>?> loadCompletedToday() {
    return WorkoutCompletionRepository.instance.loadCompleted(
      DateTime.now(),
      domain: _domain,
    );
  }

  Future<void> saveCheckedIndices({
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

  Future<void> reportRelapse({required int totalExercises}) {
    return WorkoutCompletionRepository.instance.saveCompleted(
      DateTime.now(),
      <int>{},
      domain: _domain,
      totalExercises: totalExercises,
    );
  }

  Future<void> completeDay({required int totalExercises}) {
    final all = <int>{for (var i = 0; i < totalExercises; i++) i};
    return WorkoutCompletionRepository.instance.saveCompleted(
      DateTime.now(),
      all,
      domain: _domain,
      totalExercises: totalExercises,
    );
  }
}
