import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_text.dart';
import 'package:looklabs/Features/View/Setting/PrivacyPolicyScreen/privacy_policy_screen.dart';
import 'package:looklabs/Features/View/Setting/TermsScreen/terms_screen.dart';

class SettingViewModel extends ChangeNotifier {
  List<Map<String, dynamic>> personalInfo = [
    {'icon': AppAssets.nameIcon, 'title': AppText.fullName, 'value': 'Shehzad'},
    {
      'icon': AppAssets.emailIcon,
      'title': AppText.email,
      'value': 'Shezikhan2014',
    },
    {'icon': AppAssets.ageIcon, 'title': AppText.age, 'value': '25'},
    {
      'icon': AppAssets.genderIcon,
      'title': AppText.gender,
      'value': AppText.male,
    },
  ];
  void onItemTap(Map<String, dynamic> item, BuildContext context) {
    switch (item['title']) {
      case AppText.privacyPolicy:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
        );
        break;

      case AppText.termsOfService:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TermsScreen()),
        );
        break;

      case AppText.signOut:
        // showDialog(context: context, builder: (_) => const SignOutDialog());
        break;
    }
  }

  // Section 2 – Payment
  List<Map<String, dynamic>> paymentInfo = [
    {
      'icon': AppAssets.paymentIcon,
      'title': AppText.paymentMethod,
      'value': '03XXXXXXXXX',
    },
  ];

  // Section 3 – App Settings

  List<Map<String, dynamic>> appSettings = [
    {
      'icon': AppAssets.settingNotifIcon,
      'title': AppText.notification,
      'isSwitch': true,
      'value': false,
    },
    {
      'icon': AppAssets.settingPrivacyIcon,
      'title': AppText.privacyPolicy,
      'isArrow': true,
    },
    {
      'icon': AppAssets.settingTermIcon,
      'title': AppText.termsOfService,
      'isArrow': true,
    },
    {'icon': AppAssets.signOutIcon, 'title': AppText.signOut, 'isArrow': true},
  ];

  void toggleNotification(int index, bool value) {
    appSettings[index]['value'] = value;
    notifyListeners();
  }
}
