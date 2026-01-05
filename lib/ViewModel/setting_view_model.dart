import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/View/Setting/PrivacyPolicyScreen/privacy_policy_screen.dart';
import 'package:looklabs/View/Setting/TermsScreen/terms_screen.dart';

class SettingViewModel extends ChangeNotifier {
  List<Map<String, dynamic>> personalInfo = [
    {'icon': AppAssets.nameIcon, 'title': 'Full Name', 'value': 'Shehzad'},
    {'icon': AppAssets.emailIcon, 'title': 'Email', 'value': 'Shezikhan2014'},
    {'icon': AppAssets.ageIcon, 'title': 'Age', 'value': '25'},
    {'icon': AppAssets.genderIcon, 'title': 'Gender', 'value': 'Male'},
  ];
  void onItemTap(Map<String, dynamic> item, BuildContext context) {
    switch (item['title']) {
      case 'Privacy Policy':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
        );
        break;

      case 'Terms of Service':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TermsScreen()),
        );
        break;

      case 'Sign Out':
        // showDialog(context: context, builder: (_) => const SignOutDialog());
        break;
    }
  }

  // Section 2 – Payment
  List<Map<String, dynamic>> paymentInfo = [
    {
      'icon': AppAssets.paymentIcon,
      'title': 'Payment Method',
      'value': '03XXXXXXXXX',
    },
  ];

  // Section 3 – App Settings

  List<Map<String, dynamic>> appSettings = [
    {
      'icon': AppAssets.settingNotifIcon,
      'title': 'Notification',
      'isSwitch': true,
      'value': false,
    },
    {
      'icon': AppAssets.settingPrivacyIcon,
      'title': 'Privacy Policy',
      'isArrow': true,
    },
    {
      'icon': AppAssets.settingTermIcon,
      'title': 'Terms of Service',
      'isArrow': true,
    },
    {'icon': AppAssets.signOutIcon, 'title': 'Sign Out', 'isArrow': true},
  ];

  void toggleNotification(int index, bool value) {
    appSettings[index]['value'] = value;
    notifyListeners();
  }
}
