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

  List<String> _progressChips = [];
  List<String> _recoveryChecklist = [];
  List<String> get progressChips => _progressChips;
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
  static const Map<String, Map<String, String>> _progressChipConfig = {
    'weekly_calories': {'label': 'Calories', 'suffix': ' cal'},
    'consistency': {'label': 'Consistency'},
    'strength_gain': {'label': 'Strength'},
    'fitness_consistency': {'label': 'Fitness'},
  };
  static const Set<String> _skipAttributeKeys = {
    'today_focus',
    'posture_insight',
    'workout_summary',
  };
  static const Set<String> _skipProgressKeys = {'recovery_checklist'};

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

  bool _generatePlanLoading = false;
  bool get generatePlanLoading => _generatePlanLoading;

  /// Calls POST domains/workout/generate-plan with params from workoutData.
  /// [selectedFocusIndex] overrides focus with exData[selectedFocusIndex].title when >= 0.
  /// Returns API response. Updates totalExercises/totalDurationMin from response.
  Future<ApiResponse> generateWorkoutPlan({int selectedFocusIndex = -1}) async {
    if (_generatePlanLoading) {
      return ApiResponse(success: false, statusCode: 0);
    }
    _generatePlanLoading = true;
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
        _updateFromGeneratePlanResponse(
          Map<String, dynamic>.from(response.data as Map),
        );
      }
    } finally {
      _generatePlanLoading = false;
      notifyListeners();
      // Ensure UI updates after async callback; schedule for next frame.
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
    if (data['exercises'] is List ||
        data['morning'] is List ||
        data['evening'] is List) {
      _workoutData = {...?_workoutData, ...data};
      final ex = _parseExercisesFromPlan(data);
      _morningRoutineList = ex.morning;
      _eveningRoutineList = ex.evening;
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

  /// Build progress chips dynamically from ai_progress. Uses config for suffix.
  /// Skips recovery_checklist. Order: config keys first, then any extra API keys.
  static List<String> _buildProgressChipsFromApi(
    Map<String, dynamic>? progress,
  ) {
    if (progress == null) return [];
    final list = <String>[];
    final seen = <String>{};
    for (final key in _progressChipConfig.keys) {
      if (!progress.containsKey(key)) continue;
      final val = progress[key];
      if (val == null || val is Map || val is List) continue;
      final str = val.toString().trim();
      if (str.isEmpty) continue;
      seen.add(key);
      final cfg = _progressChipConfig[key];
      final suffix = cfg?['suffix'] ?? '';
      list.add('$str$suffix');
    }
    for (final e in progress.entries) {
      final key = e.key.toString();
      if (seen.contains(key) || _skipProgressKeys.contains(key)) continue;
      final val = e.value;
      if (val == null || val is Map || val is List) continue;
      final str = val.toString().trim();
      if (str.isEmpty) continue;
      list.add(str);
    }
    return list;
  }

  /// Load from API response (ai_attributes, ai_exercises, ai_message, ai_progress).
  void setWorkoutData(Map<String, dynamic> data) {
    try {
      _workoutData = data;
      final result = WorkoutResultResponse.fromJson(data);

      // Grid: dynamic from ai_attributes
      final attrs = data['ai_attributes'];
      _gridData = _buildGridDataFromAttributes(
        attrs is Map ? Map<String, dynamic>.from(attrs) : null,
      );

      // Today's Focus: dynamic from ai_attributes.today_focus
      _exData = _buildTodayFocusFromApi(
        attrs is Map ? Map<String, dynamic>.from(attrs) : null,
      );

      // Screen title, posture_insight from ai_attributes (workout_summary removed)
      if (result.aiAttributes != null) {
        final a = result.aiAttributes!;
        _screenTitle = a.title?.trim().isNotEmpty == true ? a.title : null;
        if (a.postureInsight != null) {
          _postureInsightTitle = a.postureInsight!.title;
          _postureInsightMessage = a.postureInsight!.message;
        }
        // totalExercises/totalDurationMin come from generate-plan, not workout_summary
        _totalExercises = null;
        _totalDurationMin = null;
        // Pre-select intensity/activity from ai_attributes (match our options)
        _selectedIntensity =
            _matchOption(a.intensity?.trim(), intensityOptions) ??
            intensityOptions.first;
        _selectedActivity =
            _matchOption(a.activity?.trim(), activityOptions) ??
            activityOptions.first;
      }

      // Progress chips: dynamic from ai_progress
      final prog = data['ai_progress'];
      _progressChips = _buildProgressChipsFromApi(
        prog is Map ? Map<String, dynamic>.from(prog) : null,
      );
      if (result.aiProgress != null) {
        _recoveryChecklist = result.aiProgress!.recoveryChecklist;
      }

      // Routine: morning + evening exercises from ai_exercises
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

      if (result.aiMessage != null && result.aiMessage!.isNotEmpty) {
        _aiMessage = result.aiMessage;
      }

      selectedIndex = -1;
      notifyListeners();
    } catch (_) {}
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
