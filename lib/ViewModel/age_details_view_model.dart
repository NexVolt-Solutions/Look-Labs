import 'package:flutter/material.dart';

class AgeDetailsViewModel extends ChangeNotifier {
  int selectedAge = 0;

  List<int> ageList = List.generate(101, (index) => index);

  void changeAge(int value) {
    selectedAge = value;
    notifyListeners();
  }

  int currentStep = 0;
  String selectedValue = '';

  final List<Map<String, dynamic>> stepsData = [
    {
      'title': 'What is your current age?',
      'subTitle': 'This helps personalize your routine',
      'list': ['18 to 20 years', '21 to 22 years', '23 to 25 years'],
    },
    {
      'title': 'What is your gender?',
      'subTitle': 'Select your gender',
      'list': ['Male', 'Female', 'Other'],
    },
    {
      'title': 'What is your hair type?',
      'subTitle': 'Choose your hair type',
      'list': ['Straight', 'Wavy', 'Curly / Coily'],
    },
  ];

  // 🔹 current step data getters
  String get title => stepsData[currentStep]['title'];
  String get subTitle => stepsData[currentStep]['subTitle'];
  List get currentList => stepsData[currentStep]['list'];

  void selectItem(int index) {
    selectedValue = selectedValue == currentList[index]
        ? ''
        : currentList[index];
    notifyListeners();
  }

  void nextStep() {
    if (currentStep < stepsData.length - 1) {
      currentStep++;
      selectedValue = '';
      notifyListeners();
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      currentStep--;
      selectedValue = '';
      notifyListeners();
    }
  }
}
