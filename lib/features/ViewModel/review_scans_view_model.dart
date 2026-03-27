import 'package:flutter/material.dart';

class ReviewScansViewModel extends ChangeNotifier {
  int currentStep = 0;

  void selectStep(int step) {
    currentStep = step;
    notifyListeners();
  }
}
