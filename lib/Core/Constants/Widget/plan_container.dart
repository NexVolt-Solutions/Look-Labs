import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class PlanContainer extends StatelessWidget {
  /// Controls
  final double height;
  final double? width;

  final bool? isSelected;
  final VoidCallback onTap;

  final Widget child;

  const PlanContainer({
    super.key,
    required this.height,
    this.width,
    required this.isSelected,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: height,
        width: width ?? double.infinity,
        padding: context.padSym(h: 12),
        margin: context.padSym(v: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(context.radius(10)),
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
