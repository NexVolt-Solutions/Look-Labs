import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';

class TopProductViewModel extends ChangeNotifier {
  PageController pageController = PageController();
  int currentIndex = 0;

  void next() {
    if (currentIndex < productData.length - 1) {
      currentIndex++;
      pageController.animateToPage(
        currentIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      notifyListeners();
    }
  }

  void goToPage(int index) {
    currentIndex = index;
    pageController.animateToPage(
      currentIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    notifyListeners();
  }

  int selectedIndex = -1;

  void selectProduct(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  final List<Map<String, dynamic>> productData = [
    {
      'rightIcon': AppAssets.nightIcon,
      'rightText': 'PM',
      'title': 'Oil-Control Shampoo',
      'description': 'Controls excess oil while keeping scalp healthy',
      'buttonText': ['Product Buildup', 'Oily Scalp', 'Excess Sebum'],
    },
    {
      'rightIcon': AppAssets.nightIcon,
      'title': 'Lightweight Scalp Serum',
      'description': 'Non-greasy nourishment for daily scalp care',
      'buttonText': ['Weak Roots', 'Scalp Dryness', 'Hair Thinning Support'],
    },
    {
      'rightIcon': AppAssets.nightIcon,
      'rightText': 'PM',
      'title': 'Minoxidil Foam',
      'description': 'Clinically backed support for hair regrowth',
      'buttonText': ['Hair Thinning', 'Hair Fall', 'Low Density Areas'],
    },
  ];

  final bool isSelected = false;

  get usageSteps => null;
}
