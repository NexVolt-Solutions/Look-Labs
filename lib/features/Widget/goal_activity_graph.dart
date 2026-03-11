import 'package:flutter/material.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class GoalActivityGraph extends StatelessWidget {
  final double? currentHeight;
  final double? desiredHeight;
  final String? title1;
  final String? title2;
  final String? unit;
  final double? minValue;
  final double? maxValue;
  final double? maxBarHeight;

  const GoalActivityGraph({
    super.key,
    this.currentHeight,
    this.desiredHeight,
    this.title1,
    this.title2,
    this.unit,
    this.minValue,
    this.maxValue,
    this.maxBarHeight,
  });

  double _barHeight(BuildContext context, double? value, double containerH) {
    final min = minValue ?? 100;
    final max = maxValue ?? 250;
    if (value == null) return containerH * 0.3;
    final range = (max - min).clamp(1.0, double.infinity);
    final ratio = ((value - min) / range).clamp(0.0, 1.0);
    return (containerH * ratio).clamp(context.sh(40), containerH);
  }

  @override
  Widget build(BuildContext context) {
    final containerHeight = maxBarHeight ?? context.sh(220);
    final currentBarH = _barHeight(context, currentHeight, containerHeight);
    final desiredBarH = _barHeight(context, desiredHeight, containerHeight);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // 🔹 Current Container
        Column(
          children: [
            NormalText(
              titleText: '$currentHeight ${unit ?? 'cm'}',
              titleSize: context.sp(12),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
            SizedBox(height: context.sh(15)),
            SizedBox(
              height: containerHeight,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: context.sw(55),
                  height: currentBarH,
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
                        color: AppColors.customContainerColorUp.withOpacity(
                          0.4,
                        ),
                        offset: const Offset(5, 5),
                        blurRadius: 5,
                      ),
                      BoxShadow(
                        color: AppColors.customContinerColorDown.withOpacity(
                          0.4,
                        ),
                        offset: const Offset(-5, -5),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                ),
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
              titleText: '$desiredHeight ${unit ?? 'cm'}',
              titleSize: context.sp(12),
              titleWeight: FontWeight.w600,
              titleColor: AppColors.subHeadingColor,
            ),
            SizedBox(height: context.sh(15)),
            SizedBox(
              height: containerHeight,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: context.sw(55),
                  height: desiredBarH,
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
