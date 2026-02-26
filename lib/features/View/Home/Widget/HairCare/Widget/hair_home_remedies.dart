import 'package:flutter/material.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class HairHomeRemedies extends StatelessWidget {
  const HairHomeRemedies({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      body: SafeArea(
        child: ListView(
          padding: context.paddingSymmetricR(horizontal: 20),
          children: [
            AppBarContainer(
              title: 'Hair Home Remedies',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.sh(20)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'Recommended Home Remedies',
              titleSize: context.sp(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.headingColor,
            ),
            SizedBox(height: context.sh(20)),
            PlanContainer(
              isSelected: false,
              onTap: () {},
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: context.sh(10)),
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
                                  fontSize: context.sp(18),
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.subHeadingColor,
                                ),
                              ),
                              SizedBox(height: context.sh(4)),
                              ...List.generate(2, (index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom: context.sh(6),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '• ', // Dot bullet
                                        style: TextStyle(
                                          fontSize: context.sp(12),
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.iconColor,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          'AM or PM (during hair wash)',
                                          style: TextStyle(
                                            fontSize: context.sp(12),
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.iconColor,
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: context.sh(16)),
            NormalText(
              crossAxisAlignment: CrossAxisAlignment.start,
              titleText: 'Saftey Tips:',
              titleSize: context.sp(18),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.headingColor,
            ),
            SizedBox(height: context.sh(12)),
            ...List.generate(2, (index) {
              return Padding(
                padding: EdgeInsets.only(bottom: context.sh(6)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ', // Dot bullet
                      style: TextStyle(
                        fontSize: context.sp(12),
                        fontWeight: FontWeight.w500,
                        color: AppColors.subHeadingColor,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'AM or PM (during hair wash)',
                        style: TextStyle(
                          fontSize: context.sp(16),
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
