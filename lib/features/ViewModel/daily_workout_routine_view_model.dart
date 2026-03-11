import 'package:flutter/material.dart';
import 'package:looklabs/Core/Network/models/workout_result_response.dart';

class DailyWorkoutRoutineViewModel extends ChangeNotifier {
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

  String? _aiMessage;
  String? get aiMessage => _aiMessage;

  void selectPlan(int index) {
    selectedIndex = selectedIndex == index ? -1 : index;
    notifyListeners();
  }

  /// ⬇️ Expand logic (arrow tap only)
  void toggleExpand(int index) {
    expandedIndex = expandedIndex == index ? -1 : index;
    notifyListeners();
  }

  bool isPlanSelected(int index) => selectedIndex == index;
  bool isExpanded(int index) => expandedIndex == index;

  void selectExercise(int index) {
    selectedIndex = selectedIndex == index ? -1 : index;
    notifyListeners();
  }

  bool isSelected(int index) => selectedIndex == index;

  /// Load from API response (ai_exercises, ai_message).
  void setWorkoutData(Map<String, dynamic> data) {
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
      expandedIndex = -1;
      selectedIndex = -1;
      notifyListeners();
    } catch (_) {}
  }
}
