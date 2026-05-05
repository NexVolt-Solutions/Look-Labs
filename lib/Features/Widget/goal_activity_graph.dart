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

  Widget _barColumn({
    required BuildContext context,
    required double value,
    required double barHeight,
    required double containerHeight,
    required String bottomTitle,
    required bool isGoal,
    required String unitText,
  }) {
    final valueGap = context.sh(10);
    return Column(
      children: [
        SizedBox(
          height: containerHeight + context.sh(22),
          width: context.sw(74),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: context.sw(55),
                    height: barHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(context.radiusR(10)),
                        topRight: Radius.circular(context.radiusR(10)),
                      ),
                      border: Border.all(
                        color: isGoal
                            ? AppColors.pimaryColor
                            : AppColors.backGroundColor,
                        width: context.sw(1.5),
                      ),
                      color: isGoal
                          ? AppColors.pimaryColor
                          : AppColors.backGroundColor,
                      boxShadow: isGoal
                          ? [
                              BoxShadow(
                                color: AppColors.pimaryColor.withValues(alpha: .3),
                                offset: const Offset(5, 5),
                                blurRadius: 20,
                              ),
                              BoxShadow(
                                color: AppColors.pimaryColor.withValues(alpha: .1),
                                offset: const Offset(-5, -5),
                                blurRadius: 20,
                              ),
                            ]
                          : [
                              BoxShadow(
                                color: AppColors.customContainerColorUp.withValues(
                                  alpha: 0.4,
                                ),
                                offset: const Offset(5, 5),
                                blurRadius: 5,
                              ),
                              BoxShadow(
                                color: AppColors.customContinerColorDown.withValues(
                                  alpha: 0.4,
                                ),
                                offset: const Offset(-5, -5),
                                blurRadius: 5,
                              ),
                            ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: barHeight + valueGap,
                child: Center(
                  child: NormalText(
                    titleText: '${value.round()} $unitText',
                    titleSize: context.sp(12),
                    titleWeight: FontWeight.w600,
                    titleColor: AppColors.subHeadingColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: context.sh(15)),
        NormalText(
          titleText: bottomTitle,
          titleSize: context.sp(14),
          titleWeight: FontWeight.w600,
          titleColor: AppColors.subHeadingColor,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final containerHeight = maxBarHeight ?? context.sh(220);
    final current = currentHeight ?? 0;
    final desired = desiredHeight ?? 0;
    final currentBarH = _barHeight(context, current, containerHeight);
    final desiredBarH = _barHeight(context, desired, containerHeight);
    final unitText = unit ?? 'cm';

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _barColumn(
          context: context,
          value: current,
          barHeight: currentBarH,
          containerHeight: containerHeight,
          bottomTitle: title1 ?? '',
          isGoal: false,
          unitText: unitText,
        ),
        SizedBox(width: context.sw(16)),
        _barColumn(
          context: context,
          value: desired,
          barHeight: desiredBarH,
          containerHeight: containerHeight,
          bottomTitle: title2 ?? '',
          isGoal: true,
          unitText: unitText,
        ),
      ],
    );
  }
}
