import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Network/api_response.dart';
import 'package:looklabs/Core/Network/models/workout_result_response.dart';
import 'package:looklabs/Repository/workout_repository.dart';

part 'work_out_result_screen_view_model_generate.dart';
part 'work_out_result_screen_view_model_mapping.dart';

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

  bool get _hasExistingPlan =>
      _morningRoutineList.isNotEmpty ||
      _eveningRoutineList.isNotEmpty ||
      (_totalExercises != null && _totalExercises! > 0);

  bool get hasGeneratedPlan => _hasExistingPlan;

  bool _getStartedLoading = false;
  bool _tileLoading = false;
  bool get getStartedLoading => _getStartedLoading;
  bool get tileLoading => _tileLoading;

  /// True when either control is loading (for optional shared disable; each control uses its own loading getter).
  bool get generatePlanLoading => _getStartedLoading || _tileLoading;

  void _notify() => notifyListeners();

  /// Pass to [generateWorkoutPlan] so loading shows on the correct control.
  static const String loadingSourceGetStarted = 'get_started';
  static const String loadingSourceTile = 'tile';

  Future<ApiResponse> generateWorkoutPlan({
    int selectedFocusIndex = -1,
    String loadingSource = loadingSourceGetStarted,
  }) => _generateWorkoutPlan(
    selectedFocusIndex: selectedFocusIndex,
    loadingSource: loadingSource,
  );

  void setWorkoutData(Map<String, dynamic> data) => _setWorkoutData(data);

  void selectExercise(int index) => _selectExercise(index);
  bool isSelected(int index) => _isSelected(index);

  void selectIntensity(String value) => _selectIntensity(value);
  void selectActivity(String value) => _selectActivity(value);

  bool isIntensitySelected(String value) => _isIntensitySelected(value);
  bool isActivitySelected(String value) => _isActivitySelected(value);


}
