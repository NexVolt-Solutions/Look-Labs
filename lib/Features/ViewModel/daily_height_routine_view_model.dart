import 'package:flutter/material.dart';
import 'package:looklabs/Repository/height_routine_repository.dart';
import 'package:looklabs/Repository/workout_completion_repository.dart';

class DailyHeightRoutineViewModel extends ChangeNotifier {
  List<Map<String, dynamic>> morningRoutineList = [];
  List<Map<String, dynamic>> eveningRoutineList = [];

  List<Map<String, dynamic>> get heightRoutineList => [
        ...morningRoutineList,
        ...eveningRoutineList,
      ];

  int expandedIndex = -1;

  static const String _completionDomain = 'height';

  Set<int> _completedIndices = {};
  bool isCompleted(int index) => _completedIndices.contains(index);

  int get totalExercises =>
      morningRoutineList.length + eveningRoutineList.length;

  int get morningCompletedCount {
    final total = morningRoutineList.length;
    if (total == 0) return 0;
    var done = 0;
    for (var i = 0; i < total; i++) {
      if (_completedIndices.contains(i)) done++;
    }
    return done;
  }

  int get eveningCompletedCount {
    final total = eveningRoutineList.length;
    if (total == 0) return 0;
    final offset = morningRoutineList.length;
    var done = 0;
    for (var i = 0; i < total; i++) {
      if (_completedIndices.contains(offset + i)) done++;
    }
    return done;
  }

  int _sectionPercent(int done, int total) {
    if (total <= 0) return 0;
    return ((done / total) * 100).round().clamp(0, 100);
  }

  int get morningCompletionPercent =>
      _sectionPercent(morningCompletedCount, morningRoutineList.length);

  int get eveningCompletionPercent =>
      _sectionPercent(eveningCompletedCount, eveningRoutineList.length);

  Future<void> markExerciseDone(int index) async {
    if (_completedIndices.contains(index)) {
      _completedIndices.remove(index);
    } else {
      _completedIndices.add(index);
    }
    await WorkoutCompletionRepository.instance.saveCompleted(
      DateTime.now(),
      _completedIndices,
      domain: _completionDomain,
      totalExercises: totalExercises,
    );
    notifyListeners();
  }

  void toggleExpand(int index) {
    expandedIndex = expandedIndex == index ? -1 : index;
    notifyListeners();
  }

  bool isExpanded(int index) => expandedIndex == index;

  Future<void> loadFromFlowResult(Map<String, dynamic>? data) async {
    if (data == null) {
      morningRoutineList = [];
      eveningRoutineList = [];
      _completedIndices = {};
      expandedIndex = -1;
      notifyListeners();
      return;
    }
    final lists = HeightRoutineRepository.parseRoutineLists(
      data,
      defaultsWhenDataNull: false,
    );
    morningRoutineList = lists.morning;
    eveningRoutineList = lists.evening;
    expandedIndex = -1;
    final loaded = await WorkoutCompletionRepository.instance.loadCompleted(
      DateTime.now(),
      domain: _completionDomain,
    );
    if (loaded != null) {
      _completedIndices = loaded;
    }
    notifyListeners();
  }
}
