import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  final Color? color;
  final Color? colorText;
  final BorderRadius? radius;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final bool isEnabled;
  final List<BoxShadow>? boxShadows;
  final CrossAxisAlignment? crossAxisAlignment; // ✅ optional

  const CustomButton({
    super.key,
    this.text,
    this.color,
    this.onTap,
    required this.isEnabled,
    this.colorText,
    this.boxShadows,
    this.radius,
    this.padding,
    this.crossAxisAlignment, // ✅
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        padding: context.paddingSymmetricR(vertical: 18),
        decoration: BoxDecoration(
          color: color,
          borderRadius: radius ?? BorderRadius.circular(context.radiusR(16)),
          boxShadow:
              boxShadows ??
              [
                BoxShadow(
                  offset: const Offset(-2.5, -2.5),
                  blurRadius: 5,
                  color: AppColors.blurTopColor,
                  inset: false,
                ),
                BoxShadow(
                  offset: const Offset(2.5, 2.5),
                  blurRadius: 5,
                  color: AppColors.blurBottomColor,
                  inset: false,
                ),
              ],
        ),
        child: Padding(
          padding: padding ?? context.paddingSymmetricR(horizontal: 0),
          child: NormalText(
            crossAxisAlignment:
                crossAxisAlignment ?? CrossAxisAlignment.center, // ✅ default
            titleText: text ?? '',
            titleSize: context.sp(16),
            titleWeight: FontWeight.w700,
            titleColor: colorText ?? AppColors.blurTopColor,
          ),
        ),
      ),
    );
  }
}
