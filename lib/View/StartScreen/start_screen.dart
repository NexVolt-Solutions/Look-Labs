import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/Widget/custom_button.dart';
import 'package:looklabs/Core/Constants/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

import '../../Core/utils/Routes/routes_name.dart';

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
      bottomNavigationBar: CustomButton(
        isEnabled: true,
        onTap: () => Navigator.pushNamed(context, RoutesName.QuestionScreen),
        text: 'Get Started',
        colorText: AppColors.headingColor,
        color: AppColors.white,
        padding: context.padSym(v: 18.5, h: 124),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Image.asset(AppAssets.splashImage, fit: BoxFit.fill),
            SizedBox(height: context.h(28)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.center,
              titleText: 'Become the Chad You Were',
              titleSize: context.text(24),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.white,
              titleAlign: TextAlign.center,
              sizeBoxheight: context.h(8),
              subText:
                  'Build strong habits every day, Train your body and mind Become your best version',
              subSize: context.text(16),
              subWeight: FontWeight.w400,
              subColor: AppColors.white,
              subAlign: TextAlign.center,
            ),
            SizedBox(height: context.h(40)),
          ],
        ),
      ),
    );
  }
}
