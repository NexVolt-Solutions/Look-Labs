import 'package:flutter/material.dart';

class QuitPornViewModel extends ChangeNotifier {
  final PageController pageController = PageController();

  int currentStep = 0;

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

  Map<int, int> selectedOptions = {};

  void selectOption(int index, int optionIndex) {
    selectedOptions[index] = optionIndex;
    notifyListeners();
  }

  void next() {
    if (currentStep < quitPornQuestions.length - 1) {
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
