import 'package:flutter/material.dart';

class QuitPornViewModel extends ChangeNotifier {
  final PageController pageController = PageController();

  final List<Map<String, dynamic>> quitPornQuestions = [
    {
      "title": "Frequency",
      "question": "How often do you watch porn currently?",
      "options": ["Daily", "Weekly", "Occasionally", "Never"],
    },
    {
      "title": "Triggers",
      "question": "What triggers you most?",
      "options": ["Stress", "Boredom", "Social Media", "Other"],
    },
    {
      "title": "Motivation",
      "question": "Why do you want to quit?",
      "options": ["Health", "Focus", "Relationships", "Spiritual"],
    },
    {
      "title": "Support",
      "question": "Do you have any support system?",
      "options": ["Yes", "No", "Sometimes"],
    },
    {
      "title": "Goal",
      "question": "What is your main goal for quitting?",
      "options": ["Reduce", "Stop completely", "Self-control"],
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
    if (currentStep < quitPornQuestions.length - 1) {
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
