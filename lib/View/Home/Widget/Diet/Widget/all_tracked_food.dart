import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/Widget/app_bar_container.dart';
import 'package:looklabs/Core/Widget/normal_text.dart';
import 'package:looklabs/Core/Widget/plan_container.dart';

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
          padding: context.padSym(h: 20),
          children: [
            AppBarContainer(
              title: 'All Tracked Foods',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: context.h(24)),

            NormalText(
              titleText: 'All Foods',
              titleSize: context.text(18),
              titleColor: AppColors.subHeadingColor,
              titleWeight: FontWeight.w600,
            ),

            ...List.generate(3, (index) {
              return PlanContainer(
                padding: context.padSym(h: 12, v: 12),
                isSelected: false,
                onTap: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    NormalText(
                      titleText: 'Greek Yogurt',
                      titleSize: context.text(16),
                      titleColor: AppColors.subHeadingColor,
                      titleWeight: FontWeight.w500,
                      subText: 'Breakfast',
                      subSize: context.text(12),
                      subWeight: FontWeight.w600,
                      subColor: AppColors.iconColor,
                    ),
                    NormalText(
                      titleText: '150 kcal',
                      titleSize: context.text(16),
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
