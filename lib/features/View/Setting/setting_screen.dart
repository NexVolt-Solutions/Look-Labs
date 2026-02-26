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
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();
    final user = authVm.user;
    settingVM.updateFromUser(
      name: user?.name,
      email: user?.email,
    );

    final name = user?.name;
    final email = user?.email;
    final avatarLabel = (name != null && name.isNotEmpty)
        ? name.substring(0, 1).toUpperCase()
        : (email != null && email.isNotEmpty)
            ? email.substring(0, 1).toUpperCase()
            : '—';

    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: SafeArea(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.center,
              titleText: AppText.setting,
              titleSize: context.sp(20),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
            SizedBox(height: context.sh(29)),
            Container(
              padding: context.paddingSymmetricR(horizontal: 137.5, vertical: 37.5),
              decoration: BoxDecoration(color: AppColors.white),
              child: Container(
                padding: context.paddingAllR(38),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // borderRadius: ra BorderRadius.circular(context.radiusR(10)),
                  border: Border.all(
                    color: AppColors.backGroundColor,
                    width: context.sw(1.5),
                  ),
                  color: AppColors.backGroundColor,
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
                child: NormalText(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  titleText: avatarLabel,
                  titleSize: context.sp(20),
                  titleWeight: FontWeight.w600,
                  titleColor: AppColors.iconColor,
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
            SizedBox(height: context.sh(12)),
            Padding(
              padding: context.paddingSymmetricR(horizontal: 20),
              child: NormalText(
                crossAxisAlignment: CrossAxisAlignment.start,
                titleText: AppText.account,
                titleSize: context.sp(18),
                titleWeight: FontWeight.w600,
                titleColor: AppColors.subHeadingColor,
              ),
            ),
            SizedBox(height: context.sh(12)),
            SettingContainer(
              items: settingVM.paymentInfo,
              viewModel: settingVM,
            ),
            SizedBox(height: context.sh(12)),
            Padding(
              padding: context.paddingSymmetricR(horizontal: 20),
              child: NormalText(
                crossAxisAlignment: CrossAxisAlignment.start,
                titleText: AppText.preferencesAndSupport,
                titleSize: context.sp(18),
                titleWeight: FontWeight.w600,
                titleColor: AppColors.subHeadingColor,
              ),
            ),
            SizedBox(height: context.sh(12)),
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
}
