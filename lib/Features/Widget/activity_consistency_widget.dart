import 'package:flutter/material.dart';
import 'package:looklabs/Features/Widget/linear_slider_widget.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class ActivityConsistencyWidget extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final double? pressentage;
  const ActivityConsistencyWidget({
    super.key,
    this.title,
    this.subtitle,
    this.pressentage,
  });

  @override
  Widget build(BuildContext context) {
    return PlanContainer(
      padding: context.paddingSymmetricR(horizontal: 12, vertical: 12),
      isSelected: false,
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NormalText(
            titleText: title,
            titleSize: context.sp(18),
            titleWeight: FontWeight.w600,
            titleColor: AppColors.subHeadingColor,
            sizeBoxheight: context.sh(12),
            subText: subtitle,
            subWeight: FontWeight.w600,
            subColor: AppColors.iconColor,
            subSize: context.sp(14),
          ),
          SizedBox(height: context.sh(16)),
          LinearSliderWidget(
            progress: pressentage ?? 10,
            height: context.sh(20),
            animatedConHeight: context.sh(20),
          ),
          SizedBox(height: context.sh(12)),
        ],
      ),
    );
  }
}
