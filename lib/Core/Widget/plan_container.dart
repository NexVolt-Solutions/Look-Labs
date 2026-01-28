import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class PlanContainer extends StatelessWidget {
  /// Controls
  final double? height;
  final double? width;

  final bool? isSelected;
  final VoidCallback onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? radius;

  final Widget child;

  const PlanContainer({
    super.key,
    this.height,
    this.width,
    required this.isSelected,
    required this.onTap,
    required this.child,
    this.padding,
    this.radius,
    this.margin,
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
        margin: margin ?? context.padSym(v: 0),
        decoration: BoxDecoration(
          color: isSelected!
              ? AppColors.buttonColor.withOpacity(0.11) // selected bg
              : AppColors.backGroundColor,
          borderRadius: BorderRadius.circular(context.radius(10)),
          border: isSelected!
              ? Border.all(color: AppColors.pimaryColor, width: 1.5)
              : null,
          boxShadow: isSelected!
              ? [
                  BoxShadow(
                    color: AppColors.buttonColor.withOpacity(0.15),
                    offset: const Offset(5, 5),
                    blurRadius: 20,
                    inset: true,
                  ),
                  BoxShadow(
                    color: AppColors.buttonColor.withOpacity(0.15),
                    offset: const Offset(-5, -5),
                    blurRadius: 20,
                    inset: true,
                  ),
                ]
              : [
                  BoxShadow(
                    color: AppColors.customContainerColorUp.withOpacity(0.5),
                    offset: const Offset(5, 5),
                    blurRadius: 20,
                  ),
                  BoxShadow(
                    color: AppColors.customContinerColorDown,
                    offset: const Offset(-5, -5),
                    blurRadius: 20,
                  ),
                ],
        ),
        child: child,
      ),
    );
  }
}
