import 'package:flutter/material.dart';
import 'package:looklabs/Core/Network/models/height_routine_lists.dart';
import 'package:looklabs/Repository/height_routine_repository.dart';

/// State for height result: parsed routine lists + per-screen selection/expand for exercise tiles.
class HeightScreenViewModel extends ChangeNotifier {
  List<Map<String, dynamic>> morningRoutineList = [];
  List<Map<String, dynamic>> eveningRoutineList = [];

  List<Map<String, dynamic>> get heightRoutineList => [
        ...morningRoutineList,
        ...eveningRoutineList,
      ];

  int selectedIndex = -1;
  int expandedIndex = -1;

  void _clearSelection() {
    selectedIndex = -1;
    expandedIndex = -1;
  }

  /// Apply domain flow completion payload (`ai_exercises`, etc.).
  void applyApiResult(Map<String, dynamic>? data) {
    final lists = HeightRoutineRepository.parseRoutineLists(data);
    morningRoutineList = lists.morning;
    eveningRoutineList = lists.evening;
    _clearSelection();
    notifyListeners();
  }

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

  /// Payload for [DailyHeightRoutineScreen] when route args omit full JSON.
  Map<String, dynamic> dailyRoutineNavigationPayload() {
    return HeightRoutineRepository.dailyRoutinePayloadFromLists(
      HeightRoutineLists(morning: morningRoutineList, evening: eveningRoutineList),
    );
  }
}
