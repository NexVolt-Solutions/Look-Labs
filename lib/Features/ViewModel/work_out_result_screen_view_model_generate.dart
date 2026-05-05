part of 'work_out_result_screen_view_model.dart';

extension _WorkOutResultGenerate on WorkOutResultScreenViewModel {
  Future<ApiResponse> _generateWorkoutPlan({
    int selectedFocusIndex = -1,
    String loadingSource = WorkOutResultScreenViewModel.loadingSourceGetStarted,
  }) async {
    if (loadingSource == WorkOutResultScreenViewModel.loadingSourceTile) {
      if (_tileLoading) return ApiResponse(success: false, statusCode: 0);
      _tileLoading = true;
    } else {
      if (_getStartedLoading) return ApiResponse(success: false, statusCode: 0);
      _getStartedLoading = true;
    }
    _notify();

    ApiResponse response;
    try {
      String? focusOverride;
      if (selectedFocusIndex >= 0 &&
          selectedFocusIndex < _exData.length &&
          _exData[selectedFocusIndex]['title'] != null) {
        focusOverride = _exData[selectedFocusIndex]['title'] as String;
      }

      response = await WorkoutRepository.instance.generateWorkoutPlan(
        workoutData: _workoutData,
        focusOverride: focusOverride,
        intensityOverride: _selectedIntensity,
        activityOverride: _selectedActivity,
      );

      if (response.success && response.data is Map) {
        final map = Map<String, dynamic>.from(response.data as Map);
        _updateFromGeneratePlanResponse(map);
      }
    } finally {
      if (loadingSource == WorkOutResultScreenViewModel.loadingSourceTile) {
        _tileLoading = false;
      } else {
        _getStartedLoading = false;
      }
      _notify();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _notify();
      });
    }
    return response;
  }

  void _updateFromGeneratePlanResponse(Map<String, dynamic> data) {
    int? totalEx = data['total_exercises'] is int
        ? data['total_exercises'] as int
        : data['exercise_count'] is int
            ? data['exercise_count'] as int
            : int.tryParse(data['total_exercises']?.toString() ?? '') ??
                int.tryParse(data['exercise_count']?.toString() ?? '');
    int? totalDur = data['total_duration_min'] is int
        ? data['total_duration_min'] as int
        : data['duration_minutes'] is int
            ? data['duration_minutes'] as int
            : int.tryParse(data['total_duration_min']?.toString() ?? '') ??
                int.tryParse(data['duration_minutes']?.toString() ?? '');
    if (totalEx == null && data['exercises'] is List) {
      totalEx = (data['exercises'] as List).length;
    }
    if (totalEx != null) _totalExercises = totalEx;
    if (totalDur != null) _totalDurationMin = totalDur;
    var mergedLists = false;
    if (data['exercises'] is List ||
        data['morning'] is List ||
        data['evening'] is List) {
      _workoutData = {...?_workoutData, ...data};
      final ex = _parseExercisesFromPlan(data);
      _morningRoutineList = ex.morning;
      _eveningRoutineList = ex.evening;
      mergedLists = true;
    }
    final hasExerciseCount = totalEx != null && totalEx > 0;
    if (mergedLists || hasExerciseCount) {}
  }

  static ({
    List<Map<String, dynamic>> morning,
    List<Map<String, dynamic>> evening,
  }) _parseExercisesFromPlan(Map<String, dynamic> data) {
    List<Map<String, dynamic>> morning = [];
    List<Map<String, dynamic>> evening = [];
    if (data['morning'] is List) {
      for (final e in data['morning'] as List) {
        if (e is Map) {
          morning.add(_exerciseMap(e));
        }
      }
    }
    if (data['evening'] is List) {
      for (final e in data['evening'] as List) {
        if (e is Map) {
          evening.add(_exerciseMap(e));
        }
      }
    }
    if (morning.isEmpty && evening.isEmpty && data['exercises'] is List) {
      for (final e in data['exercises'] as List) {
        if (e is Map) {
          morning.add(_exerciseMap(e));
        }
      }
    }
    return (morning: morning, evening: evening);
  }

  static Map<String, dynamic> _exerciseMap(dynamic e) {
    final m = Map<String, dynamic>.from(e as Map);
    final steps = m['steps'] is List
        ? (m['steps'] as List).map((s) => '• $s').join('\n')
        : '';
    final title = m['name'] ?? m['title'] ?? m['time'] ?? '';
    final durSec = m['duration_seconds'];
    String activity = m['duration']?.toString() ?? m['activity']?.toString() ?? '';
    if (activity.isEmpty && durSec != null) activity = '${durSec}s';
    if (activity.isEmpty) activity = _formatSetsReps(m);
    final details = m['instructions'] ?? m['details'] ?? steps;
    return {
      'seq': m['seq'] ?? 0,
      'time': title.toString(),
      'activity': activity.toString(),
      'details': details.toString(),
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
