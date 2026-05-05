part of 'work_out_progress_screen_view_model.dart';

extension _WorkOutProgressInsight on WorkOutProgressScreenViewModel {
  static bool _isCompletedWorkoutFlow(Map<String, dynamic> data) {
    final status = data['status']?.toString().toLowerCase().trim() ?? '';
    if (status == 'completed') return true;
    if (data['completed'] == true || data['is_completed'] == true) return true;
    const resultKeys = {
      'ai_message',
      'ai_progress',
      'ai_recovery',
      'ai_attributes',
      'ai_exercises',
      'result',
      'recommendations',
    };
    for (final k in resultKeys) {
      if (data.containsKey(k) && data[k] != null) return true;
    }
    final current = data['current'];
    final next = data['next'];
    if (status == 'ok' && current == null && next == null) return true;
    return false;
  }

  void _applyAiProgressFields(WorkoutAiProgress p) {
    _weeklyCalories = p.weeklyCalories;
    _consistency = p.consistency;
    _strengthGain = p.strengthGain;
    _fitnessConsistency = p.fitnessConsistency;
    _calorieBalance = p.calorieBalance;
    _hydration = p.hydration;
    if (p.recoveryChecklist.isNotEmpty) {
      _checkBoxName = p.recoveryChecklist;
      _selectedChecklist = List.generate(p.recoveryChecklist.length, (_) => false);
    }
    _rebuildInsightCardsFromAiProgress();
  }

  void _applyWorkoutFlowAiFromApi(Map<String, dynamic> data) {
    try {
      final result = WorkoutResultResponse.fromJson(data);
      if (result.aiProgress != null) {
        _applyAiProgressFields(result.aiProgress!);
      } else {
        _applyAiProgressFromRawMap(data);
      }
      if (result.aiAttributes != null) {
        final a = result.aiAttributes!;
        if (a.postureInsight != null) {
          final pi = a.postureInsight!;
          _postureInsight = pi.message.isNotEmpty
              ? pi.message
              : (pi.title.isNotEmpty ? pi.title : null);
          if (!_insightLockedFromGeneratePlan) {
            final noPlanInsight = _insightCardTitle == null ||
                _insightCardTitle!.isEmpty ||
                (_insightCardBody == null || _insightCardBody!.isEmpty);
            if (noPlanInsight) {
              _insightCardTitle = pi.title.isNotEmpty ? pi.title : 'Posture insight';
              _insightCardBody = pi.message.isNotEmpty
                  ? pi.message
                  : (pi.title.isNotEmpty ? pi.title : null);
            }
          }
        }
      }
      if (result.aiMessage != null && result.aiMessage!.isNotEmpty) {
        _aiMessage = result.aiMessage;
      }
      if (!_insightLockedFromGeneratePlan) {
        final noInsightYet = _insightCardTitle == null ||
            _insightCardTitle!.isEmpty ||
            (_insightCardBody == null || _insightCardBody!.isEmpty);
        if (noInsightYet && _aiMessage != null && _aiMessage!.isNotEmpty) {
          _insightCardTitle = _aiMessage;
          _insightCardBody = null;
        }
      }
    } catch (_) {}
  }

  void _applyAiProgressFromRawMap(Map<String, dynamic> data) {
    final raw = data['ai_progress'];
    if (raw is! Map) return;
    try {
      final parsed = WorkoutAiProgress.fromJson(Map<String, dynamic>.from(raw));
      _applyAiProgressFields(parsed);
    } catch (_) {}
  }

  void _rebuildInsightCardsFromAiProgress() {
    final cards = <Map<String, String>>[];
    if (_weeklyCalories != null && _weeklyCalories!.trim().isNotEmpty) {
      cards.add({'title': 'Weekly Cal', 'value': _weeklyCalories!.trim(), 'icon': AppAssets.fireIcon});
    }
    if (_consistency != null && _consistency!.trim().isNotEmpty) {
      cards.add({'title': 'Consistency', 'value': _consistency!.trim(), 'icon': AppAssets.electricLightIcon});
    }
    if (_strengthGain != null && _strengthGain!.trim().isNotEmpty) {
      cards.add({'title': 'Strength', 'value': _strengthGain!.trim(), 'icon': AppAssets.actionWorkOutIcon});
    }
    if (_fitnessConsistency != null && _fitnessConsistency!.trim().isNotEmpty) {
      cards.add({'title': 'Fitness', 'value': _fitnessConsistency!.trim(), 'icon': AppAssets.muscleBodyIcon});
    }
    if (_calorieBalance != null && _calorieBalance!.trim().isNotEmpty) {
      cards.add({'title': 'Calorie balance', 'value': _calorieBalance!.trim(), 'icon': AppAssets.mealIcon});
    }
    if (_hydration != null && _hydration!.trim().isNotEmpty) {
      cards.add({'title': 'Hydration', 'value': _hydration!.trim(), 'icon': AppAssets.waterIcon});
    }
    _insightProgressCards = cards;
  }

  void _setWorkoutData(Map<String, dynamic> data) {
    try {
      final result = WorkoutResultResponse.fromJson(data);
      _insightCardTitle = null;
      _insightCardBody = null;
      _insightLockedFromGeneratePlan = false;
      final rawInsight = data['insight'];
      if (rawInsight is Map) {
        final m = Map<String, dynamic>.from(rawInsight);
        final t = m['title']?.toString().trim() ?? '';
        final msg = m['message']?.toString().trim() ?? '';
        if (t.isNotEmpty || msg.isNotEmpty) {
          _insightLockedFromGeneratePlan = true;
          _insightCardTitle = t.isNotEmpty ? t : 'Insight';
          _insightCardBody = msg.isNotEmpty ? msg : t;
        }
      }
      if (result.aiProgress != null) {
        _applyAiProgressFields(result.aiProgress!);
      } else {
        _applyAiProgressFromRawMap(data);
      }
      if (result.aiAttributes != null) {
        final a = result.aiAttributes!;
        if (a.postureInsight != null) {
          final pi = a.postureInsight!;
          _postureInsight = pi.message.isNotEmpty
              ? pi.message
              : (pi.title.isNotEmpty ? pi.title : null);
          final noPlanInsight = _insightCardTitle == null ||
              _insightCardTitle!.isEmpty ||
              (_insightCardBody == null || _insightCardBody!.isEmpty);
          if (noPlanInsight) {
            _insightCardTitle = pi.title.isNotEmpty ? pi.title : 'Posture insight';
            _insightCardBody = pi.message.isNotEmpty
                ? pi.message
                : (pi.title.isNotEmpty ? pi.title : null);
          }
        }
      }
      if (result.aiMessage != null && result.aiMessage!.isNotEmpty) {
        _aiMessage = result.aiMessage;
      }
      final noInsightYet = _insightCardTitle == null ||
          _insightCardTitle!.isEmpty ||
          (_insightCardBody == null || _insightCardBody!.isEmpty);
      if (noInsightYet && _aiMessage != null && _aiMessage!.isNotEmpty) {
        _insightCardTitle = _aiMessage;
        _insightCardBody = null;
      }
      _notify();
    } catch (_) {}
  }
}
