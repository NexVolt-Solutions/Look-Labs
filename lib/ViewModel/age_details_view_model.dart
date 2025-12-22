import 'package:flutter/material.dart';

class AgeDetailsViewModel extends ChangeNotifier {
  List ageData = ['18 to 20 years', '21 to 22 years', '23 to 25 years'];

  String selectedIndex = '';
  int currentStep = 0;

  void selectIndex(int index) {
    if (selectedIndex == ageData[index]) {
      selectedIndex = '';
    } else {
      selectedIndex = ageData[index];
    }
    notifyListeners();
  }

  int _age = 0;

  int get age => _age;

  void incrementAge() {
    _age++;
    notifyListeners();
  }

  void decrementAge() {
    if (_age > 0) {
      _age--;
      notifyListeners();
    }
  }
}
