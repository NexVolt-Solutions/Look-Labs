import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class SimpleCheckBox extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const SimpleCheckBox({
    super.key,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: context.h(26),
        width: context.w(26),
        margin: context.padSym(v: 12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.white, width: context.w(0.5)),
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
