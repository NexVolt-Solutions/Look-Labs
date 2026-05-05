part of 'quit_porn_recovery_repository.dart';

extension _QuitPornRecoveryRepositoryParsing on QuitPornRecoveryRepository {
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

  int _orderFromMap(Map<String, dynamic> m, int listIndex) {
    return _intFrom(m['order'] ?? m['seq'], fallback: listIndex + 1);
  }

  RecoveryPathUiData _parseUiData(Map<String, dynamic>? resultData) {
    final streakMapRaw = resultData?['ai_recovery']?['streak'];
    final streakMap = streakMapRaw is Map
        ? Map<String, dynamic>.from(streakMapRaw)
        : <String, dynamic>{};
    final summaryStreakRaw = resultData?['ai_summary']?['streak'];
    final summaryStreak = summaryStreakRaw is Map
        ? Map<String, dynamic>.from(summaryStreakRaw)
        : <String, dynamic>{};

    final streak = RecoveryStreakData(
      currentStreak: _intFrom(
        streakMap['current_streak'] ?? summaryStreak['current_streak'],
      ),
      longestStreak: _intFrom(
        streakMap['longest_streak'] ?? summaryStreak['longest_streak'],
      ),
      nextGoal: _intFrom(streakMap['next_goal'] ?? summaryStreak['next_goal']),
      streakMessage: _strFrom(
        streakMap['streak_message'] ?? summaryStreak['streak_message'],
      ),
    );

    final insight = _strFrom(
      resultData?['ai_message'] ?? resultData?['progress_screen']?['insight_text'],
    );

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
    final detailedRaw = resultData?['ai_recovery']?['daily_tasks'];

    final detailsByTitle = <String, Map<String, dynamic>>{};
    if (detailedRaw is List) {
      for (final row in detailedRaw) {
        if (row is! Map) continue;
        final m = Map<String, dynamic>.from(row);
        final key = _strFrom(m['title'] ?? m['text']).toLowerCase();
        if (key.isEmpty) continue;
        detailsByTitle[key] = m;
      }
    }

    if (raw is! List || raw.isEmpty) {
      if (detailedRaw is! List || detailedRaw.isEmpty) return const [];
      final detailedItems = <RecoveryTaskItem>[];
      for (var i = 0; i < detailedRaw.length; i++) {
        final row = detailedRaw[i];
        if (row is! Map) continue;
        final m = Map<String, dynamic>.from(row);
        final title = _strFrom(m['title'] ?? m['text']);
        if (title.isEmpty) continue;
        final durationMin = m['duration_min'];
        final order = _orderFromMap(m, i);
        detailedItems.add(
          RecoveryTaskItem(
            id: _strFrom(m['id'], fallback: 'daily_$order'),
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
      if (detailedItems.isEmpty) return const [];
      detailedItems.sort((a, b) => a.order.compareTo(b.order));
      return detailedItems;
    }

    final items = <RecoveryTaskItem>[];
    for (var i = 0; i < raw.length; i++) {
      final e = raw[i];
      if (e is Map) {
        final m = Map<String, dynamic>.from(e);
        final title = _strFrom(m['title'] ?? m['text']);
        if (title.isEmpty) continue;
        final details = detailsByTitle[title.toLowerCase()];
        final durationMin = m['duration_min'];
        final order = _orderFromMap(m, i);
        items.add(
          RecoveryTaskItem(
            id: _strFrom(m['id'], fallback: 'daily_$order'),
            title: title,
            subtitle: _strFrom(
              m['subtitle'] ?? m['description'] ?? details?['description'],
            ),
            duration: durationMin == null
                ? _strFrom(m['duration'] ?? details?['duration'] ?? details?['time'])
                : '${_intFrom(durationMin)} min',
            completed: _boolFrom(
              m['completed'],
              fallback: _boolFrom(details?['completed']),
            ),
            order: order,
          ),
        );
      } else {
        final title = _strFrom(e);
        if (title.isEmpty) continue;
        final details = detailsByTitle[title.toLowerCase()];
        items.add(
          RecoveryTaskItem(
            id: 'daily_$i',
            title: title,
            subtitle: _strFrom(
              details?['description'] ?? details?['details'] ?? details?['activity'],
            ),
            duration: _strFrom(details?['duration'] ?? details?['time']),
            completed: _boolFrom(details?['completed']),
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
    final raw =
        resultData?['ai_recovery']?['exercises'] ??
        resultData?['daily_plan']?['exercises'] ??
        resultData?['ai_recovery']?['daily_tasks'];
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
          subtitle: _strFrom(
            m['subtitle'] ?? m['description'] ?? m['details'] ?? m['activity'],
          ),
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
}
