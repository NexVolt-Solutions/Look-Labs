import 'package:flutter/material.dart';

class DailyHairCareRoutineViewModel extends ChangeNotifier {
  bool isSelected = false;

  void toggleRemediesSelection(int index) {
    remediesData[index]['isSelected'] =
        !(remediesData[index]['isSelected'] as bool);
    notifyListeners();
  }

  final List<List<Map<String, dynamic>>> indicatorPages = [
    // 🔹 Hair Attributes
    [
      {'title': 'Density', 'subTitle': 'High', 'pers': '20'},
      {'title': 'Thickness', 'subTitle': 'Medium', 'pers': '15'},
      {'title': 'Texture', 'subTitle': 'Wavy', 'pers': '10'},
      {'title': 'Porosity', 'subTitle': 'Normal', 'pers': '18'},
    ],

    // 🔹 Hair Health
    [
      {'title': 'Shine', 'subTitle': 'Good', 'pers': '22'},
      {'title': 'Strength', 'subTitle': 'Strong', 'pers': '25'},
      {'title': 'Moisture', 'subTitle': 'Balanced', 'pers': '20'},
      {'title': 'Elasticity', 'subTitle': 'Healthy', 'pers': '18'},
    ],

    // 🔹 Concerns Analysis
    [
      {'title': 'Hair Fall', 'subTitle': 'Low', 'pers': '8'},
      {'title': 'Dandruff', 'subTitle': 'None', 'pers': '5'},
      {'title': 'Frizz', 'subTitle': 'Moderate', 'pers': '12'},
      {'title': 'Oiliness', 'subTitle': 'High', 'pers': '20'},
    ],
  ];

  List<Map<String, dynamic>> remediesData = [
    {
      'title': 'Home Remedies',
      'subTitle': 'Home Remedies',
      'isSelected': false,
    },
    {
      'title': 'Top Products',
      'subTitle': 'Top Products Picks For You',
      'isSelected': false,
    },
  ];

  void selectDemedies(int index) {
    for (int i = 0; i < remediesData.length; i++) {
      remediesData[i]['isSelected'] = i == index;
    }
    notifyListeners();
  }
}
