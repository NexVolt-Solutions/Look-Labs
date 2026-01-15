import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/Widget/app_bar_container.dart';
import 'package:looklabs/Core/Constants/Widget/custom_button.dart';
import 'package:looklabs/Core/Constants/Widget/linear_custom_indicator.dart';
import 'package:looklabs/Core/Constants/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/utils/Routes/routes_name.dart';

class SkinAnalyzingScreen extends StatelessWidget {
  const SkinAnalyzingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      bottomNavigationBar: CustomButton(
        text: 'Next',
        color: AppColors.pimaryColor,
        isEnabled: true,
        onTap: () {
          Navigator.pushNamed(context, RoutesName.SkinHomeRemediesScreen);
        },
        padding: context.padSym(h: 145, v: 17),
      ),
      body: SafeArea(
        child: ListView(
          padding: context.padSym(h: 20),
          children: [
            AppBarContainer(
              title: 'Analyzing',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.h(20)),
            SizedBox(
              // width: context.w(60),
              // height: context.h(60),
              child: CupertinoActivityIndicator(
                radius: 50,
                color: AppColors.pimaryColor,
              ),
            ),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.center,
              titleText: 'Analyzing your Skin',
              titleSize: context.text(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.headingColor,
              subText:
                  'AI is studying your hairs and preparing your personalized routine.',
              subSize: context.text(14),
              subWeight: FontWeight.w400,
              subColor: AppColors.subHeadingColor,
              sizeBoxheight: context.h(8),
              subAlign: TextAlign.center,
            ),
            SizedBox(height: context.h(12)),
            LinearCustomIndicator(
              percent: 0.2, // 50%
            ),
            SizedBox(height: context.h(23)),
            ...List.generate(4, (index) {
              return Padding(
                padding: EdgeInsets.only(bottom: context.h(6)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ', // Dot bullet
                      style: TextStyle(
                        fontSize: context.text(12),
                        fontWeight: FontWeight.w500,
                        color: AppColors.subHeadingColor,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Dark circles under eyes',
                        style: TextStyle(
                          fontSize: context.text(12),
                          fontWeight: FontWeight.w400,
                          color: AppColors.subHeadingColor,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
