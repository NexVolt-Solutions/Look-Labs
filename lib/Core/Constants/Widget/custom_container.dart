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
        height: height,
        width: width,
        margin: margin ?? EdgeInsets.zero,
        padding:
            padding ??
            EdgeInsets.symmetric(
              horizontal: context.w(8),
              vertical: context.h(8),
            ),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? context.radius(12)),
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
