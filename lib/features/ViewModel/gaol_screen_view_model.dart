import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_text.dart';

class GaolScreenViewModel extends ChangeNotifier {
  List<String> buttonName = [
    AppText.skincare,
    AppText.hairCare,
    AppText.fashion,
    AppText.workout,
    AppText.quitPorn,
    AppText.bloating,
    AppText.confidence,
    AppText.height,
    AppText.fitness,
    AppText.diet,
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
