import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class LinearSliderWidget extends StatelessWidget {
  final double progress; // 0-100
  final double? height;
  final double? animatedConHeight;
  final bool? inset;
  final bool showPercentage;
  final bool showTopIcon; // NEW: show icon + top percentage

  const LinearSliderWidget({
    super.key,
    required this.progress,
    this.height,
    this.animatedConHeight,
    this.inset,
    this.showPercentage = true,
    this.showTopIcon = false, // default false
  });

  @override
  Widget build(BuildContext context) {
    final boundedProgress = progress.clamp(0, 100).toDouble();

    final iconWidth = context.sw(50);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showTopIcon)
              SizedBox(
                height: context.sh(36),
                width: constraints.maxWidth,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeOut,
                      left: (constraints.maxWidth - iconWidth) *
                          (boundedProgress / 100).clamp(0.0, 1.0),
                      top: 0,
                      width: iconWidth,
                      height: context.sh(36),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SvgPicture.asset(AppAssets.sugIcon, width: iconWidth),
                          Text(
                            '${boundedProgress.toInt()}%',
                            style: TextStyle(
                              fontSize: context.sp(12),
                              fontWeight: FontWeight.w600,
                              color: AppColors.headingColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: context.sh(4)),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: height ?? context.sh(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(context.radiusR(10)),
                      border: Border.all(
                        color: AppColors.backGroundColor,
                        width: context.sw(1.5),
                      ),
                      color: AppColors.backGroundColor,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.customContainerColorUp.withValues(
                            alpha: 0.4,
                          ),
                          offset: const Offset(5, 5),
                          blurRadius: 5,
                          inset: inset ?? true,
                        ),
                        BoxShadow(
                          color: AppColors.customContinerColorDown.withValues(
                            alpha: 0.4,
                          ),
                          offset: const Offset(-5, -5),
                          blurRadius: 5,
                          inset: inset ?? true,
                        ),
                      ],
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Stack(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              height: animatedConHeight ?? context.sh(20),
                              width:
                                  constraints.maxWidth *
                                  (boundedProgress / 100),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  context.radiusR(10),
                                ),
                                color: AppColors.pimaryColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.pimaryColor.withValues(
                                      alpha: 0.15,
                                    ),
                                    offset: const Offset(3, 3),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                if (showPercentage) SizedBox(width: context.sw(8)),
                if (showPercentage)
                  NormalText(
                    titleText: '${boundedProgress.toInt()}%',
                    titleSize: context.sp(12),
                    titleWeight: FontWeight.w600,
                    titleColor: AppColors.subHeadingColor,
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
