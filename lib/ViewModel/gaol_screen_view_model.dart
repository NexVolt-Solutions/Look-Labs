import 'package:flutter/material.dart';

class GaolScreenViewModel extends ChangeNotifier {
  int currentStep = 0;

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

  void selectIndex(int index) {
    if (selectedIndex == buttonName[index]) {
      selectedIndex = '';
    } else {
      selectedIndex = buttonName[index];
    }
    notifyListeners();
  }
}
