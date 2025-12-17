import 'package:flutter/material.dart';

class ProfileViewModel extends ChangeNotifier {
  int currentStep = 0;

  List<String> checkBoxName = ['Male', 'Female', 'Other'];

  // List<Steps> get basicSteps => List.generate(
  //   name.length,
  //   (i) => Steps(title: name[i], isActive: i <= currentStep),
  // );

  // void nextStep() {
  //   if (currentStep < name.length - 1) {
  //     currentStep++;
  //     notifyListeners();
  //   }
  // }

  // void previousStep() {
  //   if (currentStep > 0) {
  //     currentStep--;
  //     notifyListeners();
  //   }
  // }

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
