import 'package:flutter/material.dart';

class HairCareViewModel extends ChangeNotifier {
  final PageController pageController = PageController();

  int currentStep = 0;

  final List<Map<String, dynamic>> hairCareQuestions = [
    {
      "title": "Hair Type",
      "question": "What is your hair type?",
      "options": ["Dry", "Oily", "Normal", "Curly"],
    },
    {
      "title": "Hair Fall",
      "question": "Do you experience hair fall?",
      "options": ["Yes", "No", "Sometimes"],
    },
    {
      "title": "Scalp",
      "question": "How is your scalp?",
      "options": ["Dry", "Oily", "Dandruff"],
    },
    {
      "title": "Routine",
      "question": "Do you oil your hair?",
      "options": ["Regularly", "Sometimes", "Never"],
    },
    {
      "title": "Products",
      "question": "Do you use hair products?",
      "options": ["Yes", "No"],
    },
    {
      "title": "Goal",
      "question": "What is your hair goal?",
      "options": ["Growth", "Shine", "Strength"],
    },
  ];

  Map<int, int> selectedOptions = {};

  void selectOption(int index, int optionIndex) {
    selectedOptions[index] = optionIndex;
    notifyListeners();
  }

  void next() {
    if (currentStep < hairCareQuestions.length - 1) {
      currentStep++;
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      notifyListeners();
    }
  }

  void back() {
    if (currentStep > 0) {
      currentStep--;
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      notifyListeners();
    }
  }
}
