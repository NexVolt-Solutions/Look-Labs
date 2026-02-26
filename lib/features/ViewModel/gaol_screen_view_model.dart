import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_text.dart';

/// One goal option: display [label] in the UI, send [domain] to the API.
class GoalOption {
  final String label;
  final String domain;

  const GoalOption({required this.label, required this.domain});
}

class GaolScreenViewModel extends ChangeNotifier {
  /// Options shown on the goal screen. Domain values match backend: skincare, haircare, facial, diet, height, workout, quit_porn, fashion.
  static final List<GoalOption> goalOptions = [
    GoalOption(label: AppText.skincare, domain: 'skincare'),
    GoalOption(label: AppText.hairCare, domain: 'haircare'),
    GoalOption(label: AppText.facial, domain: 'facial'),
    GoalOption(label: AppText.diet, domain: 'diet'),
    GoalOption(label: AppText.height, domain: 'height'),
    GoalOption(label: AppText.workout, domain: 'workout'),
    GoalOption(label: AppText.quitPorn, domain: 'quit_porn'),
    GoalOption(label: AppText.fashion, domain: 'fashion'),
  ];

  List<String> get buttonName => goalOptions.map((o) => o.label).toList();

  /// Selected display label (e.g. 'Skincare'). Empty if none selected.
  String selectedIndex = '';
  int currentStep = 0;

  /// API domain value for the currently selected option, or null if none.
  String? get selectedDomain {
    if (selectedIndex.isEmpty) return null;
    final i = goalOptions.indexWhere((o) => o.label == selectedIndex);
    return i >= 0 ? goalOptions[i].domain : null;
  }

  void selectIndex(int index) {
    if (selectedIndex == goalOptions[index].label) {
      selectedIndex = '';
    } else {
      selectedIndex = goalOptions[index].label;
    }
    notifyListeners();
  }
}
