import 'package:flutter/material.dart';
import 'package:looklabs/features/Widget/scan_food_widgert.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';

class DailyDietRoutineScreenViewModel extends ChangeNotifier {
  void showTransparentDialog(BuildContext context) {
    // Show the dialog immediately
    showGeneralDialog(
      context: context,
      barrierDismissible: false, // user can't dismiss until you allow
      barrierColor: Colors.black.withOpacity(
        0.5,
      ), // full-screen semi-transparent black
      transitionDuration: const Duration(milliseconds: 200), // quick fade-in
      pageBuilder: (context, animation, secondaryAnimation) {
        return Scaffold(
          backgroundColor: Colors.black.withOpacity(0.5),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScanFoodWidget(
                  text: 'Scan Food',
                  icon: AppAssets.sacnIcon,
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                ScanFoodWidget(
                  text: 'Scan Barcode',
                  icon: AppAssets.mealIcon,
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                ScanFoodWidget(
                  text: 'Gallery',
                  icon: AppAssets.galleryIcon,
                  onTap: () {},
                ),
              ],
            ),
          ),
        );
      },
    );

    // Later you can replace this with actual scan logic
    Future.delayed(const Duration(seconds: 10), () {
      Navigator.pop(context); // close dialog after scan time
      Navigator.pushNamed(context, RoutesName.DietDetailsScreen);
    });
  }

  List<Map<String, dynamic>> heightRoutineList = [
    {
      'time': 'Neck Stretches',
      'activity': '3 min exercises',
      'details': 'Tilt head left & right for 10 seconds',
    },
    {
      'time': 'Spine Alignment',
      'activity': '5 min exercises',
      'details': 'Sit straight and stretch your spine',
    },
  ];

  int selectedIndex = -1; // ✔ tick state
  int expandedIndex = -1; // ⬇️ dropdown state

  /// ✔ Tick logic (circle tap only)
  void selectPlan(int index) {
    selectedIndex = selectedIndex == index ? -1 : index;
    notifyListeners();
  }

  /// ⬇️ Expand logic (arrow tap only)
  void toggleExpand(int index) {
    expandedIndex = expandedIndex == index ? -1 : index;
    notifyListeners();
  }

  bool isPlanSelected(int index) => selectedIndex == index;
  bool isExpanded(int index) => expandedIndex == index;
}
