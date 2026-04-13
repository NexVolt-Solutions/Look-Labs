import 'package:flutter/material.dart';
import 'package:looklabs/Core/Network/models/workout_result_response.dart';
import 'package:looklabs/Repository/workout_completion_repository.dart';

/// Daily exercise list from generate-plan / merged flow. [markExerciseDone] updates **exercise**
/// indices only; each PUT also sends [recoveryCompletedIndices] so checklist progress is not wiped.
class DailyWorkoutRoutineViewModel extends ChangeNotifier {
  List<Map<String, dynamic>> _morningRoutineList = [];
  List<Map<String, dynamic>> _eveningRoutineList = [];
  List<Map<String, dynamic>> get morningRoutineList => _morningRoutineList;
  List<Map<String, dynamic>> get eveningRoutineList => _eveningRoutineList;
  List<Map<String, dynamic>> get heightRoutineList => [
    ..._morningRoutineList,
    ..._eveningRoutineList,
  ];

  int expandedIndex = -1;

  /// Completed exercise indices (persisted). User taps to mark done.
  Set<int> _completedIndices = {};
  /// Daily recovery checklist indices from same completed-exercises record (preserve on exercise PUT).
  Set<int> _recoveryCompletedIndices = {};
  bool isCompleted(int index) => _completedIndices.contains(index);

  String? _aiMessage;
  String? get aiMessage => _aiMessage;

  /// Total exercise count for the current plan (for API total_exercises).
  int get totalExercises =>
      _morningRoutineList.length + _eveningRoutineList.length;

  /// Toggle exercise done state. Saves to API (with total_exercises).
  Future<void> markExerciseDone(int index) async {
    if (_completedIndices.contains(index)) {
      _completedIndices.remove(index);
    } else {
      _completedIndices.add(index);
    }
    await WorkoutCompletionRepository.instance.saveCompleted(
      DateTime.now(),
      _completedIndices,
      totalExercises: totalExercises,
      recoveryCompletedIndices: _recoveryCompletedIndices,
    );
    notifyListeners();
  }

  /// Expand logic (arrow tap only)
  void toggleExpand(int index) {
    expandedIndex = expandedIndex == index ? -1 : index;
    notifyListeners();
  }

  bool isExpanded(int index) => expandedIndex == index;

  Future<void> setWorkoutData(Map<String, dynamic> data) async {
    try {
      final result = WorkoutResultResponse.fromJson(data);
      _aiMessage = result.aiMessage;
      if (result.aiExercises != null) {
        final ex = result.aiExercises!;
        _morningRoutineList = ex.morning
            .map(
              (e) => {
                'seq': e.seq,
                'time': e.title,
                'activity': e.duration,
                'details': e.steps.isNotEmpty
                    ? e.steps.map((s) => '• $s').join('\n')
                    : '',
              },
            )
            .toList();
        _eveningRoutineList = ex.evening
            .map(
              (e) => {
                'seq': e.seq,
                'time': e.title,
                'activity': e.duration,
                'details': e.steps.isNotEmpty
                    ? e.steps.map((s) => '• $s').join('\n')
                    : '',
              },
            )
            .toList();
      }
      if (_morningRoutineList.isEmpty && _eveningRoutineList.isEmpty) {
        final parsed = _parseFromGeneratePlan(data);
        _morningRoutineList = parsed.morning;
        _eveningRoutineList = parsed.evening;
      }
      expandedIndex = -1;
      final row = await WorkoutCompletionRepository.instance
          .loadCompletedExercises(DateTime.now());
      if (row != null) {
        final list = row['completed_indices'];
        if (list is List) {
          _completedIndices = list
              .map((e) => e is int ? e : int.tryParse(e?.toString() ?? ''))
              .whereType<int>()
              .where((i) => i >= 0)
              .toSet();
        } else {
          _completedIndices = {};
        }
        final rList = row['recovery_completed_indices'];
        _recoveryCompletedIndices = {};
        if (rList is List) {
          for (final e in rList) {
            final i = e is int ? e : int.tryParse(e?.toString() ?? '');
            if (i != null && i >= 0) _recoveryCompletedIndices.add(i);
          }
        }
      } else {
        _completedIndices = {};
        _recoveryCompletedIndices = {};
      }
      notifyListeners();
    } catch (_) {}
  }

  static ({
    List<Map<String, dynamic>> morning,
    List<Map<String, dynamic>> evening,
  })
  _parseFromGeneratePlan(Map<String, dynamic> data) {
    List<Map<String, dynamic>> morning = [];
    List<Map<String, dynamic>> evening = [];
    for (final key in ['morning', 'evening']) {
      final list = data[key];
      if (list is! List) continue;
      final target = key == 'morning' ? morning : evening;
      for (final e in list) {
        if (e is Map) {
          target.add(_mapExercise(Map<String, dynamic>.from(e)));
        }
      }
    }
    if (morning.isEmpty && evening.isEmpty && data['exercises'] is List) {
      for (var i = 0; i < (data['exercises'] as List).length; i++) {
        final e = (data['exercises'] as List)[i];
        if (e is Map) {
          final m = Map<String, dynamic>.from(e);
          m['seq'] ??= i + 1;
          morning.add(_mapExercise(m));
        }
      }
    }
    return (morning: morning, evening: evening);
  }

  static Map<String, dynamic> _mapExercise(Map<String, dynamic> m) {
    final steps = m['steps'] is List
        ? (m['steps'] as List).map((s) => '• $s').join('\n')
        : '';
    final title = m['name'] ?? m['title'] ?? m['time'] ?? '';
    final durSec = m['duration_seconds'];
    String activity =
        m['duration']?.toString() ?? m['activity']?.toString() ?? '';
    if (activity.isEmpty && durSec != null) activity = '${durSec}s';
    if (activity.isEmpty) activity = _formatSetsReps(m);
    final instructions = m['instructions'] ?? m['details'] ?? steps;
    final benefits = m['benefits']?.toString().trim();
    final details = benefits != null && benefits.isNotEmpty
        ? '$instructions\n\nBenefits: $benefits'
        : instructions.toString();
    return {
      'seq': m['seq'] ?? 0,
      'time': title.toString(),
      'activity': activity.toString(),
      'details': details,
    };
  }

  static String _formatSetsReps(Map<String, dynamic> m) {
    final sets = m['sets'];
    final reps = m['reps'];
    if (sets != null && reps != null) return '$sets sets × $reps reps';
    if (sets != null) return '$sets sets';
    if (reps != null) return '$reps reps';
    return '';
  }
}
