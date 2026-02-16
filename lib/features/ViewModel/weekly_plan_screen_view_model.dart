import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';

class WeeklyPlanScreenViewModel extends ChangeNotifier {
  bool isBestClothingSelected = false;
  int selectedIndex = -1;

  /// This list will be filled from API
  List<String> clothingFits = [];

  /// TEMP mock data (later replaced by API response)
  final Map<int, List<String>> seasonalMockData = {
    0: [
      // Summer
      'Light cotton shirts',
      'Breathable trousers',
      'Loafers',
    ],
    1: [
      // Monsoon
      'Quick-dry shirts',
      'Ankle-length jeans',
      'Water-resistant shoes',
    ],
    2: [
      // Winter
      'Wool jackets',
      'Layered outfits',
      'Leather boots',
    ],
  };

  /// Call this on tap (or after API response)
  void selectIndex(int index) {
    selectedIndex = index;

    /// 🔥 Later this will be API call
    clothingFits = seasonalMockData[index] ?? [];

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
