import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';

class HomeViewModel extends ChangeNotifier {
  List<Map<String, dynamic>> homeOverViewData = [
    {'title': 'Your Height', 'subTitle': '7 cm', 'image': AppAssets.heightIcon},
    {
      'title': 'Your Weight',
      'subTitle': '78 kg',
      'image': AppAssets.heightIcon,
    },
    {
      'title': 'Sleep Hours',
      'subTitle': '8 Hours',
      'image': AppAssets.heightIcon,
    },
    {
      'title': 'Water Intake',
      'subTitle': '2.5 L',
      'image': AppAssets.waterIcon,
    },
  ];
  List<Map<String, dynamic>> listViewData = [
    {'title': 'Skin', 'subTitle': '34/100', 'image': AppAssets.heightIcon},
    {'title': 'Hair', 'subTitle': '34/100', 'image': AppAssets.heightIcon},
    {'title': 'Body', 'subTitle': '34/100', 'image': AppAssets.heightIcon},
    {'title': 'Habit', 'subTitle': '34/100', 'image': AppAssets.heightIcon},
  ];
}
