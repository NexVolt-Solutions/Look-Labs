import 'package:flutter/material.dart';

class GaolScreenViewModel extends ChangeNotifier {
  List<String> buttonName = [
    'Skincare',
    'Hair care',
    'Fashion',
    'Workout',
    'Quit Porn',
    'Bloating',
    'Confidence',
    'Height',
    'Fitness',
    'Diet',
  ];

  String selectedIndex = '';
  int currentStep = 0;

  void selectIndex(int index) {
    if (selectedIndex == buttonName[index]) {
      selectedIndex = '';
    } else {
      selectedIndex = buttonName[index];
    }
    notifyListeners();
  }
}
