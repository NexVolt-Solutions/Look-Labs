import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/app_text.dart';
import 'package:provider/provider.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
import 'package:looklabs/Features/ViewModel/auth_view_model.dart';
import 'package:looklabs/Features/ViewModel/bottom_sheet_view_model.dart';
import 'package:looklabs/Features/View/Setting/PrivacyPolicyScreen/privacy_policy_screen.dart';
import 'package:looklabs/Features/View/Setting/TermsScreen/terms_screen.dart';
import 'package:looklabs/Features/Widget/delete_account_dialog.dart';
import 'package:looklabs/Repository/auth_repository.dart';

class SettingViewModel extends ChangeNotifier {
  String _name = '';
  String _email = '';
  String _age = '';
  String _gender = '';

  bool _isEditMode = false;
  String _editName = '';
  String _editAge = '';
  String _editGender = '';

  bool get isEditMode => _isEditMode;

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
    if (!_isEditMode) {
      _editName = _name;
      _editAge = _age;
      _editGender = _gender;
    }
    notifyListeners();
  }

  void startEditMode() {
    _isEditMode = true;
    _editName = _name;
    _editAge = _age;
    _editGender = _gender;
    notifyListeners();
  }

  void exitEditMode() {
    _isEditMode = false;
    notifyListeners();
  }

  String get editName => _editName;
  String get editAge => _editAge;
  String get editGender => _editGender;

  void setEditName(String v) {
    _editName = v;
    notifyListeners();
  }

  void setEditAge(String v) {
    _editAge = v;
    notifyListeners();
  }

  void setEditGender(String v) {
    _editGender = v;
    notifyListeners();
  }

  /// PATCH users/me with name, age, gender; refreshes profile and exits edit mode.
  Future<bool> saveProfile(BuildContext context) async {
    final body = <String, dynamic>{};
    final name = _editName.trim();
    if (name.isNotEmpty) body['name'] = name;
    final ageNum = int.tryParse(_editAge.trim());
    if (ageNum != null && ageNum > 0) body['age'] = ageNum;
    final gender = _editGender.trim();
    if (gender.isNotEmpty) body['gender'] = gender;

    final response = await AuthRepository.instance.updateProfile(body);
    if (!response.success) return false;

    if (!context.mounted) return false;
    final authVm = Provider.of<AuthViewModel>(context, listen: false);
    await authVm.fetchProfile();
    exitEditMode();
    return true;
  }

  static const List<String> genderOptions = [
    AppText.male,
    AppText.female,
    AppText.other,
  ];

  Future<void> onItemTap(
    Map<String, dynamic> item,
    BuildContext context,
  ) async {
    switch (item['title']) {
      case AppText.myAlbum:
        Navigator.pushNamed(context, RoutesName.MyAlbumScreen);
        break;

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
        await _performSignOut(context);
        break;

      case AppText.deleteAccount:
        await _performDeleteAccount(context);
        break;
    }
  }

  /// Signs out via API (POST auth/sign-out with refresh_token), clears local state, then navigates to auth.
  Future<void> _performSignOut(BuildContext context) async {
    final authVm = Provider.of<AuthViewModel>(context, listen: false);
    _showLoadingDialog(context);
    await authVm.logout();
    if (!context.mounted) return;
    // Reset bottom tab to Home so next login lands on Home
    try {
      Provider.of<BottomSheetViewModel>(context, listen: false).changeIndex(0);
    } catch (_) {}
    Navigator.of(context, rootNavigator: true).pop();
    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      RoutesName.AuthScreen,
      (route) => false,
    );
  }

  void _showLoadingDialog(
    BuildContext context, {
    String message = 'Signing out...',
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CupertinoActivityIndicator(
                  radius: 50,
                  color: AppColors.pimaryColor,
                ),
                const SizedBox(height: 16),
                Text(message),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Confirms with user, then calls DELETE users/me, clears session, navigates to auth.
  Future<void> _performDeleteAccount(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const DeleteAccountDialog(),
    );
    if (!context.mounted || confirmed != true) return;

    final authVm = Provider.of<AuthViewModel>(context, listen: false);
    _showLoadingDialog(context, message: AppText.deletingAccount);
    final success = await authVm.deleteAccount();
    if (!context.mounted) return;
    Navigator.of(context, rootNavigator: true).pop();
    if (success) {
      try {
        Provider.of<BottomSheetViewModel>(
          context,
          listen: false,
        ).changeIndex(0);
      } catch (_) {}
    }
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete account. Please try again.'),
        ),
      );
      return;
    }
    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      RoutesName.AuthScreen,
      (route) => false,
    );
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
    {'icon': AppAssets.galleryIcon, 'title': AppText.myAlbum, 'isArrow': true},
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
    {
      'icon': AppAssets.deleteAccountIcon,
      'title': AppText.deleteAccount,
      'isArrow': true,
    },
    {'icon': AppAssets.signOutIcon, 'title': AppText.signOut, 'isArrow': true},
  ];

  void toggleNotification(int index, bool value) {
    appSettings[index]['value'] = value;
    notifyListeners();
  }
}
