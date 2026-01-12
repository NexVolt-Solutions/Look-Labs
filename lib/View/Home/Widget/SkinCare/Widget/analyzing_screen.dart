import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/Widget/app_bar_container.dart';
import 'package:looklabs/Core/Constants/Widget/custom_button.dart';
import 'package:looklabs/Core/Constants/Widget/linear_custom_indicator.dart';
import 'package:looklabs/Core/Constants/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/utils/Routes/routes_name.dart';

class AnalyzingScreen extends StatefulWidget {
  const AnalyzingScreen({super.key});

  @override
  State<AnalyzingScreen> createState() => _AnalyzingScreenState();
}

class _AnalyzingScreenState extends State<AnalyzingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      bottomNavigationBar: CustomButton(
        text: 'next',
        color: AppColors.pimaryColor,
        isEnabled: true,
        onTap: () {
          Navigator.pushNamed(context, RoutesName.DailyHairCareRoutineScreen);
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
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.center,
              titleText: 'Analyzing your hair ',
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
              percent: 0.5, // 50%
            ),
            SizedBox(height: context.h(23)),
            ...List.generate(5, (index) {
              return Padding(
                padding: context.padSym(v: 10),
                child: Row(
                  children: [
                    Container(
                      height: context.h(4),
                      width: context.w(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.pimaryColor,
                      ),
                    ),
                    SizedBox(width: context.w(10)),
                    NormalText(
                      titleText: 'Dry and flaky scalp patches',
                      titleSize: context.text(14),
                      titleWeight: FontWeight.w400,
                      titleColor: AppColors.subHeadingColor,
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
