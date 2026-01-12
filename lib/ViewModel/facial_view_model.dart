import 'package:flutter/material.dart';

class FacialViewModel extends ChangeNotifier {
  final PageController pageController = PageController();

  int currentStep = 0;

  final List<Map<String, dynamic>> facialQuestions = [
    {
      "title": "Skin Type",
      "question": "What is your skin type?",
      "options": ["Dry", "Oily", "Combination", "Sensitive"],
    },
    {
      "title": "Pores",
      "question": "Are your pores visible?",
      "options": ["Yes", "No", "Sometimes"],
    },
    {
      "title": "Acne",
      "question": "Do you get acne or breakouts?",
      "options": ["Yes", "No", "Sometimes"],
    },
    {
      "title": "Wrinkles",
      "question": "Do you have wrinkles or fine lines?",
      "options": ["Yes", "No", "Sometimes"],
    },
    {
      "title": "Goal",
      "question": "What is your facial care goal?",
      "options": ["Glow", "Clear skin", "Anti-aging", "Hydration"],
    },
  ];

  Map<int, int> selectedOptions = {};

  void selectOption(int index, int optionIndex) {
    selectedOptions[index] = optionIndex;
    notifyListeners();
  }

  void next() {
    if (currentStep < facialQuestions.length - 1) {
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
