import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
  int expandedIndex = -1;

  void selectPlan(int index) {
    selectedIndex = selectedIndex == index ? -1 : index;
    notifyListeners();
  }

  void toggleExpand(int index) {
    expandedIndex = expandedIndex == index ? -1 : index;
    notifyListeners();
  }

  bool isPlanSelected(int index) => selectedIndex == index;
  bool isExpanded(int index) => expandedIndex == index;

  List<Map<String, dynamic>> _gridData = [];
  List<Map<String, dynamic>> get gridData => _gridData;

  List<Map<String, dynamic>> _exData = [];
  List<Map<String, dynamic>> get exData => _exData;

  String _postureInsight = '';
  String get postureInsight => _postureInsight;

  String? _aiMessage;
  String? get aiMessage => _aiMessage;

  int? _totalExercises;
  int? _totalDurationMin;
  int? get totalExercises => _totalExercises;
  int? get totalDurationMin => _totalDurationMin;

  String? _weeklyCalories;
  String? _consistency;
  String? _strengthGain;
  String? _fitnessConsistency;
  List<String> _recoveryChecklist = [];
  String? get weeklyCalories => _weeklyCalories;
  String? get consistency => _consistency;
  String? get strengthGain => _strengthGain;
  String? get fitnessConsistency => _fitnessConsistency;
  List<String> get recoveryChecklist => _recoveryChecklist;

  Map<String, dynamic>? _workoutData;
  Map<String, dynamic>? get workoutData => _workoutData;

  bool _generatePlanLoading = false;
  bool get generatePlanLoading => _generatePlanLoading;

  /// Calls POST domains/workout/generate-plan with params from workoutData.
  /// Returns API response. Navigate on success; show error on failure.
  Future<ApiResponse> generateWorkoutPlan() async {
    if (_generatePlanLoading) {
      return ApiResponse(success: false, statusCode: 0);
    }
    _generatePlanLoading = true;
    notifyListeners();

    final response = await WorkoutRepository.instance.generateWorkoutPlan(
      workoutData: _workoutData,
    );

    _generatePlanLoading = false;
    // Defer notifyListeners to avoid "setState during build"
    SchedulerBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
    return response;
  }

  static String _iconForFocus(String title) {
    final t = title.toLowerCase();
    if (t.contains('flex')) return AppAssets.flexibilityIcon;
    if (t.contains('muscle') || t.contains('strength'))
      return AppAssets.muscleBodyIcon;
    if (t.contains('fat') || t.contains('endurance'))
      return AppAssets.fatLossIcon;
    return AppAssets.actionWorkOutIcon;
  }

  /// Load from API response (ai_attributes, ai_exercises, ai_message, ai_progress).
  void setWorkoutData(Map<String, dynamic> data) {
    try {
      _workoutData = data;
      final result = WorkoutResultResponse.fromJson(data);

      // Grid: Intensity, Activity from ai_attributes (only when present)
      if (result.aiAttributes != null) {
        final a = result.aiAttributes!;
        _gridData = [];
        if (a.intensity != null && a.intensity!.isNotEmpty) {
          _gridData.add({
            'title': 'Intensity',
            'subtitle': a.intensity!,
            'image': AppAssets.electricLightIcon,
          });
        }
        if (a.activity != null && a.activity!.isNotEmpty) {
          _gridData.add({
            'title': 'Activity',
            'subtitle': a.activity!,
            'image': AppAssets.oirActivityIcon,
          });
        }
        if (a.postureInsight != null && a.postureInsight!.isNotEmpty) {
          _postureInsight = a.postureInsight!;
        }
        // Today's focus from ai_attributes.today_focus
        if (a.todayFocus.isNotEmpty) {
          _exData = a.todayFocus
              .map((t) => {'title': t, 'image': _iconForFocus(t)})
              .toList();
        }
        if (a.workoutSummary != null) {
          _totalExercises = a.workoutSummary!.totalExercises;
          _totalDurationMin = a.workoutSummary!.totalDurationMin;
        }
      }

      if (result.aiProgress != null) {
        final p = result.aiProgress!;
        _weeklyCalories = p.weeklyCalories;
        _consistency = p.consistency;
        _strengthGain = p.strengthGain;
        _fitnessConsistency = p.fitnessConsistency;
        _recoveryChecklist = p.recoveryChecklist;
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

      expandedIndex = -1;
      selectedIndex = -1;
      notifyListeners();
    } catch (_) {}
  }

  void selectExercise(int index) {
    selectedIndex = selectedIndex == index ? -1 : index;
    notifyListeners();
  }

  bool isSelected(int index) => selectedIndex == index;
}
