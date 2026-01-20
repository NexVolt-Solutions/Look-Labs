import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:looklabs/Core/Constants/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class LinearSliderWidget extends StatelessWidget {
  final double? height;
  final double? animatedConHeight;
  const LinearSliderWidget({
    super.key,
    required this.progress,
    this.height,
    this.animatedConHeight,
  });

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: height ?? context.h(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(context.radius(10)),
              border: Border.all(
                color: AppColors.backGroundColor,
                width: context.w(1.5),
              ),
              color: AppColors.backGroundColor,
              boxShadow: [
                BoxShadow(
                  color: AppColors.customContainerColorUp.withOpacity(0.4),
                  offset: const Offset(5, 5),
                  blurRadius: 5,
                  inset: true,
                ),
                BoxShadow(
                  color: AppColors.customContinerColorDown.withOpacity(0.4),
                  offset: const Offset(-5, -5),
                  blurRadius: 5,
                  inset: true,
                ),
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      height: animatedConHeight ?? context.h(20),
                      width: constraints.maxWidth * (progress / 100),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.pimaryColor.withOpacity(0.1),
                            offset: const Offset(3, 3),
                            blurRadius: 4,
                          ),
                          BoxShadow(
                            color: AppColors.pimaryColor.withOpacity(0.1),
                            offset: const Offset(3, 3),
                            blurRadius: 4,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(context.radius(10)),
                        color: AppColors.pimaryColor,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        SizedBox(width: context.w(8)),
        NormalText(
          titleText: '${progress.toInt()}%',
          titleSize: context.text(12),
          titleWeight: FontWeight.w600,
          titleColor: AppColors.subHeadingColor,
        ),
      ],
    );
  }
}
