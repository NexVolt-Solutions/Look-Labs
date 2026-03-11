import 'package:flutter/material.dart';
import 'package:looklabs/Core/Network/models/workout_result_response.dart';

class WorkOutProgressScreenViewModel extends ChangeNotifier {
  int currentStep = 0;
  String selectedIndex = '';

  List<String> buttonName = ['Week', 'Month', 'Year'];

  List<String> _checkBoxName = [
    'Got 7+ hours of sleep',
    'Drank 8+ glasses of water',
    'Stretched for 10 minutes',
    'Took a rest if needed',
  ];
  List<String> get checkBoxName => _checkBoxName;

  List<bool> _selectedChecklist = List.generate(4, (_) => false);
  List<bool> get selectedChecklist => _selectedChecklist;

  String? _weeklyCalories;
  String? _consistency;
  String? _strengthGain;
  String? _fitnessConsistency;
  String? _postureInsight;
  String? _aiMessage;
  String? get weeklyCalories => _weeklyCalories;
  String? get consistency => _consistency;
  String? get strengthGain => _strengthGain;
  String? get fitnessConsistency => _fitnessConsistency;
  String? get postureInsight => _postureInsight;
  String? get aiMessage => _aiMessage;

  List<Map<String, String>> _progressCards = [];
  List<Map<String, String>> get progressCards => _progressCards;

  /// Parse percentage from string (e.g. "98%" -> 98, "95%" -> 95).
  int get fitnessConsistencyProgress {
    final s = _fitnessConsistency ?? _consistency;
    if (s == null || s.isEmpty) return 0;
    final num = int.tryParse(s.replaceAll(RegExp(r'[^\d]'), ''));
    return num ?? 0;
  }

  void setWorkoutData(Map<String, dynamic> data) {
    try {
      final result = WorkoutResultResponse.fromJson(data);
      // ai_progress (when API returns it)
      if (result.aiProgress != null) {
        final p = result.aiProgress!;
        _weeklyCalories = p.weeklyCalories;
        _consistency = p.consistency;
        _strengthGain = p.strengthGain;
        _fitnessConsistency = p.fitnessConsistency;
        if (p.recoveryChecklist.isNotEmpty) {
          _checkBoxName = p.recoveryChecklist;
          _selectedChecklist =
              List.generate(p.recoveryChecklist.length, (_) => false);
        }
        _progressCards = [];
        if (p.weeklyCalories != null)
          _progressCards.add({'title': 'Weekly Cal', 'value': p.weeklyCalories!});
        if (p.consistency != null)
          _progressCards.add({'title': 'Consistency', 'value': p.consistency!});
        if (p.strengthGain != null)
          _progressCards.add({'title': 'Strength', 'value': p.strengthGain!});
        if (p.fitnessConsistency != null)
          _progressCards.add({
            'title': 'Fitness',
            'value': p.fitnessConsistency!,
          });
      }
      // ai_attributes (posture_insight, workout_summary, today_focus)
      if (result.aiAttributes != null) {
        final a = result.aiAttributes!;
        if (a.postureInsight != null && a.postureInsight!.isNotEmpty)
          _postureInsight = a.postureInsight;
        // Populate progress cards from workout_summary when ai_progress is empty
        if (_progressCards.isEmpty && a.workoutSummary != null) {
          final ws = a.workoutSummary!;
          if (ws.totalExercises != null)
            _progressCards.add({
              'title': 'Exercises',
              'value': ws.totalExercises.toString(),
            });
          if (ws.totalDurationMin != null)
            _progressCards.add({
              'title': 'Duration',
              'value': '${ws.totalDurationMin} min',
            });
        }
        if (_progressCards.isEmpty && a.todayFocus.isNotEmpty)
          _progressCards.add({
            'title': 'Focus',
            'value': a.todayFocus.take(2).join(', '),
          });
      }
      if (result.aiMessage != null && result.aiMessage!.isNotEmpty)
        _aiMessage = result.aiMessage;
      notifyListeners();
    } catch (_) {}
  }

  void selectIndex(int index) {
    if (selectedIndex == buttonName[index]) {
      selectedIndex = '';
    } else {
      selectedIndex = buttonName[index];
    }
    notifyListeners();
  }

  void toggleChecklist(int index) {
    if (index >= 0 && index < _selectedChecklist.length) {
      _selectedChecklist[index] = !_selectedChecklist[index];
    }
    notifyListeners();
  }
}
