import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class CustomContainer extends StatelessWidget {
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? radius;
  final BoxBorder? border;
  final Widget? child;
  final VoidCallback? onTap;
  final Color? color;

  const CustomContainer({
    super.key,
    this.height,
    this.width,
    this.margin,
    this.padding,
    this.radius,
    this.border,
    this.child,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? context.h(30),
        width: width ?? context.w(60),
        margin: margin ?? EdgeInsets.zero,
        padding: padding ?? EdgeInsets.zero,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? context.radius(28)),
          border: border,
          color: color ?? AppColors.backGroundColor,
          boxShadow: [
            BoxShadow(
              color: AppColors.customContainerColorUp.withOpacity(0.4),
              offset: const Offset(5, 5),
              blurRadius: 5,
            ),
            BoxShadow(
              color: AppColors.customContinerColorDown.withOpacity(0.4),
              offset: const Offset(-5, -5),
              blurRadius: 5,
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
