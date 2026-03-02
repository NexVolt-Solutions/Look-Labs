import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/setting_continer.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_text.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final authVm = context.read<AuthViewModel>();
      if (authVm.isLoggedIn && authVm.profile == null) {
        authVm.fetchProfile();
      }
    });
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
        : '—';

    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: SafeArea(
        child: ListView(
          children: [
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.center,
              titleText: AppText.setting,
              titleSize: context.sp(20),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
            SizedBox(height: context.sh(29)),
            Center(
              child: Container(
                padding: EdgeInsets.all(context.sw(4)),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.backGroundColor,
                    width: context.sw(1.5),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.customContainerColorUp.withOpacity(0.4),
                      offset: const Offset(5, 5),
                      blurRadius: 5,
                    ),
                    BoxShadow(
                      color: AppColors.customContinerColorDown.withOpacity(0.4),
                      offset: const Offset(-5, -5),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: ClipOval(
                    child: profileImage != null && profileImage.isNotEmpty
                        ? Image.network(
                            profileImage,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                _avatarLetter(avatarLabel),
                          )
                        : _avatarLetter(avatarLabel),
                  ),
                ),
              ),
            ),

            Padding(
              padding: context.paddingSymmetricR(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NormalText(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    titleText: AppText.personalInformation,
                    titleSize: context.sp(18),
                    titleWeight: FontWeight.w600,
                    titleColor: AppColors.subHeadingColor,
                  ),
                  SvgPicture.asset(
                    AppAssets.editIcon,
                    height: context.sh(24),
                    width: context.sw(24),
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
            SettingContainer(
              items: settingVM.personalInfo,
              viewModel: settingVM,
            ),
            _sectionHeader(context, AppText.account),
            SettingContainer(
              items: settingVM.paymentInfo,
              viewModel: settingVM,
            ),
            _sectionHeader(context, AppText.preferencesAndSupport),
            SettingContainer(
              items: settingVM.appSettings,
              viewModel: settingVM,
            ),
            SizedBox(height: context.sh(250)),
          ],
        ),
      ),
    );
  }

  Widget _avatarLetter(String label) {
    return Container(
      width: 100,
      height: 100,
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w600,
          color: AppColors.iconColor,
        ),
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(
        left: context.sw(20),
        right: context.sw(20),
        top: context.sh(12),
        bottom: context.sh(12),
      ),
      child: NormalText(
        crossAxisAlignment: CrossAxisAlignment.start,
        titleText: title,
        titleSize: context.sp(18),
        titleWeight: FontWeight.w600,
        titleColor: AppColors.subHeadingColor,
      ),
    );
  }
}
