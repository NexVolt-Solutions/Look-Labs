import 'package:flutter/material.dart';
import 'package:looklabs/Core/Network/models/weekly_progress_response.dart';
import 'package:looklabs/Repository/onboarding_repository.dart';

class ProgressViewModel extends ChangeNotifier {
  int currentStep = 0;
  String selectedIndex = '';

  List<String> buttonName = ['Week', 'Month', 'Year'];

  void selectIndex(int index) {
    if (selectedIndex == buttonName[index]) {
      selectedIndex = '';
    } else {
      selectedIndex = buttonName[index];
    }
    notifyListeners();
  }

  // After Progress: weekly API data
  WeeklyProgressResponse? _weeklyProgress;
  bool _weeklyLoading = false;
  String? _weeklyError;

  WeeklyProgressResponse? get weeklyProgress => _weeklyProgress;
  bool get weeklyProgressLoading => _weeklyLoading;
  String? get weeklyProgressError => _weeklyError;

  /// GET users/me/progress/weekly. Call when Progress screen is shown.
  Future<void> loadWeeklyProgress() async {
    if (_weeklyLoading) return;
    _weeklyLoading = true;
    _weeklyError = null;
    notifyListeners();

    final response = await OnboardingRepository.instance.getWeeklyProgress();
    _weeklyLoading = false;
    if (response.success && response.data is WeeklyProgressResponse) {
      _weeklyProgress = response.data as WeeklyProgressResponse;
      _weeklyError = null;
    } else {
      _weeklyError = response.message ?? 'Could not load weekly progress';
    }
    notifyListeners();
  }

  /// Retry loading weekly progress.
  Future<void> retryWeeklyProgress() async {
    _weeklyError = null;
    notifyListeners();
    await loadWeeklyProgress();
  }

  /// Chart-ready data: labels (days) and scores from API or empty.
  List<WeeklyProgressDay> get weeklyProgressDays =>
      _weeklyProgress?.days ?? const [];
}
