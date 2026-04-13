import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:looklabs/Features/Widget/linear_slider_widget.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class TextAndIndectorContiner extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final String? pers;
  final double? progress;
  final bool usePlaceholderProgress;

  const TextAndIndectorContiner({
    super.key,
    this.title,
    this.subTitle,
    this.pers,
    this.progress,
    this.usePlaceholderProgress = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: context.paddingSymmetricR(horizontal: 20, vertical: 10),
      margin: context.paddingSymmetricR(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.radiusR(16)),
        color: AppColors.backGroundColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.customContainerColorUp.withValues(alpha: 0.4),
            offset: const Offset(5, 5),
            blurRadius: 5,
            inset: false,
          ),
          BoxShadow(
            color: AppColors.customContinerColorDown.withValues(alpha: 0.4),
            offset: const Offset(-5, -5),
            blurRadius: 5,
            inset: false,
          ),
        ],
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title ?? '',
            style: TextStyle(
              fontSize: context.sp(12),
              fontWeight: FontWeight.w600,
              color: AppColors.notSelectedColor,
            ),
          ),
          Text(
            subTitle ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: context.sp(16.32),
              fontWeight: FontWeight.w600,
              color: AppColors.subHeadingColor,
            ),
          ),
          if (progress != null || usePlaceholderProgress)
            LinearSliderWidget(
              showTopIcon: false,
              progress: progress ?? 0,
              inset: true,
              height: context.sh(10),
              animatedConHeight: context.sh(10),
              showPercentage: true,
            ),
        ],
      ),
    );
  }
}
