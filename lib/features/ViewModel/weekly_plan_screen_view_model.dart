import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';

class WeeklyPlanScreenViewModel extends ChangeNotifier {
  bool isBestClothingSelected = false;
  int selectedIndex = -1;

  /// Filled from API only; no mock fallback.
  List<String> clothingFits = [];

  /// Select season index. clothingFits must be set from API (no fallback data).
  void selectIndex(int index) {
    selectedIndex = index;
    clothingFits = [];
    notifyListeners();
  }

  /// Call when API returns clothing fits for the selected season.
  void setClothingFitsFromApi(List<String> fits) {
    clothingFits = fits;
    notifyListeners();
  }

  bool get showClothingCard => selectedIndex != -1 && clothingFits.isNotEmpty;
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

  // int selectedIndex = -1; // ✔ tick state
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

  bool isSelected(int index) => selectedIndex == index;

  List<Map<String, dynamic>> buttonName = [
    {'image': AppAssets.sunIcon, 'title': 'Summer'},
    {'image': AppAssets.rainIcon, 'title': 'Monson'},
    {'image': AppAssets.winterIcon, 'title': 'Winter'},
  ];
  final List<String> titleData = [
    'Outfit Combinations',
    'Recommended Fabrics',
    'Footwear',
  ];
}
