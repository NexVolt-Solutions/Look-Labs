import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';

class WorkOutResultScreenViewModel extends ChangeNotifier {
  List<Map<String, dynamic>> heightRoutineList = [
    {
      'time': 'Neck Stretches',
      'activity': '3 min exercises',
      'details': 'Tilt head left & right for 10 seconds',
    },
    {
      'time': 'Spine Alignment',
      'activity': '5 min exercises',
      'details': 'Sit straight and stretch your spine',
    },
  ];

  int selectedIndex = -1; // ✔ tick state
  int expandedIndex = -1; // ⬇️ dropdown state

  /// ✔ Tick logic (circle tap only)
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

  List<Map<String, dynamic>> gridData = [
    {
      'title': 'Intensity',
      'subtitle': 'Moderate',
      'image': AppAssets.electricLightIcon,
    },
    {
      'title': 'Activity',
      'subtitle': 'Moderate',
      'image': AppAssets.oirActivityIcon,
    },
  ];

  List<Map<String, dynamic>> exData = [
    {'title': 'Flexibility', 'image': AppAssets.flexibilityIcon},
    {'title': 'Build Muscle', 'image': AppAssets.muscleBodyIcon},
    {'title': 'Fatloss', 'image': AppAssets.fatLossIcon},
    {'title': 'Strength', 'image': AppAssets.actionWorkOutIcon},
  ];

  /// ✔ selected item index

  void selectExercise(int index) {
    selectedIndex = selectedIndex == index ? -1 : index;
    notifyListeners();
  }

  bool isSelected(int index) => selectedIndex == index;
}
