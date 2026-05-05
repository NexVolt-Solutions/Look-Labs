import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class SimpleCheckBox extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const SimpleCheckBox({
    super.key,
    required this.isSelected,
    required this.onTap,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: context.sh(26),
        width: context.sw(26),
        // margin: margin ?? context.paddingSymmetricR(vertical: 12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.white, width: context.sw(0.5)),
          color: isSelected ? AppColors.pimaryColor : AppColors.backGroundColor,
          boxShadow: isSelected
              ? []
              : [
                  BoxShadow(
                    offset: const Offset(-2.5, -2.5),
                    blurRadius: 5,
                    color: AppColors.blurTopColor,
                    inset: true,
                  ),
                  BoxShadow(
                    offset: const Offset(2.5, 2.5),
                    blurRadius: 5,
                    color: AppColors.blurBottomColor,
                    inset: true,
                  ),
                ],
        ),
        child: isSelected
            ? const Icon(Icons.check, color: Colors.white, size: 18)
            : const SizedBox(),
      ),
    );
  }
}
