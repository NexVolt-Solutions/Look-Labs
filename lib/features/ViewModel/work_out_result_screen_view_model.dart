import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Network/api_response.dart';
import 'package:looklabs/Core/Network/models/workout_result_response.dart';
import 'package:looklabs/Repository/workout_repository.dart';

class WorkOutResultScreenViewModel extends ChangeNotifier {
  List<Map<String, dynamic>> _morningRoutineList = [];
  List<Map<String, dynamic>> _eveningRoutineList = [];
  List<Map<String, dynamic>> get morningRoutineList => _morningRoutineList;
  List<Map<String, dynamic>> get eveningRoutineList => _eveningRoutineList;
  List<Map<String, dynamic>> get heightRoutineList => [
    ..._morningRoutineList,
    ..._eveningRoutineList,
  ];

  int selectedIndex = -1;

  List<Map<String, dynamic>> _gridData = [];
  List<Map<String, dynamic>> get gridData => _gridData;

  List<Map<String, dynamic>> _exData = [];
  List<Map<String, dynamic>> get exData => _exData;

  String _postureInsightTitle = '';
  String _postureInsightMessage = '';
  String get postureInsightTitle => _postureInsightTitle;
  String get postureInsightMessage => _postureInsightMessage;

  /// Combined for backward compatibility (message or "title: message").
  String get postureInsight => _postureInsightTitle.isEmpty
      ? _postureInsightMessage
      : _postureInsightMessage.isEmpty
      ? _postureInsightTitle
      : '$_postureInsightTitle: $_postureInsightMessage';

  String? _screenTitle;
  String? get screenTitle => _screenTitle;

  String? _aiMessage;
  String? get aiMessage => _aiMessage;

  int? _totalExercises;
  int? _totalDurationMin;
  int? get totalExercises => _totalExercises;
  int? get totalDurationMin => _totalDurationMin;

  List<String> _recoveryChecklist = [];
  List<String> get recoveryChecklist => _recoveryChecklist;

  /// Config: API key -> {label, icon, chipSuffix}. Used for dynamic parsing.
  static const Map<String, Map<String, String>> _gridAttributeConfig = {
    'intensity': {'label': 'Intensity', 'icon': AppAssets.electricLightIcon},
    'activity': {'label': 'Activity', 'icon': AppAssets.oirActivityIcon},
    'goal': {'label': 'Goal', 'icon': AppAssets.fireIcon},
    'diet_type': {'label': 'Diet', 'icon': AppAssets.mealIcon},
  };

  /// Selectable options for Intensity and Activity (used for generate-plan).
  static const List<String> intensityOptions = ['Low', 'Moderate', 'High'];
  static const List<String> activityOptions = ['Low', 'Moderate', 'High'];

  /// User-selected values from UI (override ai_attributes when set).
  String? _selectedIntensity;
  String? _selectedActivity;
  String? get selectedIntensity => _selectedIntensity;
  String? get selectedActivity => _selectedActivity;
  static const Set<String> _skipAttributeKeys = {
    'today_focus',
    'posture_insight',
    'workout_summary',
  };

  /// Config: keyword (lowercase) -> icon for Today's Focus. First match wins.
  static const Map<String, String> _todayFocusIconConfig = {
    'flex': AppAssets.flexibilityIcon,
    'strength': AppAssets.muscleBodyIcon,
    'muscle': AppAssets.muscleBodyIcon,
    'endurance': AppAssets.fatLossIcon,
    'fat': AppAssets.fatLossIcon,
  };

  Map<String, dynamic>? _workoutData;
  Map<String, dynamic>? get workoutData => _workoutData;

  /// Set after a successful generate-plan; cleared only when [setWorkoutData] replaces state (!keepExistingPlan).
  /// Avoids calling generate-plan again when popping back from progress if lists/_workoutData look empty.
  bool _activeGeneratePlan = false;

  /// Last focus + intensity + activity used for the stored plan (normalized). [hasGeneratedPlan] only if these match the UI.
  bool _planInputsSnapshotValid = false;
  /// Focus chip index used for the last successful generate-plan (strict match when >= 0).
  int _snapshotFocusIndex = -1;
  String _snapshotFocusNorm = '';
  String _snapshotIntensityNorm = '';
  String _snapshotActivityNorm = '';

  void _clearPlanInputsSnapshot() {
    _planInputsSnapshotValid = false;
    _snapshotFocusIndex = -1;
    _snapshotFocusNorm = '';
    _snapshotIntensityNorm = '';
    _snapshotActivityNorm = '';
  }

  void _setPlanInputsSnapshot({
    int focusIndexAtGenerate = -1,
    required String focusNorm,
    required String intensityNorm,
    required String activityNorm,
  }) {
    _planInputsSnapshotValid = true;
    _snapshotFocusIndex = focusIndexAtGenerate;
    _snapshotFocusNorm = focusNorm;
    _snapshotIntensityNorm = intensityNorm;
    _snapshotActivityNorm = activityNorm;
  }

  bool _planInputsMatchSnapshot() {
    if (!_planInputsSnapshotValid) return false;
    // Continue only when a focus chip is selected; avoids ''=='' matching with empty snapshot.
    if (selectedIndex < 0 || selectedIndex >= _exData.length) return false;
    final curFocus =
        (_exData[selectedIndex]['title']?.toString() ?? '').trim().toLowerCase();
    if (curFocus.isEmpty || curFocus != _snapshotFocusNorm) return false;
    if (_snapshotFocusIndex >= 0 && selectedIndex != _snapshotFocusIndex) {
      return false;
    }
    final curI =
        (_selectedIntensity ?? intensityOptions.first).toLowerCase().trim();
    final curA =
        (_selectedActivity ?? activityOptions.first).toLowerCase().trim();
    return curI == _snapshotIntensityNorm && curA == _snapshotActivityNorm;
  }

  /// True when merged exercise/plan content exists (inputs may still require regenerate).
  bool get _hasPlanPayload =>
      _activeGeneratePlan ||
      _dataHasPlan(_workoutData ?? {}) ||
      _morningRoutineList.isNotEmpty ||
      _eveningRoutineList.isNotEmpty ||
      (_totalExercises != null && _totalExercises! > 0);

  bool _getStartedLoading = false;
  bool _tileLoading = false;
  bool get getStartedLoading => _getStartedLoading;
  bool get tileLoading => _tileLoading;

  /// True when either control is loading (for optional shared disable; each control uses its own loading getter).
  bool get generatePlanLoading => _getStartedLoading || _tileLoading;

  /// Pass to [generateWorkoutPlan] so loading shows on the correct control.
  static const String loadingSourceGetStarted = 'get_started';
  static const String loadingSourceTile = 'tile';

  /// Calls POST domains/workout/generate-plan with params from workoutData.
  /// [selectedFocusIndex] overrides focus with exData[selectedFocusIndex].title when >= 0.
  /// [loadingSource] must be [loadingSourceGetStarted] or [loadingSourceTile] so loading is shown on the correct control.
  /// Returns API response. Updates totalExercises/totalDurationMin from response.
  Future<ApiResponse> generateWorkoutPlan({
    int selectedFocusIndex = -1,
    String loadingSource = loadingSourceGetStarted,
  }) async {
    // Block only the same control from firing again; the other can call API separately.
    if (loadingSource == loadingSourceTile) {
      if (_tileLoading) return ApiResponse(success: false, statusCode: 0);
      _tileLoading = true;
    } else {
      if (_getStartedLoading) return ApiResponse(success: false, statusCode: 0);
      _getStartedLoading = true;
    }
    notifyListeners();

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
        _capturePlanInputsSnapshotAfterGenerate(
          selectedFocusIndex: selectedFocusIndex,
          focusOverrideSent: focusOverride,
          response: map,
        );
      }
    } finally {
      if (loadingSource == loadingSourceTile) {
        _tileLoading = false;
      } else {
        _getStartedLoading = false;
      }
      notifyListeners();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
    return response;
  }

  void _updateFromGeneratePlanResponse(Map<String, dynamic> data) {
    // Parse exercises count and duration from generate-plan response.
    // API returns exercise_count, duration_minutes OR total_exercises, total_duration_min.
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
    // Merge exercises into workoutData for DailyWorkoutRoutineScreen
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
    if (mergedLists || hasExerciseCount) {
      _activeGeneratePlan = true;
    }
  }

  static ({
    List<Map<String, dynamic>> morning,
    List<Map<String, dynamic>> evening,
  })
  _parseExercisesFromPlan(Map<String, dynamic> data) {
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
    String activity =
        m['duration']?.toString() ?? m['activity']?.toString() ?? '';
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

  /// Icon for Today's Focus item. Uses config; unknown items get default icon.
  static String _iconForFocus(String title) {
    final t = title.toLowerCase();
    for (final entry in _todayFocusIconConfig.entries) {
      if (t.contains(entry.key)) return entry.value;
    }
    return AppAssets.actionWorkOutIcon;
  }

  /// Build exData (Today's Focus) dynamically from ai_attributes.today_focus.
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

  /// Build gridData dynamically from ai_attributes. Uses config for known keys,
  /// humanizes unknown keys. Skips today_focus, posture_insight, workout_summary.
  static List<Map<String, dynamic>> _buildGridDataFromAttributes(
    Map<String, dynamic>? attrs,
  ) {
    if (attrs == null) return [];
    final list = <Map<String, dynamic>>[];
    final seen = <String>{};
    for (final key in _gridAttributeConfig.keys) {
      if (!attrs.containsKey(key)) continue;
      final val = attrs[key];
      if (val == null || val is Map || val is List) continue;
      final str = val.toString().trim();
      if (str.isEmpty) continue;
      seen.add(key);
      final cfg = _gridAttributeConfig[key]!;
      list.add({
        'title': cfg['label'] ?? _humanizeKey(key),
        'subtitle': str,
        'image': cfg['icon'] ?? AppAssets.actionWorkOutIcon,
      });
    }
    for (final e in attrs.entries) {
      final key = e.key.toString();
      if (seen.contains(key) || _skipAttributeKeys.contains(key)) continue;
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

  /// True if we have plan data (from a previous generate-plan), so flow-only updates should not overwrite it.
  bool get _hasExistingPlan =>
      _morningRoutineList.isNotEmpty ||
      _eveningRoutineList.isNotEmpty ||
      (_totalExercises != null && _totalExercises! > 0);

  /// True when a plan exists and current focus + intensity + activity match the last generate (or seeded plan).
  bool get hasGeneratedPlan =>
      _hasPlanPayload && _planInputsMatchSnapshot();

  /// True if [data] contains exercise/plan content (from generate-plan), not just flow response.
  static bool _dataHasPlan(Map<String, dynamic> data) {
    if (data['ai_exercises'] != null) return true;
    if (data['exercises'] is List && (data['exercises'] as List).isNotEmpty) {
      return true;
    }
    if (data['morning'] is List && (data['morning'] as List).isNotEmpty) {
      return true;
    }
    if (data['evening'] is List && (data['evening'] as List).isNotEmpty) {
      return true;
    }
    return false;
  }

  /// Load from API response (ai_attributes, ai_exercises, ai_message, ai_progress).
  /// When incoming data is flow-only (no exercises), preserves existing plan so counts and navigation stay correct.
  void setWorkoutData(Map<String, dynamic> data) {
    try {
      final result = WorkoutResultResponse.fromJson(data);
      final incomingHasPlan = _dataHasPlan(data);
      final keepExistingPlan = _hasExistingPlan && !incomingHasPlan;

      if (!keepExistingPlan) {
        _activeGeneratePlan = false;
        _clearPlanInputsSnapshot();
        _workoutData = data;
      }

      // Grid: dynamic from ai_attributes
      final attrs = data['ai_attributes'];
      _gridData = _buildGridDataFromAttributes(
        attrs is Map ? Map<String, dynamic>.from(attrs) : null,
      );

      // Today's Focus: dynamic from ai_attributes.today_focus
      _exData = _buildTodayFocusFromApi(
        attrs is Map ? Map<String, dynamic>.from(attrs) : null,
      );

      // Screen title, posture_insight from ai_attributes
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
            if (ws.totalExercises != null) {
              _totalExercises = ws.totalExercises;
            }
            if (ws.totalDurationMin != null) {
              _totalDurationMin = ws.totalDurationMin;
            }
          }
        }
        _selectedIntensity =
            _matchOption(a.intensity?.trim(), intensityOptions) ??
            intensityOptions.first;
        _selectedActivity =
            _matchOption(a.activity?.trim(), activityOptions) ??
            activityOptions.first;
      }

      if (result.aiProgress != null) {
        _recoveryChecklist = result.aiProgress!.recoveryChecklist;
      } else {
        _recoveryChecklist = [];
      }

      // Routine and plan counts: only overwrite when incoming data has plan
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
      } else if (!keepExistingPlan) {
        _morningRoutineList = [];
        _eveningRoutineList = [];
      }

      if (result.aiMessage != null && result.aiMessage!.isNotEmpty) {
        _aiMessage = result.aiMessage;
      }

      if (!keepExistingPlan) {
        if (incomingHasPlan) {
          _seedPlanSnapshotFromIncoming(data);
          _selectIndexMatchingSnapshotFocus();
        } else {
          selectedIndex = -1;
        }
      }
      notifyListeners();
    } catch (_) {}
  }

  void _capturePlanInputsSnapshotAfterGenerate({
    required int selectedFocusIndex,
    required String? focusOverrideSent,
    required Map<String, dynamic> response,
  }) {
    final focusNorm = _resolvedFocusSnapshotNorm(
      response,
      focusOverrideSent?.trim(),
    );
    final idx = (selectedFocusIndex >= 0 && selectedFocusIndex < _exData.length)
        ? selectedFocusIndex
        : -1;
    _setPlanInputsSnapshot(
      focusIndexAtGenerate: idx,
      focusNorm: focusNorm,
      intensityNorm:
          (_selectedIntensity ?? intensityOptions.first).toLowerCase().trim(),
      activityNorm:
          (_selectedActivity ?? activityOptions.first).toLowerCase().trim(),
    );
  }

  String _resolvedFocusSnapshotNorm(
    Map<String, dynamic> response,
    String? focusOverride,
  ) {
    if (focusOverride != null && focusOverride.isNotEmpty) {
      return focusOverride.toLowerCase().trim();
    }
    final api = response['focus']?.toString().trim().toLowerCase() ?? '';
    for (final row in _exData) {
      final t = (row['title']?.toString() ?? '').trim().toLowerCase();
      if (api.isEmpty) continue;
      final apiSpaced = api.replaceAll('_', ' ');
      if (t.replaceAll(' ', '_') == api || t == apiSpaced) return t;
    }
    if (api.isNotEmpty) return api.replaceAll('_', ' ').trim();
    if (_exData.isNotEmpty) {
      return (_exData.first['title']?.toString() ?? '').trim().toLowerCase();
    }
    return '';
  }

  String? _inferFocusFromIncoming(Map<String, dynamic> data) {
    final top = data['focus']?.toString().trim();
    if (top != null && top.isNotEmpty) return top;
    final attrs = data['ai_attributes'];
    if (attrs is Map && attrs['today_focus'] is List) {
      final l = attrs['today_focus'] as List;
      for (final e in l) {
        final s = e?.toString().trim();
        if (s != null && s.isNotEmpty) return s;
      }
    }
    return null;
  }

  void _seedPlanSnapshotFromIncoming(Map<String, dynamic> data) {
    final inferred = _inferFocusFromIncoming(data);
    final focusNorm = _resolvedFocusSnapshotNorm(data, inferred);
    var idx = -1;
    for (var i = 0; i < _exData.length; i++) {
      final t = (_exData[i]['title']?.toString() ?? '').trim().toLowerCase();
      if (t == focusNorm) {
        idx = i;
        break;
      }
    }
    _setPlanInputsSnapshot(
      focusIndexAtGenerate: idx,
      focusNorm: focusNorm,
      intensityNorm:
          (_selectedIntensity ?? intensityOptions.first).toLowerCase().trim(),
      activityNorm:
          (_selectedActivity ?? activityOptions.first).toLowerCase().trim(),
    );
  }

  void _selectIndexMatchingSnapshotFocus() {
    if (_snapshotFocusNorm.isEmpty) return;
    for (var i = 0; i < _exData.length; i++) {
      final t = (_exData[i]['title']?.toString() ?? '').trim().toLowerCase();
      if (t == _snapshotFocusNorm) {
        selectedIndex = i;
        return;
      }
    }
  }

  void selectExercise(int index) {
    selectedIndex = selectedIndex == index ? -1 : index;
    notifyListeners();
  }

  bool isSelected(int index) => selectedIndex == index;

  void selectIntensity(String value) {
    if (intensityOptions.contains(value)) {
      _selectedIntensity = value;
      notifyListeners();
    }
  }

  void selectActivity(String value) {
    if (activityOptions.contains(value)) {
      _selectedActivity = value;
      notifyListeners();
    }
  }

  bool isIntensitySelected(String value) =>
      (_selectedIntensity ?? '').toLowerCase() == value.toLowerCase();

  bool isActivitySelected(String value) =>
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
