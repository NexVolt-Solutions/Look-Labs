import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Features/View/Home/home_screen.dart';
import 'package:looklabs/Features/View/Progress/progress_screen.dart';
import 'package:looklabs/Features/View/Setting/setting_screen.dart';

class BottomSheetViewModel extends ChangeNotifier {
  int selectedIndex = 0;

  void changeIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  final List<Widget> screen = [HomeScreen(), ProgressScreen(), SettingScreen()];

  List<Map<String, dynamic>> bottomAppBarData = [
    {'name': 'Home', 'image': AppAssets.homeIcon},
    {'name': 'Processing', 'image': AppAssets.processingIcon},
    {'name': 'Setting', 'image': AppAssets.settingIcon},
  ];
}
