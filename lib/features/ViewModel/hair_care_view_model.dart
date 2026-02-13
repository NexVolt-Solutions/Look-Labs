// import 'package:flutter/material.dart';

// class HairCareViewModel extends ChangeNotifier {
//   final PageController pageController = PageController();

//   int currentStep = 0;

//   void setStep(int index) {
//     currentStep = index;
//     notifyListeners();
//   }

//   void next() {
//     pageController.nextPage(
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//   }

//   void back() {
//     pageController.previousPage(
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//     );
//   }

//   // int currentStep = 0;

//   final List<Map<String, dynamic>> hairCareQuestions = [
//     {
//       "title": "Hair Type",
//       "question": "What is your hair type?",
//       "options": ["Dry", "Oily", "Normal", "Curly"],
//     },
//     {
//       "title": "Hair Fall",
//       "question": "Do you experience hair fall?",
//       "options": ["Yes", "No", "Sometimes"],
//     },
//     {
//       "title": "Scalp",
//       "question": "How is your scalp?",
//       "options": ["Dry", "Oily", "Dandruff"],
//     },
//     {
//       "title": "Routine",
//       "question": "Do you oil your hair?",
//       "options": ["Regularly", "Sometimes", "Never"],
//     },
//     {
//       "title": "Products",
//       "question": "Do you use hair products?",
//       "options": ["Yes", "No"],
//     },
//     {
//       "title": "Goal",
//       "question": "What is your hair goal?",
//       "options": ["Growth", "Shine", "Strength"],
//     },
//   ];

//   Map<int, int> selectedOptions = {};

//   void selectOption(int index, int optionIndex) {
//     selectedOptions[index] = optionIndex;
//     notifyListeners();
//   }

//   void next() {
//     if (currentStep < hairCareQuestions.length - 1) {
//       currentStep++;
//       pageController.nextPage(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//       notifyListeners();
//     }
//   }

//   void back() {
//     if (currentStep > 0) {
//       currentStep--;
//       pageController.previousPage(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//       notifyListeners();
//     }
//   }
// }

import 'package:flutter/material.dart';

class HairCareViewModel extends ChangeNotifier {
  final PageController pageController = PageController();

  int currentStep = 0;

  final Map<int, int> selectedOptions = {};

  /// 🔹 Page change listener
  void setStep(int index) {
    currentStep = index;
    notifyListeners();
  }

  /// 🔹 Next button
  void next() {
    if (currentStep < hairCareQuestions.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// 🔹 Back button
  void back() {
    if (currentStep > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// 🔹 Select option
  void selectOption(int qIndex, int oIndex) {
    selectedOptions[qIndex] = oIndex;
    notifyListeners();
  }

  final List<Map<String, dynamic>> hairCareQuestions = [
    {
      'title': 'Hair Care',
      'question': 'How often do you wash your hair?',
      'options': ['Daily', '2–3 times a week', 'Once a week'],
    },
    {
      'title': 'History',
      'question': 'Do you have a history of hair fall?',
      'options': ['Yes', 'No'],
    },
    {
      'title': 'Hair',
      'question': 'What is your hair type?',
      'options': ['Straight', 'Wavy', 'Curly'],
    },
    {
      'title': 'Scalp',
      'question': 'What is your scalp type?',
      'options': ['Dry', 'Oily', 'Normal'],
    },
    {
      'title': 'Concern',
      'question': 'Main hair concern?',
      'options': ['Hair fall', 'Dandruff', 'Thin hair'],
    },
    {
      'title': 'Routine',
      'question': 'Do you follow a hair routine?',
      'options': ['Yes', 'No'],
    },
  ];
}
