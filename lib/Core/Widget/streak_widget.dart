import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/Widget/normal_text.dart';

class StreakWidget extends StatelessWidget {
  final String? image;
  final String? title;
  final String? richTitle;
  final String? richSubTitle;

  // 🔹 Normal title options
  final double? titleSize;
  final FontWeight? titleWeight;
  final Color? titleColor;

  // 🔹 Rich text options
  final double? richTitleSize;
  final FontWeight? richTitleWeight;
  final Color? richTitleColor;

  final double? richSubTitleSize;
  final FontWeight? richSubTitleWeight;
  final Color? richSubTitleColor;

  const StreakWidget({
    super.key,
    this.image,
    this.title,
    this.richTitle,
    this.richSubTitle,

    // optional styles
    this.titleSize,
    this.titleWeight,
    this.titleColor,
    this.richTitleSize,
    this.richTitleWeight,
    this.richTitleColor,
    this.richSubTitleSize,
    this.richSubTitleWeight,
    this.richSubTitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: context.padSym(h: 4, v: 4),
          decoration: BoxDecoration(
            color: AppColors.backGroundColor,
            borderRadius: BorderRadius.circular(context.radius(10)),
            boxShadow: [
              BoxShadow(
                color: AppColors.customContainerColorUp.withOpacity(0.4),
                offset: const Offset(3, 3),
                blurRadius: 4,
              ),
              BoxShadow(
                color: AppColors.customContinerColorDown.withOpacity(0.4),
                offset: const Offset(-3, -3),
                blurRadius: 4,
              ),
            ],
          ),
          child: SizedBox(
            height: context.h(24),
            width: context.w(24),
            child: SvgPicture.asset(image!, fit: BoxFit.scaleDown),
          ),
        ),

        SizedBox(width: context.w(10)),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NormalText(
              titleText: title,
              titleSize: titleSize ?? context.text(16),
              titleWeight: titleWeight ?? FontWeight.w600,
              titleColor: titleColor ?? AppColors.iconColor,
            ),

            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: richTitle ?? '0',
                    style: TextStyle(
                      fontSize: richTitleSize ?? context.text(26),
                      fontWeight: richTitleWeight ?? FontWeight.w600,
                      color: richTitleColor ?? AppColors.subHeadingColor,
                    ),
                  ),
                  TextSpan(
                    text: richSubTitle ?? '',
                    style: TextStyle(
                      fontSize: richSubTitleSize ?? context.text(16),
                      fontWeight: richSubTitleWeight ?? FontWeight.w600,
                      color: richSubTitleColor ?? AppColors.subHeadingColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
