import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/Widget/custom_container.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class LinearCustomIndicator extends StatelessWidget {
  final double? height;
  final double? wedth;
  const LinearCustomIndicator({super.key, this.height, this.wedth});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomContainer(
          width: wedth ?? context.w(264),
          height: height ?? context.h(10),
          radius: context.radius(10),
          padding: EdgeInsets.zero,
          color: AppColors.backGroundColor,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(context.radius(10)),
            child: LinearPercentIndicator(
              padding: EdgeInsets.zero,
              width: context.w(264),
              lineHeight: context.h(10),
              percent: 0.5,
              backgroundColor: AppColors.backGroundColor,
              progressColor: AppColors.pimaryColor,
              barRadius: Radius.circular(context.radius(10)),
            ),
          ),
        ),
      ],
    );
  }
}
