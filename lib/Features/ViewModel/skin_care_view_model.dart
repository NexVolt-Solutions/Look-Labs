import 'package:flutter/material.dart';

class SkinCareViewModel extends ChangeNotifier {
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
    if (currentStep < skinCareQuestions.length - 1) {
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

  final List<Map<String, dynamic>> skinCareQuestions = [
    {
      "title": "Hydration",
      "question": "How hydrated does your skin usually feel?",
      "options": ["Dry", "Oily", "Combination", "Sensitive"],
    },
    {
      "title": "Acne",
      "question": "Do you have acne?",
      "options": ["Yes", "No", "Sometimes"],
    },
    {
      "title": "Sensitivity",
      "question": "Is your skin sensitive?",
      "options": ["Yes", "No"],
    },
    {
      "title": "Routine",
      "question": "Do you follow skincare routine?",
      "options": ["Daily", "Sometimes", "Never"],
    },
    {
      "title": "Products",
      "question": "Do you use skincare products?",
      "options": ["Yes", "No"],
    },
    {
      "title": "Goal",
      "question": "What is your skin goal?",
      "options": ["Glow", "Clear skin", "Anti-aging"],
    },
  ];
}
