// import 'package:flutter/material.dart';

// class AgeDetailsViewModel extends ChangeNotifier {
//   int currentStep = 0;
//   String selectedValue = '';

//   final List<Map<String, dynamic>> stepsData = [
//     {
//       'title': 'What is your current age?',
//       'subTitle': 'This helps personalize your routine',
//       'list': ['18 to 20 years', '21 to 22 years', '23 to 25 years'],
//     },
//     {
//       'title': 'What is your gender?',
//       'subTitle': 'Select your gender',
//       'list': ['Male', 'Female', 'Other'],
//     },
//     {
//       'title': 'What is your hair type?',
//       'subTitle': 'Choose your hair type',
//       'list': ['Straight', 'Wavy', 'Curly / Coily'],
//     },
//   ];

//   String get title => stepsData[currentStep]['title'];
//   String get subTitle => stepsData[currentStep]['subTitle'];
//   List get currentList => stepsData[currentStep]['list'];

//   void selectItem(int index) {
//     selectedValue = selectedValue == currentList[index]
//         ? ''
//         : currentList[index];
//     notifyListeners();
//   }

//   void nextStep() {
//     if (currentStep < stepsData.length - 1) {
//       currentStep++;
//       selectedValue = '';
//       notifyListeners();
//     }
//   }

//   void previousStep() {
//     if (currentStep > 0) {
//       currentStep--;
//       selectedValue = '';
//       notifyListeners();
//     }
//   }

//   int _age = 0;

//   int get age => _age;

//   void incrementAge() {
//     _age++;
//     notifyListeners();
//   }

//   void decrementAge() {
//     if (_age > 0) {
//       _age--;
//       notifyListeners();
//     }
//   }
// }

import 'package:flutter/material.dart';

class AgeDetailsViewModel extends ChangeNotifier {
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
