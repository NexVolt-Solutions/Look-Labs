import 'package:flutter/material.dart';

class DailyHeightRoutineViewModel extends ChangeNotifier {
  List<Map<String, dynamic>> heightRoutineList = [
    {'time': 'Neck Stretches', 'activity': '3 min exercises'},
    {'time': 'Spine Alignment', 'activity': '5 min exercises'},
  ];

  int selectedIndex = -1;

  void selectPlan(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  bool isPlanSelected(int index) {
    return selectedIndex == index;
  }
}
