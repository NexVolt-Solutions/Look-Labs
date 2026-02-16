import 'package:flutter/material.dart';

class ProgressViewModel extends ChangeNotifier {
  int currentStep = 0;
  String selectedIndex = '';

  List<String> buttonName = ['Week', 'Month', 'Year'];
  void selectIndex(int index) {
    if (selectedIndex == buttonName[index]) {
      selectedIndex = '';
    } else {
      selectedIndex = buttonName[index];
    }
    notifyListeners();
  }
}
