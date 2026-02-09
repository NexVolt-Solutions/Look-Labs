import 'package:flutter/material.dart';

class WorkoutViewModel extends ChangeNotifier {
  final PageController pageController = PageController();

  final List<Map<String, dynamic>> workoutQuestions = [
    {
      "title": "Exercise Frequency",
      "question": "How often do you exercise weekly?",
      "options": ["Never", "1-2 times", "3-5 times", "Daily"],
    },
    {
      "title": "Workout Type",
      "question": "What type of workouts do you prefer?",
      "options": ["Cardio", "Strength", "Flexibility", "Mixed"],
    },
    {
      "title": "Duration",
      "question": "Average duration of your workouts?",
      "options": ["<30 min", "30-60 min", "60-90 min", ">90 min"],
    },
    {
      "title": "Intensity",
      "question": "How intense are your workouts?",
      "options": ["Low", "Moderate", "High"],
    },
    {
      "title": "Goal",
      "question": "What is your main workout goal?",
      "options": ["Weight loss", "Muscle gain", "Endurance", "Flexibility"],
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
    if (currentStep < workoutQuestions.length - 1) {
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
