import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/app_text.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/custom_button.dart';
import 'package:looklabs/Features/Widget/linear_slider_widget.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';

class FashionAnalyzingScreen extends StatefulWidget {
  const FashionAnalyzingScreen({super.key});

  @override
  State<FashionAnalyzingScreen> createState() => _FashionAnalyzingScreenState();
}

class _FashionAnalyzingScreenState extends State<FashionAnalyzingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      bottomNavigationBar: Padding(
        padding: EdgeInsetsGeometry.only(
          top: context.sh(5),
          left: context.sw(20),
          right: context.sw(20),
          bottom: context.sh(30),
        ),
        child: CustomButton(
          text: AppText.next,
          color: AppColors.pimaryColor,
          isEnabled: true,
          onTap: () {
            Navigator.pushNamed(context, RoutesName.FashionProfileScreen);
          },
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: context.paddingSymmetricR(horizontal: 20),
          children: [
            AppBarContainer(
              title: AppText.analyzing,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.sh(32)),
            SizedBox(
              // width: context.sw(60),
              // height: context.sh(60),
              child: CupertinoActivityIndicator(
                radius: 50,
                color: AppColors.pimaryColor,
              ),
            ),
            SizedBox(height: context.sh(24)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.center,
              titleText: AppText.analyzingYourStyle,
              titleSize: context.sp(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.headingColor,
              subText: AppText.aiStudyingStyle,
              subSize: context.sp(14),
              subWeight: FontWeight.w400,
              subColor: AppColors.subHeadingColor,
              sizeBoxheight: context.sh(4),
              subAlign: TextAlign.center,
            ),
            SizedBox(height: context.sh(24)),
            Padding(
              padding: context.paddingSymmetricR(horizontal: 56),
              child: LinearSliderWidget(
                showTopIcon: true,
                progress: 20,
                inset: false,
                height: context.sh(10),
                animatedConHeight: context.sh(10),
                showPercentage: false,
              ),
            ),
            SizedBox(height: context.sh(24)),
            ...List.generate(4, (index) {
              return Padding(
                padding: EdgeInsets.only(bottom: context.sh(18)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ', // Dot bullet
                      style: TextStyle(
                        fontSize: context.sp(16),
                        fontWeight: FontWeight.w400,
                        color: AppColors.subHeadingColor,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        AppText.darkCirclesUnderEyes,
                        style: TextStyle(
                          fontSize: context.sp(12),
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
