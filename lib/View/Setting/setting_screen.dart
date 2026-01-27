import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Core/Constants/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/Widget/setting_continer.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/ViewModel/setting_view_model.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final SettingViewModel settingVM = SettingViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: SafeArea(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.center,
              titleText: 'Setting',
              titleSize: context.text(20),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
            SizedBox(height: context.h(29)),
            Container(
              padding: context.padSym(h: 137.5, v: 37.5),
              decoration: BoxDecoration(color: AppColors.white),
              child: Container(
                padding: context.padAll(38),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // borderRadius: ra BorderRadius.circular(context.radius(10)),
                  border: Border.all(
                    color: AppColors.backGroundColor,
                    width: context.w(1.5),
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
                  titleText: 'Aj',
                  titleSize: context.text(20),
                  titleWeight: FontWeight.w600,
                  titleColor: AppColors.iconColor,
                ),
              ),
            ),

            Padding(
              padding: context.padSym(h: 20, v: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NormalText(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    titleText: 'Personal Information ',
                    titleSize: context.text(18),
                    titleWeight: FontWeight.w600,
                    titleColor: AppColors.subHeadingColor,
                  ),
                  SvgPicture.asset(
                    AppAssets.editIcon,
                    height: context.h(24),
                    width: context.w(24),
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
            SettingContainer(
              items: settingVM.personalInfo,
              viewModel: settingVM,
            ),
            SizedBox(height: context.h(12)),
            Padding(
              padding: context.padSym(h: 20),
              child: NormalText(
                crossAxisAlignment: CrossAxisAlignment.start,
                titleText: 'Account',
                titleSize: context.text(18),
                titleWeight: FontWeight.w600,
                titleColor: AppColors.subHeadingColor,
              ),
            ),
            SizedBox(height: context.h(12)),
            SettingContainer(
              items: settingVM.paymentInfo,
              viewModel: settingVM,
            ),
            SizedBox(height: context.h(12)),
            Padding(
              padding: context.padSym(h: 20),
              child: NormalText(
                crossAxisAlignment: CrossAxisAlignment.start,
                titleText: 'Preferences & Support',
                titleSize: context.text(18),
                titleWeight: FontWeight.w600,
                titleColor: AppColors.subHeadingColor,
              ),
            ),
            SizedBox(height: context.h(12)),
            SettingContainer(
              items: settingVM.appSettings,
              viewModel: settingVM,
            ),
            SizedBox(height: context.h(250)),
          ],
        ),
      ),
    );
  }
}
