import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/View/Home/home_screen.dart';
import 'package:looklabs/View/Progress/progress_screen.dart';

class BottomSheetViewModel extends ChangeNotifier {
  int selectedIndex = 0;

  void changeIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  final List<Widget> screen = [
    HomeScreen(),
    ProgressScreen(),
    Center(child: Text("Setting Screen")),
  ];

  List<Map<String, dynamic>> bottomAppBarData = [
    {'name': 'Home', 'image': AppAssets.homeIcon},
    {'name': 'Processing', 'image': AppAssets.processingIcon},
    {'name': 'Setting', 'image': AppAssets.settingIcon},
  ];
}
