import 'package:looklabs/Model/quit_porn_recovery_ui_data.dart';
import 'package:looklabs/Model/sales_data.dart';
import 'package:looklabs/Repository/domain_progress_graph_repository.dart';
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

  List<RecoveryTaskItem> _parseDaily(
    Map<String, dynamic>? resultData,
  ) {
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
    if (items.isEmpty) return const [];
    items.sort((a, b) => a.order.compareTo(b.order));
    return items;
  }

  List<RecoveryTaskItem> _parseExercise(
    Map<String, dynamic>? resultData,
  ) {
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
    if (items.isEmpty) return const [];
    items.sort((a, b) => a.order.compareTo(b.order));
    return items;
  }

  Future<List<SalesData>> loadChartForPeriod(String periodLabel) async {
    return DomainProgressGraphRepository.instance.getDomainChartPoints(
      domain: _domain,
      periodLabel: periodLabel,
    );
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
