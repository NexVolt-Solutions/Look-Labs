import 'package:flutter/material.dart';

class FashionViewModel extends ChangeNotifier {
  final PageController pageController = PageController();

  final List<Map<String, dynamic>> fashionQuestions = [
    {
      "title": "Style Preference",
      "question": "What is your preferred style?",
      "options": ["Casual", "Formal", "Sporty", "Trendy"],
    },
    {
      "title": "Color Preference",
      "question": "What colors do you usually wear?",
      "options": ["Neutral", "Bright", "Dark", "Mixed"],
    },
    {
      "title": "Shopping Frequency",
      "question": "How often do you shop for clothes?",
      "options": ["Rarely", "Monthly", "Weekly", "Daily"],
    },
    {
      "title": "Budget",
      "question": "What is your budget range for clothing?",
      "options": ["Low", "Medium", "High", "Luxury"],
    },
    {
      "title": "Goal",
      "question": "What is your fashion goal?",
      "options": ["Update wardrobe", "Trend following", "Comfort & Style"],
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
    if (currentStep < fashionQuestions.length - 1) {
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
