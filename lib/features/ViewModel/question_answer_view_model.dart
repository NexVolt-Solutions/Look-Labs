import 'package:flutter/material.dart';

class QuestionAnswerViewModel extends ChangeNotifier {
  final PageController pageController = PageController();

  int currentStep = 0;
  final Map<int, Map<int, int>> answers = {};

  void selectOption(int screen, int question, int option) {
    answers.putIfAbsent(screen, () => {});
    answers[screen]![question] = option;
    notifyListeners();
  }

  bool isSelected(int screen, int question, int option) {
    return answers[screen]?[question] == option;
  }

  void next() {
    if (currentStep < questionData.length - 1) {
      currentStep++;
      pageController.animateToPage(
        currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      notifyListeners();
    }
  }

  void back() {
    if (currentStep > 0) {
      currentStep--;
      pageController.animateToPage(
        currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      notifyListeners();
    }
  }

  final List<Map<String, dynamic>> questionData = [
    /// 🔹 SCREEN 1 (Profile)
    {
      "title": "Profile Setup",
      "questions": [
        {
          "question": "What is your gender?",
          "options": ["Male", "Female", "Other"],
        },
      ],
    },

    /// 🔹 SCREEN 2 (3 QUESTIONS)
    {
      "title": "Daily Lifestyle",
      "questions": [
        {
          "question": "How do you usually feel during the day?",
          "options": ["Low / tired", "Average", "Energetic"],
        },
        {
          "question": "How active are you?",
          "options": ["Not active", "Moderate", "Very active"],
        },
        {
          "question": "How is your mood usually?",
          "options": ["Low", "Normal", "Good"],
        },
      ],
    },

    /// 🔹 SCREEN 3 (3 QUESTIONS)
    {
      "title": "Goals & Focus",
      "questions": [
        {
          "question": "How is your sleep?",
          "options": ["Poor", "Average", "Good"],
        },
        {
          "question": "Daily water intake?",
          "options": ["Low", "Normal", "High"],
        },
        {
          "question": "Do you feel rested in morning?",
          "options": ["No", "Sometimes", "Yes"],
        },
      ],
    },

    /// 🔹 SCREEN 4 (3 QUESTIONS)
    {
      "title": "Motivation",
      "questions": [
        {
          "question": "Daily workout?",
          "options": ["No", "Sometimes", "Regular"],
        },
        {
          "question": "Stress level?",
          "options": ["Low", "Medium", "High"],
        },
        {
          "question": "Work-life balance?",
          "options": ["Poor", "Average", "Good"],
        },
      ],
    },

    /// 🔹 SCREEN 5 (3 QUESTIONS)
    {
      "title": "Planning",
      "questions": [
        {
          "question": "Screen time per day?",
          "options": ["Low", "Average", "High"],
        },
        {
          "question": "Eating habits?",
          "options": ["Unhealthy", "Normal", "Healthy"],
        },
        {
          "question": "Overall lifestyle?",
          "options": ["Poor", "Average", "Good"],
        },
      ],
    },
  ];
}
