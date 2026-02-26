import 'package:flutter/material.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class GoalActivityGraph extends StatelessWidget {
  final double? currentHeight;
  final double? desiredHeight;
  final String? title1;
  final String? title2;

  const GoalActivityGraph({
    super.key,
    this.currentHeight,
    this.desiredHeight,
    this.title1,
    this.title2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // 🔹 Current Container
        Column(
          children: [
            NormalText(
              titleText: '$currentHeight cm',
              titleSize: context.sp(12),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
            SizedBox(height: context.sh(15)),
            Container(
              width: context.sw(55),
              height: context.sh(197),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(context.radiusR(10)),
                  topRight: Radius.circular(context.radiusR(10)),
                ),
                border: Border.all(
                  color: AppColors.backGroundColor,
                  width: context.sw(1.5),
                ),
                color: AppColors.backGroundColor,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.customContainerColorUp.withOpacity(0.4),
                    offset: const Offset(5, 5),
                    blurRadius: 5,
                  ),
                  BoxShadow(
                    color: AppColors.customContinerColorDown.withOpacity(0.4),
                    offset: const Offset(-5, -5),
                    blurRadius: 5,
                  ),
                ],
              ),
            ),
            SizedBox(height: context.sh(15)),
            NormalText(
              titleText: title1 ?? '',
              titleSize: context.sp(14),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
          ],
        ),

        SizedBox(width: context.sw(16)),

        // 🔹 Goal Container
        Column(
          children: [
            NormalText(
              titleText: '$desiredHeight cm',
              titleSize: context.sp(12),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
            SizedBox(height: context.sh(15)),
            Container(
              width: context.sw(55),
              height: context.sh(220),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(context.radiusR(10)),
                  topRight: Radius.circular(context.radiusR(10)),
                ),
                border: Border.all(
                  color: AppColors.pimaryColor,
                  width: context.sw(1.5),
                ),
                color: AppColors.pimaryColor,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.pimaryColor.withOpacity(.3),
                    offset: Offset(5, 5),
                    blurRadius: 20,
                  ),
                  BoxShadow(
                    color: AppColors.pimaryColor.withOpacity(.1),
                    offset: Offset(-5, -5),
                    blurRadius: 20,
                  ),
                ],
              ),
            ),
            SizedBox(height: context.sh(15)),
            NormalText(
              titleText: title2 ?? '',
              titleSize: context.sp(14),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
          ],
        ),
      ],
    );
  }
}
