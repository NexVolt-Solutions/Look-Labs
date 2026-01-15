import 'package:flutter/material.dart';

class DietViewModel extends ChangeNotifier {
  final PageController pageController = PageController();

  int currentStep = 0;

  final List<Map<String, dynamic>> dietQuestions = [
    {
      "title": "Meal Frequency",
      "question": "How many meals do you eat per day?",
      "options": ["1-2", "3", "4+", "Snacks only"],
    },
    {
      "title": "Protein Intake",
      "question": "Do you consume enough protein?",
      "options": ["Yes", "No", "Sometimes"],
    },
    {
      "title": "Fruits & Veggies",
      "question": "How many servings of fruits/veggies per day?",
      "options": ["0-1", "2-3", "4-5", "5+"],
    },
    {
      "title": "Water Intake",
      "question": "How much water do you drink daily?",
      "options": ["<1L", "1-2L", "2-3L", ">3L"],
    },
    {
      "title": "Goal",
      "question": "What is your main diet goal?",
      "options": ["Weight loss", "Muscle gain", "Healthy eating"],
    },
  ];

  Map<int, int> selectedOptions = {};

  void selectOption(int index, int optionIndex) {
    selectedOptions[index] = optionIndex;
    notifyListeners();
  }

  void next() {
    if (currentStep < dietQuestions.length - 1) {
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
