import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';

class AllTrackedFood extends StatefulWidget {
  const AllTrackedFood({super.key});

  @override
  State<AllTrackedFood> createState() => _AllTrackedFoodState();
}

class _AllTrackedFoodState extends State<AllTrackedFood> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backGroundColor,

      body: SafeArea(
        child: ListView(
          padding: context.paddingSymmetricR(horizontal: 20),
          children: [
            AppBarContainer(
              title: 'All Tracked Foods',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.sh(24)),

            NormalText(
              titleText: 'All Foods',
              titleSize: context.sp(18),
              titleColor: AppColors.subHeadingColor,
              titleWeight: FontWeight.w600,
            ),

            ...List.generate(3, (index) {
              return PlanContainer(
                padding: context.paddingSymmetricR(horizontal: 12, vertical: 12),
                isSelected: false,
                onTap: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    NormalText(
                      titleText: 'Greek Yogurt',
                      titleSize: context.sp(16),
                      titleColor: AppColors.subHeadingColor,
                      titleWeight: FontWeight.w500,
                      subText: 'Breakfast',
                      subSize: context.sp(12),
                      subWeight: FontWeight.w600,
                      subColor: AppColors.iconColor,
                    ),
                    NormalText(
                      titleText: '150 kcal',
                      titleSize: context.sp(16),
                      titleColor: AppColors.redColor,
                      titleWeight: FontWeight.w600,
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
