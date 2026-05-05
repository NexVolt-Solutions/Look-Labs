import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';

class StyleProfileScreenViewModel extends ChangeNotifier {
  bool isExerciseSelected = false;
  void selectExercise() {
    isExerciseSelected = true;
    notifyListeners();
  }

  List<Map<String, dynamic>> facialData = [
    {
      'image': AppAssets.toothIcon,
      'title': 'Jawline',
      'subtitle': 'Narrow',
      'per': 78,
    },
    {
      'image': AppAssets.noseIcon,
      'title': 'Nose',
      'subtitle': 'Straight',
      'per': 78,
    },
    {
      'image': AppAssets.lipsIcon,
      'title': 'Lips',
      'subtitle': 'Medium',
      'per': 78,
    },
    {
      'image': AppAssets.boneIcon,
      'title': 'Cheek bones',
      'subtitle': 'High',
      'per': 78,
    },
    {
      'image': AppAssets.eyeIcon,
      'title': 'Eyes',
      'subtitle': 'Almond',
      'per': 78,
    },
    {
      'image': AppAssets.earIcon,
      'title': 'Ears',
      'subtitle': 'Proportional',
      'per': 78,
    },
    {
      'image': AppAssets.faceIcon,
      'title': 'Face Shape',
      'subtitle': 'Diamond Face Shape',
      'per': 78,
    },
  ];
}
