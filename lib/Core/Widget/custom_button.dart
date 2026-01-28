import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  // final EdgeInsetsGeometry? padding;
  final Color? color;
  final Color? colorText;
  final VoidCallback? onTap;
  final bool isEnabled;
  final List<BoxShadow>? boxShadows;

  const CustomButton({
    super.key,
    this.text,
    // this.padding,
    this.color,
    this.onTap,
    required this.isEnabled,
    this.colorText,
    this.boxShadows,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        padding: context.padSym(v: 18),
        margin: EdgeInsets.only(
          left: context.w(20),
          right: context.w(20),
          bottom: context.h(40),
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(context.radius(16)),
          boxShadow:
              boxShadows ??
              [
                BoxShadow(
                  offset: Offset(-2.5, -2.5),
                  blurRadius: 5,
                  color: AppColors.blurTopColor,
                  inset: false,
                ),
                BoxShadow(
                  offset: Offset(2.5, 2.5),
                  blurRadius: 5,
                  color: AppColors.blurBottomColor,
                  inset: false,
                ),
              ],
        ),
        child: Text(
          text!,
          style: TextStyle(
            color: colorText ?? AppColors.blurTopColor,
            fontSize: context.text(16),
            fontWeight: FontWeight.w700,
            fontFamily: 'Raleway',
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
