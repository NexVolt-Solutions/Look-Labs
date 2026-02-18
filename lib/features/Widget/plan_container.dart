import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class PlanContainer extends StatelessWidget {
  /// Controls
  final double? height;
  final double? width;
  final Color? color;

  final bool? isSelected;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? radius;

  final Widget child;

  const PlanContainer({
    super.key,
    this.height,
    this.width,
    required this.isSelected,
    this.onTap,
    required this.child,
    this.padding,
    this.radius,
    this.margin,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            padding ??
            EdgeInsets.symmetric(
              horizontal: context.w(20),
              vertical: context.h(14),
            ),
        margin: margin ?? context.padSym(v: 10),
        decoration: BoxDecoration(
          borderRadius: radius ?? BorderRadius.circular(context.radius(10)),
          border: Border.all(
            color: isSelected!
                ? AppColors.pimaryColor
                : AppColors.backGroundColor,
            width: context.w(1.5),
          ),
          color: isSelected!
              ? AppColors.pimaryColor.withOpacity(0.15)
              : AppColors.backGroundColor,
          boxShadow: isSelected!
              ? []
              : [
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
