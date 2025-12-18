import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class NormalText extends StatelessWidget {
  final String? titleText;
  final String? subText;

  final double? titleSize;
  final double? subSize;

  final FontWeight? titleWeight;
  final FontWeight? subWeight;

  final Color? titleColor;
  final Color? subColor;

  final TextAlign? titleAlign;
  final TextAlign? subAlign;
  final CrossAxisAlignment? crossAxisAlignment;

  const NormalText({
    super.key,
    this.titleText,
    this.subText,
    this.titleSize,
    this.subSize,
    this.titleWeight,
    this.subWeight,
    this.titleColor,
    this.subColor,
    this.titleAlign,
    this.subAlign,
    this.crossAxisAlignment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
      children: [
        if (titleText != null)
          Text(
            titleText!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: titleColor ?? AppColors.headingColor,
              fontSize: titleSize ?? context.text(16),
              fontWeight: titleWeight ?? FontWeight.w500,
              fontFamily: 'Raleway',
            ),
            textAlign: titleAlign ?? TextAlign.start,
          ),

        if (subText != null)
          Text(
            subText!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: subColor ?? AppColors.headingColor,
              fontSize: subSize ?? context.text(14),
              fontWeight: subWeight ?? FontWeight.w400,
              fontFamily: 'Raleway',
            ),
            textAlign: subAlign ?? TextAlign.start,
          ),
      ],
    );
  }
}
