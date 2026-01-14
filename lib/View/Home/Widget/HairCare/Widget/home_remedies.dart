import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/Widget/app_bar_container.dart';
import 'package:looklabs/Core/Constants/Widget/custom_button.dart';
import 'package:looklabs/Core/Constants/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class HomeRemedies extends StatelessWidget {
  const HomeRemedies({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      bottomNavigationBar: CustomButton(
        text: 'next',
        color: AppColors.pimaryColor,
        isEnabled: true,
        onTap: () {},
        padding: context.padSym(h: 145, v: 17),
      ),
      body: SafeArea(
        child: ListView(
          padding: context.padSym(h: 20),
          children: [
            AppBarContainer(
              title: 'Hair Home Remedies',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.h(20)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'Recommended Home Remedies',
              titleSize: context.text(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.headingColor,
            ),
            SizedBox(height: context.h(20)),
            PlanContainer(
              isSelected: false,
              onTap: () {},
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: context.h(10)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '1. Aloe Vera Gel',
                                style: TextStyle(
                                  fontSize: context.text(18),
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.subHeadingColor,
                                ),
                              ),
                              SizedBox(height: context.h(4)),
                              Text(
                                'Use 2–3 times/week',
                                style: TextStyle(
                                  fontSize: context.text(14),
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.subHeadingColor,
                                ),
                              ),
                              SizedBox(height: context.h(4)),
                              Text(
                                'Soothes scalp, reduces itchiness, controls oil',
                                style: TextStyle(
                                  fontSize: context.text(14),
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.subHeadingColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: context.h(16)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'Saftey Tips:',
              titleSize: context.text(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.headingColor,
            ),
            SizedBox(height: context.h(12)),
            ...List.generate(2, (index) {
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
                        'AM or PM (during hair wash)',
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
