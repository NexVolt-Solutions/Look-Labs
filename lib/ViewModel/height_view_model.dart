import 'package:flutter/material.dart';

class HeightViewModel extends ChangeNotifier {
  final PageController pageController = PageController();

  final List<Map<String, dynamic>> heightQuestions = [
    {
      "title": "Family Growth",
      "question": "Did your parents or siblings reach their full adult height?",
      "options": ["Yes", "No", "Not sure"],
    },
    {
      "title": "Growth Spurts",
      "question": "Did you experience early or late growth spurts?",
      "options": ["Early", "Late", "Normal"],
    },
    {
      "title": "Back/Spine",
      "question": "Do you have any back or spine issues?",
      "options": ["Yes", "No"],
    },
    {
      "title": "Sleep",
      "question": "How many hours do you sleep on average?",
      "options": ["<5", "5-6", "6-8", ">8"],
    },
    {
      "title": "Activity",
      "question": "How active are you daily?",
      "options": ["Not active", "Moderately active", "Very active"],
    },
    {
      "title": "Goal",
      "question": "What is your height goal?",
      "options": ["Maintain", "Increase", "Improve posture"],
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
    if (currentStep < heightQuestions.length - 1) {
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
