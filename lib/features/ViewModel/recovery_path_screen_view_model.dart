import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';

class RecoveryPathScreenViewModel extends ChangeNotifier {
  String selectedSection = 'Daily Tasks';

  void selectSection(String section) {
    selectedSection = section;
    notifyListeners();
  }

  int currentStep = 0;
  int selectedRepIndex = -1;
  int selectedRecIndex = -1;
  String selectedIndex = '';

  List<String> buttonName = ['Week', 'Month', 'Year'];

  List<Map<String, dynamic>> repButtonName = [
    {'image': AppAssets.reportIcon, 'text': 'Report Relapse'},
    {'image': AppAssets.doneIcon, 'text': 'Complete day'},
  ];
  List<Map<String, dynamic>> richTextName = [
    {
      'image': AppAssets.tropyIcon,
      'text': 'Longest Streak',
      'richtitle': '0',
      'richsubtitle': 'days',
    },
    {
      'image': AppAssets.goalsIcon,
      'text': 'current',
      'richtitle': '0',
      'richsubtitle': 'days',
    },
  ];
  List<Map<String, dynamic>> checkBoxName = [
    {
      'text': 'Report Relapse',
      'subTitle':
          'Take 2 minutes to write down your intention for today. Why do you want to stay clean?',
    },
    {
      'text': 'Drink Water',
      'subTitle': 'Drink at least 8 glasses of water today.',
    },
    {'text': 'Stretch', 'subTitle': 'Do light stretching for 10 minutes.'},
  ];

  late List<bool> selectedChecklist = List.generate(
    checkBoxName.length,
    (_) => false,
  );

  void toggleChecklist(int index) {
    selectedChecklist[index] = !selectedChecklist[index];
    notifyListeners();
  }

  List<Map<String, dynamic>> recordButtonName = [
    {'image': AppAssets.ageIcon, 'text': 'Daily Plan'},
    {'image': AppAssets.exersieIcon, 'text': 'Exercise'},
  ];

  void selectRepButton(int index) {
    if (selectedRepIndex == index) {
      selectedRepIndex = -1; // unselect if tapped again
    } else {
      selectedRepIndex = index;
    }
    notifyListeners();
  }

  void selectRecordButton(int index) {
    if (selectedRecIndex == index) {
      selectedRecIndex = -1; // unselect if tapped again
    } else {
      selectedRecIndex = index;
    }
    notifyListeners();
  }

  void selectIndex(int index) {
    if (selectedIndex == buttonName[index]) {
      selectedIndex = '';
    } else {
      selectedIndex = buttonName[index];
    }
    notifyListeners();
  }
}
