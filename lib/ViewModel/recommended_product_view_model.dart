import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';

class RecommendedProductViewModel extends ChangeNotifier {
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
    if (currentStep < prodactData.length - 1) {
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

  final List<Map<String, dynamic>> prodactData = [
    {'heading': 'Oil-Control Shampoo', 'image': AppAssets.shampoo},
    {'heading': 'Lightweight Scalp Serum', 'image': AppAssets.serum},
    {'heading': 'Minoxidil Foam', 'image': AppAssets.foam},
  ];

  final List<String> usageSteps = [
    'Use 2–3 times per week',
    'Apply to wet scalp and massage gently',
    'Rinse thoroughly',
    'Repeat if needed',
  ];
}
