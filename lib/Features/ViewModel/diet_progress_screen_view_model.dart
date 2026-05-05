import 'package:flutter/material.dart';
import 'package:looklabs/Model/sales_data.dart';
import 'package:looklabs/Features/ViewModel/diet_progress_payload_mapper.dart';
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
      _flowDomain = DietProgressPayloadMapper.detectDomain(payload);
    } else {
      final flowRes = await DomainQuestionsRepository.instance.getDomainFlow(
        _flowDomain,
      );
      if (flowRes.success && flowRes.data is Map) {
        payload = Map<String, dynamic>.from(flowRes.data as Map);
        _flowDomain = DietProgressPayloadMapper.detectDomain(payload);
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
    final parsed = DietProgressPayloadMapper.parse(
      payload: payload,
      currentSubtitle: subtitle,
      currentTopStats: topStats,
      currentMiniBars: miniBars,
      currentMainConsistency: mainConsistency,
      currentInsightText: insightText,
      currentCheckBoxName: checkBoxName,
      currentSelectedChecklist: selectedChecklist,
    );
    _flowDomain = parsed.flowDomain;
    subtitle = parsed.subtitle;
    topStats = parsed.topStats;
    miniBars = parsed.miniBars;
    mainConsistency = parsed.mainConsistency;
    insightText = parsed.insightText;
    checkBoxName = parsed.checkBoxName;
    selectedChecklist = parsed.selectedChecklist;
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

}
