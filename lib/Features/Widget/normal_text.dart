import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class NormalText extends StatelessWidget {
  final String? titleText;
  final String? subText;

  final double? titleSize;
  final double? subSize;
  final double? sizeBoxheight;

  final FontWeight? titleWeight;
  final FontWeight? subWeight;

  final Color? titleColor;
  final Color? subColor;

  final TextAlign? titleAlign;
  final TextAlign? subAlign;
  final CrossAxisAlignment? crossAxisAlignment;

  /// 🔥 OPTIONAL CONTROL
  final int? maxLines;
  final TextOverflow? overflow;
  final int? subMaxLines;
  final TextOverflow? subOverflow;
  final TextDecoration? titleDecoration;
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
    this.sizeBoxheight,
    this.maxLines,
    this.overflow,
    this.subMaxLines,
    this.subOverflow,
    this.titleDecoration,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (titleText != null)
          Flexible(
            child: Text(
              titleText!,
              softWrap: true,
              maxLines: maxLines,
              overflow: overflow ?? TextOverflow.visible,
              style: TextStyle(
                color: titleColor ?? AppColors.headingColor,
                fontSize: titleSize ?? context.sp(14),
                fontWeight: titleWeight ?? FontWeight.w600,
                fontFamily: 'Raleway',
                decoration: titleDecoration ?? TextDecoration.none,
              ),
              textAlign: titleAlign ?? TextAlign.start,
            ),
          ),

        if (sizeBoxheight != null) SizedBox(height: sizeBoxheight),

        if (subText != null)
          Text(
            subText!,
            softWrap: true,
            maxLines: subMaxLines,
            overflow: subOverflow ?? TextOverflow.visible,
            style: TextStyle(
              color: subColor ?? AppColors.subHeadingColor,
              fontSize: subSize ?? context.sp(12),
              fontWeight: subWeight ?? FontWeight.w400,
              fontFamily: 'Raleway',
            ),
            textAlign: subAlign ?? TextAlign.start,
          ),
      ],
    );
  }
}
