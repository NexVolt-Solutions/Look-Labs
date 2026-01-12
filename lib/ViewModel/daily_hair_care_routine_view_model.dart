import 'package:flutter/material.dart';

class DailyHairCareRoutineViewModel extends ChangeNotifier {
  final bool isSelected = false;

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
