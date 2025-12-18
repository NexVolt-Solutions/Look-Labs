import 'package:flutter/material.dart';

class ProfileViewModel extends ChangeNotifier {
  int currentStep = 0;

  List<String> checkBoxName = ['Male', 'Female', 'Other'];

  String selectedGender = '';

  void selectGender(String gender) {
    if (selectedGender == gender) {
      selectedGender = '';
    } else {
      selectedGender = gender;
    }
    notifyListeners();
  }
}
