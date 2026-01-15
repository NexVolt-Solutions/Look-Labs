import 'package:flutter/material.dart';

class FashionViewModel extends ChangeNotifier {
  final PageController pageController = PageController();

  int currentStep = 0;

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

  Map<int, int> selectedOptions = {};

  void selectOption(int index, int optionIndex) {
    selectedOptions[index] = optionIndex;
    notifyListeners();
  }

  void next() {
    if (currentStep < fashionQuestions.length - 1) {
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
