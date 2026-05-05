part of 'work_out_result_screen_view_model.dart';

extension _WorkOutResultMapping on WorkOutResultScreenViewModel {
  static String _iconForFocus(String title) {
    final t = title.toLowerCase();
    for (final entry in WorkOutResultScreenViewModel._todayFocusIconConfig.entries) {
      if (t.contains(entry.key)) return entry.value;
    }
    return AppAssets.actionWorkOutIcon;
  }

  static List<Map<String, dynamic>> _buildTodayFocusFromApi(
    Map<String, dynamic>? attrs,
  ) {
    if (attrs == null) return [];
    final raw = attrs['today_focus'];
    if (raw is! List) return [];
    final list = <Map<String, dynamic>>[];
    for (final e in raw) {
      if (e == null) continue;
      final str = e.toString().trim();
      if (str.isEmpty) continue;
      list.add({'title': str, 'image': _iconForFocus(str)});
    }
    return list;
  }

  static String _humanizeKey(String key) {
    return key
        .split('_')
        .map((s) => s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}')
        .join(' ');
  }

  static List<Map<String, dynamic>> _buildGridDataFromAttributes(
    Map<String, dynamic>? attrs,
  ) {
    if (attrs == null) return [];
    final list = <Map<String, dynamic>>[];
    final seen = <String>{};
    for (final key in WorkOutResultScreenViewModel._gridAttributeConfig.keys) {
      if (!attrs.containsKey(key)) continue;
      final val = attrs[key];
      if (val == null || val is Map || val is List) continue;
      final str = val.toString().trim();
      if (str.isEmpty) continue;
      seen.add(key);
      final cfg = WorkOutResultScreenViewModel._gridAttributeConfig[key]!;
      list.add({
        'title': cfg['label'] ?? _humanizeKey(key),
        'subtitle': str,
        'image': cfg['icon'] ?? AppAssets.actionWorkOutIcon,
      });
    }
    for (final e in attrs.entries) {
      final key = e.key.toString();
      if (seen.contains(key) || WorkOutResultScreenViewModel._skipAttributeKeys.contains(key)) continue;
      final val = e.value;
      if (val == null || val is Map || val is List) continue;
      final str = val.toString().trim();
      if (str.isEmpty) continue;
      list.add({
        'title': _humanizeKey(key),
        'subtitle': str,
        'image': AppAssets.actionWorkOutIcon,
      });
    }
    return list;
  }

  static bool _dataHasPlan(Map<String, dynamic> data) {
    if (data['ai_exercises'] != null) return true;
    if (data['exercises'] is List && (data['exercises'] as List).isNotEmpty) return true;
    if (data['morning'] is List && (data['morning'] as List).isNotEmpty) return true;
    if (data['evening'] is List && (data['evening'] as List).isNotEmpty) return true;
    return false;
  }

  void _setWorkoutData(Map<String, dynamic> data) {
    try {
      final result = WorkoutResultResponse.fromJson(data);
      final incomingHasPlan = _dataHasPlan(data);
      final keepExistingPlan = _hasExistingPlan && !incomingHasPlan;

      if (!keepExistingPlan) {
        _workoutData = data;
      }

      final attrs = data['ai_attributes'];
      _gridData = _buildGridDataFromAttributes(
        attrs is Map ? Map<String, dynamic>.from(attrs) : null,
      );
      _exData = _buildTodayFocusFromApi(
        attrs is Map ? Map<String, dynamic>.from(attrs) : null,
      );

      if (result.aiAttributes != null) {
        final a = result.aiAttributes!;
        _screenTitle = a.title?.trim().isNotEmpty == true ? a.title : null;
        if (a.postureInsight != null) {
          _postureInsightTitle = a.postureInsight!.title;
          _postureInsightMessage = a.postureInsight!.message;
        }
        if (!keepExistingPlan) {
          _totalExercises = null;
          _totalDurationMin = null;
          final ws = a.workoutSummary;
          if (ws != null) {
            if (ws.totalExercises != null) _totalExercises = ws.totalExercises;
            if (ws.totalDurationMin != null) _totalDurationMin = ws.totalDurationMin;
          }
        }
        _selectedIntensity =
            _matchOption(a.intensity?.trim(), WorkOutResultScreenViewModel.intensityOptions) ?? WorkOutResultScreenViewModel.intensityOptions.first;
        _selectedActivity =
            _matchOption(a.activity?.trim(), WorkOutResultScreenViewModel.activityOptions) ?? WorkOutResultScreenViewModel.activityOptions.first;
      }

      if (result.aiProgress != null) {
        _recoveryChecklist = result.aiProgress!.recoveryChecklist;
      } else {
        _recoveryChecklist = [];
      }

      if (result.aiExercises != null) {
        final ex = result.aiExercises!;
        _morningRoutineList = ex.morning.map(_routineRowFromExercise).toList();
        _eveningRoutineList = ex.evening.map(_routineRowFromExercise).toList();
      } else if (!keepExistingPlan) {
        _morningRoutineList = [];
        _eveningRoutineList = [];
      }

      if (result.aiMessage != null && result.aiMessage!.isNotEmpty) {
        _aiMessage = result.aiMessage;
      }

      if (!keepExistingPlan) {
        selectedIndex = -1;
      }
      _notify();
    } catch (_) {}
  }

  static Map<String, dynamic> _routineRowFromExercise(WorkoutExercise e) {
    return {
      'seq': e.seq,
      'time': e.title,
      'activity': e.duration,
      'details': e.steps.isNotEmpty ? e.steps.map((s) => '• $s').join('\n') : '',
    };
  }

  void _selectExercise(int index) {
    selectedIndex = selectedIndex == index ? -1 : index;
    _notify();
  }

  bool _isSelected(int index) => selectedIndex == index;

  void _selectIntensity(String value) {
    if (WorkOutResultScreenViewModel.intensityOptions.contains(value)) {
      _selectedIntensity = value;
      _notify();
    }
  }

  void _selectActivity(String value) {
    if (WorkOutResultScreenViewModel.activityOptions.contains(value)) {
      _selectedActivity = value;
      _notify();
    }
  }

  bool _isIntensitySelected(String value) =>
      (_selectedIntensity ?? '').toLowerCase() == value.toLowerCase();

  bool _isActivitySelected(String value) =>
      (_selectedActivity ?? '').toLowerCase() == value.toLowerCase();

  static String? _matchOption(String? val, List<String> options) {
    if (val == null || val.isEmpty) return null;
    final lower = val.toLowerCase();
    for (final o in options) {
      if (o.toLowerCase() == lower) return o;
    }
    return null;
  }
}
