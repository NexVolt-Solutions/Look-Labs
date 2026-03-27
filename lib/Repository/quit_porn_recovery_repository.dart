import 'package:looklabs/Core/Network/models/progress_graph_response.dart';
import 'package:looklabs/Model/quit_porn_recovery_ui_data.dart';
import 'package:looklabs/Model/sales_data.dart';
import 'package:looklabs/Repository/onboarding_repository.dart';
import 'package:looklabs/Repository/workout_completion_repository.dart';

class QuitPornRecoveryRepository {
  QuitPornRecoveryRepository._();
  static final QuitPornRecoveryRepository instance = QuitPornRecoveryRepository._();

  static const String _domain = 'quit_porn';

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

  RecoveryPathUiData parseUiData(Map<String, dynamic>? resultData) {
    final streakMapRaw = resultData?['ai_recovery']?['streak'];
    final streakMap = streakMapRaw is Map
        ? Map<String, dynamic>.from(streakMapRaw)
        : <String, dynamic>{};

    final fallback = RecoveryPathUiData.fallback();
    final streak = RecoveryStreakData(
      currentStreak: _intFrom(streakMap['current_streak']),
      longestStreak: _intFrom(streakMap['longest_streak']),
      nextGoal: _intFrom(streakMap['next_goal']),
      streakMessage: _strFrom(
        streakMap['streak_message'],
        fallback: fallback.streak.streakMessage,
      ),
    );

    final insight = _strFrom(
      resultData?['ai_message'],
      fallback: fallback.insightText,
    );

    final daily = _parseDaily(resultData, fallback.dailyPlanItems);
    final exercise = _parseExercise(resultData, fallback.exerciseItems);

    return RecoveryPathUiData(
      insightText: insight,
      streak: streak,
      dailyPlanItems: daily,
      exerciseItems: exercise,
    );
  }

  List<RecoveryTaskItem> _parseDaily(
    Map<String, dynamic>? resultData,
    List<RecoveryTaskItem> fallback,
  ) {
    final raw = resultData?['ai_progress']?['recovery_checklist'];
    if (raw is! List || raw.isEmpty) return fallback;

    final items = <RecoveryTaskItem>[];
    for (var i = 0; i < raw.length; i++) {
      final e = raw[i];
      if (e is Map) {
        final m = Map<String, dynamic>.from(e);
        final title = _strFrom(m['title'] ?? m['text']);
        if (title.isEmpty) continue;
        final durationMin = m['duration_min'];
        items.add(
          RecoveryTaskItem(
            id: _strFrom(m['id'], fallback: 'daily_$i'),
            title: title,
            subtitle: _strFrom(m['subtitle'] ?? m['description']),
            duration: durationMin == null
                ? _strFrom(m['duration'])
                : '${_intFrom(durationMin)} min',
            completed: _boolFrom(m['completed']),
            order: _intFrom(m['order'], fallback: i + 1),
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
    if (items.isEmpty) return fallback;
    items.sort((a, b) => a.order.compareTo(b.order));
    return items;
  }

  List<RecoveryTaskItem> _parseExercise(
    Map<String, dynamic>? resultData,
    List<RecoveryTaskItem> fallback,
  ) {
    final raw = resultData?['ai_recovery']?['daily_tasks'];
    if (raw is! List || raw.isEmpty) return fallback;

    final items = <RecoveryTaskItem>[];
    for (var i = 0; i < raw.length; i++) {
      final row = raw[i];
      if (row is! Map) continue;
      final m = Map<String, dynamic>.from(row);
      final title = _strFrom(m['title'] ?? m['text']);
      if (title.isEmpty) continue;
      final durationMin = m['duration_min'];
      items.add(
        RecoveryTaskItem(
          id: _strFrom(m['id'], fallback: 'exercise_$i'),
          title: title,
          subtitle: _strFrom(m['description'] ?? m['details'] ?? m['activity']),
          duration: durationMin == null
              ? _strFrom(m['duration'] ?? m['time'])
              : '${_intFrom(durationMin)} min',
          completed: _boolFrom(m['completed']),
          order: _intFrom(m['order'], fallback: i + 1),
        ),
      );
    }
    if (items.isEmpty) return fallback;
    items.sort((a, b) => a.order.compareTo(b.order));
    return items;
  }

  String _periodToApi(String label) {
    switch (label.toLowerCase()) {
      case 'month':
        return 'monthly';
      case 'year':
        return 'yearly';
      default:
        return 'weekly';
    }
  }

  String _labelFromDate(String recordedAt, String periodLabel) {
    final dt = DateTime.tryParse(recordedAt);
    if (dt == null) return recordedAt;
    switch (periodLabel.toLowerCase()) {
      case 'year':
        const m = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ];
        return m[dt.month - 1];
      case 'month':
        return '${dt.month}/${dt.day}';
      default:
        const d = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        return d[dt.weekday - 1];
    }
  }

  Future<List<SalesData>> loadChartForPeriod(String periodLabel) async {
    final res = await OnboardingRepository.instance.getProgressGraph(
      period: _periodToApi(periodLabel),
    );

    var points = <SalesData>[];
    if (res.success && res.data is ProgressGraphResponse) {
      final graph = res.data as ProgressGraphResponse;
      ProgressGraphDomain? domain;
      for (final d in graph.domains) {
        if (d.domain.trim().toLowerCase() == _domain) {
          domain = d;
          break;
        }
      }
      if (domain != null && domain.scores.isNotEmpty) {
        points = domain.scores
            .map(
              (s) => SalesData(
                _labelFromDate(s.recordedAt, periodLabel),
                s.score.toDouble(),
              ),
            )
            .toList();
      } else if (domain != null) {
        points = [SalesData(periodLabel, domain.latestScore.toDouble())];
      }
    }
    if (points.isEmpty) {
      points = [SalesData(periodLabel, 0)];
    }
    return points;
  }

  Future<Set<int>> loadCompletedToday() {
    return WorkoutCompletionRepository.instance.loadCompleted(
      DateTime.now(),
      domain: _domain,
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
