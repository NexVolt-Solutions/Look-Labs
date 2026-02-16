import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';

class SubscriptionPlanViewModel extends ChangeNotifier {
  int selectedIndex = -1;

  void selectPlan(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  bool isPlanSelected(int index) {
    return selectedIndex == index;
  }

  List<Map<String, dynamic>> subscriptionData = [
    {
      'title': 'AI-Powered Analysis',
      'subtitle':
          'Get personalized recommendations based on your unique features',
      'image': AppAssets.aiIcon,
    },
    {
      'title': 'Instant Transformation',
      'subtitle': 'See your glow-up potential with real-time AI previews',
      'image': AppAssets.instIcon,
    },

    {
      'title': 'Privacy First',
      'subtitle': 'Your photos are encrypted and never shared',
      'image': AppAssets.privacyIcon,
    },
    {
      'title': 'Premium Filters',
      'subtitle': 'Access 50+ exclusive enhancement filters',
      'image': AppAssets.premIcon,
    },
  ];
  List<Map<String, dynamic>> subscriptionPlan = [
    {
      'planName': 'Weekly',
      'price': '\$7.99',
      'planDuration': '/Weekly',
      'planRate': '0%',
    },
    {
      'planName': 'Monthly',
      'price': '\$19.99',
      'planDuration': '/monthly',
      'planRate': 'Save 40%',
    },
    {
      'planName': 'Lifetime',
      'price': '\$79.99',
      'planDuration': '/once',
      'planRate': 'Best Value',
    },
  ];
}
