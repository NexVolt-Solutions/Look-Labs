import 'package:flutter/material.dart';

/// Selection state for [HairTopProduct]; product rows come from
/// [DailyHairCareRoutineViewModel.hairProducts].
class HairTopProductViewModel extends ChangeNotifier {
  int selectedIndex = -1;

  void selectProduct(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void clearSelection() {
    selectedIndex = -1;
    notifyListeners();
  }
}
