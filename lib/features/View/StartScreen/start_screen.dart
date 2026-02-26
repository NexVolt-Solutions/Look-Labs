import 'package:flutter/material.dart';
import 'package:looklabs/Features/Widget/custom_button.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_text.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

import '../../../Core/Routes/routes_name.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pimaryColor,
      bottomNavigationBar: Padding(
        padding: context.paddingOnlyR(bottom: 20, left: 20, right: 20),
        child: CustomButton(
          isEnabled: true,
          onTap: () => Navigator.pushNamed(context, RoutesName.QuestionScreen),
          text: AppText.getStarted,
          colorText: AppColors.headingColor,
          color: AppColors.white,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(context.radiusR(12)),
                  bottomRight: Radius.circular(context.radiusR(12)),
                ),
                child: SizedBox(
                  width: context.screenWidth,
                  height: context.sh(600),

                  child: Image.asset(AppAssets.splashImage, fit: BoxFit.cover),
                ),
              ),
              SizedBox(height: context.sh(16)),
              NormalText(
                crossAxisAlignment: CrossAxisAlignment.center,
                titleText: AppText.becomeTheChadYouWere,
                titleSize: context.sp(24),
                titleWeight: FontWeight.w600,
                titleColor: AppColors.white,
                titleAlign: TextAlign.center,
                sizeBoxheight: context.sh(8),
                subText: AppText.buildStrongHabits,
                subSize: context.sp(16),
                subWeight: FontWeight.w400,
                subColor: AppColors.white,
                subAlign: TextAlign.center,
              ),
              SizedBox(height: context.sh(16)),
            ],
          ),
        ),
      ),
    );
  }
}
