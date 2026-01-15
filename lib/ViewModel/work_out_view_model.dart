import 'package:flutter/material.dart';

class WorkoutViewModel extends ChangeNotifier {
  final PageController pageController = PageController();

  int currentStep = 0;

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

  Map<int, int> selectedOptions = {};

  void selectOption(int index, int optionIndex) {
    selectedOptions[index] = optionIndex;
    notifyListeners();
  }

  void next() {
    if (currentStep < workoutQuestions.length - 1) {
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
