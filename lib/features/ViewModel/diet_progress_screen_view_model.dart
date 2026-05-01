import 'package:flutter/material.dart';
import 'package:looklabs/Model/sales_data.dart';
import 'package:looklabs/Repository/diet_repository.dart';
import 'package:looklabs/Repository/domain_progress_graph_repository.dart';
import 'package:looklabs/Repository/domain_questions_repository.dart';
import 'package:looklabs/Repository/workout_completion_repository.dart';

class DietProgressScreenViewModel extends ChangeNotifier {
  int currentStep = 0;
  String selectedIndex = 'Week';
  bool _initialized = false;
  bool _loading = false;
  String subtitle = '';

  List<String> buttonName = ['Week', 'Month', 'Year'];
  List<Map<String, dynamic>> topStats = const [];
  List<Map<String, dynamic>> miniBars = const [];
  Map<String, dynamic> mainConsistency = const {};
  String insightText = '';
  List<SalesData> chartData = const [];
  double? _todayCompletionScore;
  String _flowDomain = 'diet';

  List<String> checkBoxName = [];
  Future<void> selectIndex(int index) async {
    if (index < 0 || index >= buttonName.length) return;
    selectedIndex = buttonName[index];
    var points = await DomainProgressGraphRepository.instance.getDomainChartPoints(
      domain: _flowDomain,
      periodLabel: selectedIndex,
    );
    final todayScore = _todayCompletionScore;
    if (todayScore != null) {
      points = DomainProgressGraphRepository.overlayTodayRoutineScore(
        points: points,
        periodLabel: selectedIndex,
        today: DateTime.now(),
        score: todayScore,
      );
    }
    chartData = points;
    notifyListeners();
  }

  List<bool> selectedChecklist = [];

  bool get loading => _loading;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    _loading = true;
    notifyListeners();
    await DietRepository.instance.ensureFlowCacheLoaded();

    Map<String, dynamic>? payload;
    final cached = DietRepository.instance.cachedFlowPayload;
    if (cached != null && cached.isNotEmpty) {
      payload = Map<String, dynamic>.from(cached);
      _flowDomain = _detectDomain(payload);
    } else {
      final flowRes = await DomainQuestionsRepository.instance.getDomainFlow(
        _flowDomain,
      );
      if (flowRes.success && flowRes.data is Map) {
        payload = Map<String, dynamic>.from(flowRes.data as Map);
        _flowDomain = _detectDomain(payload);
        final status = (payload['status']?.toString() ?? '').toLowerCase();
        if (status == 'processing' ||
            status == 'pending' ||
            status == 'in_progress') {
          final completed = await DomainQuestionsRepository.instance
              .pollDomainFlowUntilCompleted(
                _flowDomain,
                lastKnownResponse: payload,
              );
          if (completed != null) payload = Map<String, dynamic>.from(completed);
        }
      }
    }
    if (payload != null) {
      DietRepository.instance.setFlowCache(payload);
      _applyFlowPayload(payload);
      await _syncChecklistFromCompletion();
    }
    await _loadTodayCompletionScore();
    await selectIndex(buttonName.indexOf(selectedIndex));

    _loading = false;
    notifyListeners();
  }

  void _applyFlowPayload(Map<String, dynamic> payload) {
    _flowDomain = _detectDomain(payload);
    final psRaw = payload['progress_screen'];
    if (psRaw is Map) {
      final ps = Map<String, dynamic>.from(psRaw);
      subtitle = (ps['subtitle']?.toString() ?? '').trim();

      final statsRaw = ps['top_stats'];
      if (statsRaw is List) {
        topStats = statsRaw
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }

      final barsRaw = ps['mini_bars'];
      if (barsRaw is List) {
        miniBars = barsRaw
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }

      final mcRaw = ps['main_consistency'];
      if (mcRaw is Map) {
        mainConsistency = Map<String, dynamic>.from(mcRaw);
      }

      final insight = (ps['insight_text']?.toString() ?? '').trim();
      if (insight.isNotEmpty) insightText = insight;

      final checklistRaw = ps['daily_recovery_checklist'];
      if (checklistRaw is List && checklistRaw.isNotEmpty) {
        final titles = <String>[];
        final checks = <bool>[];
        for (final row in checklistRaw) {
          if (row is! Map) continue;
          final m = Map<String, dynamic>.from(row);
          final title = (m['title']?.toString() ?? '').trim();
          if (title.isEmpty) continue;
          titles.add(title);
          checks.add(m['completed'] == true);
        }
        if (titles.isNotEmpty) {
          checkBoxName = titles;
          selectedChecklist = checks;
        }
      }
    }

    // Fallback mapping for fashion-style payloads when progress_screen is missing.
    final summaryRaw = payload['ai_summary'];
    final summary = summaryRaw is Map
        ? Map<String, dynamic>.from(summaryRaw)
        : <String, dynamic>{};
    if (subtitle.trim().isEmpty) {
      subtitle = (summary['subtitle']?.toString() ?? '').trim();
    }

    final progressRaw = payload['progress'];
    final progress = progressRaw is Map
        ? Map<String, dynamic>.from(progressRaw)
        : <String, dynamic>{};
    final total = _toInt(progress['total'], fallback: 0);
    final answered = _toInt(progress['answered'], fallback: 0);
    final percent = _toDouble(
      progress['progress_percent'],
      fallback: total > 0 ? (answered * 100.0) / total : 0,
    );
    if (topStats.isEmpty && progress.isNotEmpty) {
      topStats = [
        {'value': '$answered/$total', 'label': 'Answered'},
        {'value': '${percent.toStringAsFixed(0)}%', 'label': 'Completion'},
        {
          'value': (payload['subscription_status']?.toString() ?? '-')
              .toUpperCase(),
          'label': 'Subscription',
        },
      ];
    }
    if (miniBars.isEmpty && progress.isNotEmpty) {
      miniBars = [
        {'title': 'Answered', 'percent': total > 0 ? answered / total : 0},
        {'title': 'Progress', 'percent': percent / 100.0},
      ];
    }
    if (mainConsistency.isEmpty && progress.isNotEmpty) {
      mainConsistency = {
        'title': 'Flow Completion',
        'subtitle': '$answered of $total questions answered',
        'percent': percent,
      };
    }
    if (insightText.trim().isEmpty) {
      insightText = (payload['ai_message']?.toString() ?? '').trim();
    }
    if (insightText.isEmpty) {
      final insights = summary['analyzing_insights'];
      if (insights is List && insights.isNotEmpty) {
        insightText = (insights.first?.toString() ?? '').trim();
      }
    }

    if (checkBoxName.isNotEmpty) return;

    // Fallback to weekly_plan/day-theme titles when checklist is absent.
    final dailyRaw = payload['daily_plan'];
    if (dailyRaw is! Map) return;
    final daily = Map<String, dynamic>.from(dailyRaw);
    final weeklyRaw = daily['weekly_plan'];
    if (weeklyRaw is List && weeklyRaw.isNotEmpty) {
      final titles = <String>[];
      for (final row in weeklyRaw) {
        if (row is! Map) continue;
        final m = Map<String, dynamic>.from(row);
        final day = (m['day']?.toString() ?? '').trim();
        final theme = (m['theme']?.toString() ?? '').trim();
        final title = [day, theme].where((e) => e.isNotEmpty).join(' • ');
        if (title.isNotEmpty) titles.add(title);
      }
      if (titles.isNotEmpty) {
        checkBoxName = titles;
        selectedChecklist = List<bool>.filled(titles.length, false);
        return;
      }
    }

    // Backward fallback to daily_plan morning/evening titles.
    final morning = daily['morning'];
    final evening = daily['evening'];
    final titles = <String>[];
    if (morning is List) {
      for (final row in morning) {
        if (row is! Map) continue;
        final t = (row['title']?.toString() ?? '').trim();
        if (t.isNotEmpty) titles.add(t);
      }
    }
    if (evening is List) {
      for (final row in evening) {
        if (row is! Map) continue;
        final t = (row['title']?.toString() ?? '').trim();
        if (t.isNotEmpty) titles.add(t);
      }
    }
    if (titles.isNotEmpty) {
      checkBoxName = titles;
      selectedChecklist = List<bool>.filled(titles.length, false);
    }
  }

  Future<void> _syncChecklistFromCompletion() async {
    if (checkBoxName.isEmpty) return;
    final payload = await WorkoutCompletionRepository.instance
        .loadCompletedExercises(
      DateTime.now(),
      domain: _flowDomain,
    );
    if (payload == null) return;
    Set<int> done = <int>{};
    final recoveryRaw = payload['recovery_completed_indices'];
    if (recoveryRaw is List) {
      done = recoveryRaw
          .map((e) => e is int ? e : int.tryParse(e?.toString() ?? ''))
          .whereType<int>()
          .where((i) => i >= 0)
          .toSet();
    } else {
      // Backward compatibility for older payloads where checklist was saved in completed_indices.
      final legacyRaw = payload['completed_indices'];
      if (legacyRaw is List) {
        done = legacyRaw
            .map((e) => e is int ? e : int.tryParse(e?.toString() ?? ''))
            .whereType<int>()
            .where((i) => i >= 0)
            .toSet();
      }
    }
    selectedChecklist = List<bool>.generate(
      checkBoxName.length,
      (i) => done.contains(i),
    );
  }

  Future<void> toggleChecklist(int index) async {
    if (index < 0 || index >= selectedChecklist.length) return;
    selectedChecklist[index] = !selectedChecklist[index];
    notifyListeners();
    final selectedRecovery = <int>{};
    for (var i = 0; i < selectedChecklist.length; i++) {
      if (selectedChecklist[i]) selectedRecovery.add(i);
    }

    // Checklist updates are recovery-only for diet; backend preserves routine indices.
    await WorkoutCompletionRepository.instance.saveCompletedPartial(
      DateTime.now(),
      domain: _flowDomain,
      recoveryCompletedIndices: selectedRecovery,
    );
    await _loadTodayCompletionScore();
    await selectIndex(buttonName.indexOf(selectedIndex));
  }

  Future<void> _loadTodayCompletionScore() async {
    final payload = await WorkoutCompletionRepository.instance
        .loadCompletedExercises(
      DateTime.now(),
      domain: _flowDomain,
    );
    if (payload == null) return;
    final scoreRaw = payload['score'];
    if (scoreRaw is num) {
      _todayCompletionScore = scoreRaw.toDouble();
      return;
    }
    _todayCompletionScore = null;
  }

  String _detectDomain(Map<String, dynamic> payload) {
    final progressRaw = payload['progress'];
    if (progressRaw is Map) {
      final d = (progressRaw['domain']?.toString() ?? '').trim().toLowerCase();
      if (d.isNotEmpty) return d;
    }
    final d = (payload['domain']?.toString() ?? '').trim().toLowerCase();
    return d.isEmpty ? 'diet' : d;
  }

  int _toInt(dynamic raw, {required int fallback}) {
    if (raw is int) return raw;
    if (raw is num) return raw.toInt();
    if (raw is String) return int.tryParse(raw.trim()) ?? fallback;
    return fallback;
  }

  double _toDouble(dynamic raw, {required double fallback}) {
    if (raw is double) return raw;
    if (raw is num) return raw.toDouble();
    if (raw is String) return double.tryParse(raw.trim()) ?? fallback;
    return fallback;
  }
}
