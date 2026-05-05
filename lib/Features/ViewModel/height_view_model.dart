import 'package:flutter/material.dart';

class HeightViewModel extends ChangeNotifier {
  static const double minHeightCm = 120;
  static const double maxHeightCm = 220;

  final PageController pageController = PageController();

  final List<Map<String, dynamic>> _heightQuestions = [
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

  double _currentHeightCm = 149;
  double _desiredHeightCm = 150;

  double get currentHeightCm => _currentHeightCm;
  double get desiredHeightCm => _desiredHeightCm;
  List<Map<String, dynamic>> get heightQuestions => _heightQuestions;

  static double sliderToCm(double value) =>
      (minHeightCm + (maxHeightCm - minHeightCm) * value).clamp(
        minHeightCm,
        maxHeightCm,
      );

  static double cmToSlider(double cm) =>
      ((cm - minHeightCm) / (maxHeightCm - minHeightCm)).clamp(0.0, 1.0);

  String formatCm(double value) => '${sliderToCm(value).round()} cm';

  bool shouldHideQuestionText(int index) {
    if (index < 0 || index >= _heightQuestions.length) return false;
    final bool isLastScreen = index == _heightQuestions.length - 1;
    if (!isLastScreen) return false;
    final step = (_heightQuestions[index]['step']?.toString() ?? '')
        .trim()
        .toLowerCase();
    if (step == 'height') return true;
    final question =
        (_heightQuestions[index]['question']?.toString() ?? '')
            .trim()
            .toLowerCase();
    return question == 'what is your current and desired height?';
  }

  void setCurrentHeightFromSlider(double value) {
    final next = sliderToCm(value);
    if ((_currentHeightCm - next).abs() < 0.001) return;
    _currentHeightCm = next;
    notifyListeners();
  }

  void setDesiredHeightFromSlider(double value) {
    final next = sliderToCm(value);
    if ((_desiredHeightCm - next).abs() < 0.001) return;
    _desiredHeightCm = next;
    notifyListeners();
  }

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

  /// Reset to first step (e.g. when entering height step from domain questions).
  void reset() {
    currentStep = 0;
    selectedOptions.clear();
    _currentHeightCm = 149;
    _desiredHeightCm = 150;
    if (pageController.hasClients) {
      pageController.jumpToPage(0);
    }
    notifyListeners();
  }
}
