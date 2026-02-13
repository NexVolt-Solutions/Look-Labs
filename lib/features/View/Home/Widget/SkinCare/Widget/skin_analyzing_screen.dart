import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/custom_button.dart';
import 'package:looklabs/Features/Widget/linear_slider_widget.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/apptext.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';

class SkinAnalyzingScreen extends StatelessWidget {
  const SkinAnalyzingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      bottomNavigationBar: Padding(
        padding: EdgeInsetsGeometry.only(
          top: context.h(5),
          left: context.w(20),
          right: context.w(20),
          bottom: context.h(30),
        ),
        child: CustomButton(
          text: AppText.next,
          color: AppColors.pimaryColor,
          isEnabled: true,
          onTap: () {
            Navigator.pushNamed(context, RoutesName.DailySkinCareRoutineScreen);
          },
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: context.padSym(h: 20),
          children: [
            AppBarContainer(
              title: AppText.analyzing,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.h(32)),
            SizedBox(
              // width: context.w(60),
              // height: context.h(60),
              child: CupertinoActivityIndicator(
                radius: 50,
                color: AppColors.pimaryColor,
              ),
            ),
            SizedBox(height: context.h(24)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.center,
              titleText: AppText.analyzingYourSkin,
              titleSize: context.text(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.headingColor,
              subText:
                  AppText.aiStudyingSkin,
              subSize: context.text(14),
              subWeight: FontWeight.w400,
              subColor: AppColors.subHeadingColor,
              sizeBoxheight: context.h(4),
              subAlign: TextAlign.center,
            ),
            SizedBox(height: context.h(24)),
            Padding(
              padding: context.padSym(h: 56),
              child: LinearSliderWidget(
                showTopIcon: true,
                progress: 20,
                inset: false,
                height: context.h(10),
                animatedConHeight: context.h(10),
                showPercentage: false,
              ),
            ),
            SizedBox(height: context.h(24)),
            ...List.generate(4, (index) {
              return Padding(
                padding: EdgeInsets.only(bottom: context.h(18)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ', // Dot bullet
                      style: TextStyle(
                        fontSize: context.text(16),
                        fontWeight: FontWeight.w400,
                        color: AppColors.subHeadingColor,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        AppText.darkCirclesUnderEyes,
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
