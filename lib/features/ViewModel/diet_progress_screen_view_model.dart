import 'package:flutter/material.dart';

class DietProgressScreenViewModel extends ChangeNotifier {
  int currentStep = 0;
  String selectedIndex = '';

  List<String> buttonName = ['Week', 'Month', 'Year'];

  List<String> checkBoxName = [
    'Got 7+ hours of sleep',
    'Drank 8+ glasses of water',
    'Stretched for 10 minutes',
    'Took a rest if needed',
  ];
  void selectIndex(int index) {
    if (selectedIndex == buttonName[index]) {
      selectedIndex = '';
    } else {
      selectedIndex = buttonName[index];
    }
    notifyListeners();
  }

  List<bool> selectedChecklist = List.generate(4, (_) => false);

  void toggleChecklist(int index) {
    selectedChecklist[index] = !selectedChecklist[index];
    notifyListeners();
  }
}
