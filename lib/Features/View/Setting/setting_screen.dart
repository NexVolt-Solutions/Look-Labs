import 'package:flutter/cupertino.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:looklabs/Core/Constants/app_text.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/Network/api_error_handler.dart';
import 'package:looklabs/Features/View/Setting/Widget/Sections/setting_screen_sections.dart';
import 'package:looklabs/Features/ViewModel/auth_view_model.dart';
import 'package:looklabs/Features/ViewModel/setting_view_model.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final SettingViewModel settingVM = SettingViewModel();

  @override
  void initState() {
    super.initState();
    settingVM.addListener(_onSettingVMUpdate);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final authVm = context.read<AuthViewModel>();
      if (authVm.isLoggedIn && authVm.profile == null) {
        authVm.fetchProfile();
      }
    });
  }

  @override
  void dispose() {
    settingVM.removeListener(_onSettingVMUpdate);
    super.dispose();
  }

  void _onSettingVMUpdate() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();
    final user = authVm.user;
    final profile = authVm.profile;
    settingVM.updateFromUser(
      name: user?.name ?? profile?.name,
      email: user?.email ?? profile?.email,
      age: profile?.age?.toString(),
      gender: profile?.gender,
    );

    final name = user?.name ?? profile?.name;
    final email = user?.email ?? profile?.email;
    final profileImage = user?.profileImage ?? profile?.profileImage;
    final avatarLabel = (name != null && name.isNotEmpty)
        ? name.substring(0, 1).toUpperCase()
        : (email != null && email.isNotEmpty)
        ? email.substring(0, 1).toUpperCase()
        : '';

    return SafeArea(
      child: ListView(
        children: [
          SizedBox(height: context.sh(24)),
          const SettingsTitleSection(),
          SizedBox(height: context.sh(16)),
          SettingsAvatarSection(
            profileImage: profileImage,
            avatarLabel: avatarLabel,
          ),
          SettingsPersonalInfoSection(
            settingVM: settingVM,
            onActionTap: () => _onPersonalInfoAction(context),
          ),
          SettingsGroupSection(
            title: AppText.account,
            items: settingVM.paymentInfo,
            settingVM: settingVM,
          ),
          SettingsGroupSection(
            title: AppText.preferencesAndSupport,
            items: settingVM.appSettings,
            settingVM: settingVM,
          ),
          SizedBox(height: context.sh(250)),
        ],
      ),
    );
  }

  void _onPersonalInfoAction(BuildContext context) {
    if (!settingVM.isEditMode) {
      settingVM.startEditMode();
      return;
    }
    _showSavingDialog(context);
    settingVM.saveProfile(context).then((success) {
      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ApiErrorHandler.showSnackBar(
          context,
          fallback: 'Failed to update profile. Please try again.',
        );
      }
    });
  }

  void _showSavingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [const CupertinoActivityIndicator()],
            ),
          ),
        ),
      ),
    );
  }
}
