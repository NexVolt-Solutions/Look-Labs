import 'package:flutter/material.dart';

class FacialViewModel extends ChangeNotifier {
  final PageController pageController = PageController();

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

  int currentStep = 0;

  final Map<int, int> selectedOptions = {};

  /// 🔹 Page change listener
  void setStep(int index) {
    currentStep = index;
    notifyListeners();
  }

  /// 🔹 Next button
  void next() {
    if (currentStep < facialQuestions.length - 1) {
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
}
