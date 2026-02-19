import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_text.dart';
import 'package:provider/provider.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
import 'package:looklabs/Features/ViewModel/auth_view_model.dart';
import 'package:looklabs/Features/View/Setting/PrivacyPolicyScreen/privacy_policy_screen.dart';
import 'package:looklabs/Features/View/Setting/TermsScreen/terms_screen.dart';

class SettingViewModel extends ChangeNotifier {
  String _name = '';
  String _email = '';
  String _age = '';
  String _gender = '';

  List<Map<String, dynamic>> get personalInfo => [
        {'icon': AppAssets.nameIcon, 'title': AppText.fullName, 'value': _name},
        {'icon': AppAssets.emailIcon, 'title': AppText.email, 'value': _email},
        {'icon': AppAssets.ageIcon, 'title': AppText.age, 'value': _age},
        {'icon': AppAssets.genderIcon, 'title': AppText.gender, 'value': _gender},
      ];

  void updateFromUser({
    String? name,
    String? email,
    String? age,
    String? gender,
  }) {
    _name = name ?? '';
    _email = email ?? '';
    _age = age ?? '';
    _gender = gender ?? '';
    notifyListeners();
  }
  Future<void> onItemTap(
    Map<String, dynamic> item,
    BuildContext context,
  ) async {
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
        final authVm = Provider.of<AuthViewModel>(context, listen: false);
        await authVm.logout();
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesName.AuthScreen,
            (route) => false,
          );
        }
        break;
    }
  }

  String _paymentMask = '';

  List<Map<String, dynamic>> get paymentInfo => [
        {
          'icon': AppAssets.paymentIcon,
          'title': AppText.paymentMethod,
          'value': _paymentMask,
        },
      ];

  void updatePaymentMask(String? mask) {
    _paymentMask = mask ?? '';
    notifyListeners();
  }

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
