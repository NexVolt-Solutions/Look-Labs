import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class CustomContiner extends StatelessWidget {
  final String title1;
  final String title2;
  final Color? title2Color;
  final VoidCallback? onTap;
  final bool isEnabled;

  const CustomContiner({
    super.key,
    required this.title1,
    required this.title2,
    this.title2Color,
    this.onTap,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        padding: context.paddingSymmetricR(horizontal: 17, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.backGroundColor,
          borderRadius: BorderRadius.circular(context.radiusR(16)),
          boxShadow: [
            BoxShadow(
              color: AppColors.customContainerColorUp.withOpacity(0.5),
              offset: const Offset(5, 5),
              blurRadius: 20,
              inset: false,
            ),
            BoxShadow(
              color: AppColors.customContinerColorDown,
              offset: const Offset(-5, -5),
              blurRadius: 20,
              inset: false,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title1,
              style: TextStyle(
                fontSize: context.sp(14),
                fontWeight: FontWeight.w600,
                color: AppColors.seconderyColor,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title2,
                  style: TextStyle(
                    fontSize: context.sp(14),
                    fontWeight: FontWeight.w600,
                    color: title2Color ?? AppColors.buttonColor,
                  ),
                ),
                SizedBox(width: context.sw(19)),
                Container(
                  height: context.sh(32),
                  width: context.sw(32),
                  decoration: BoxDecoration(
                    color: AppColors.backGroundColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.customContainerColorUp.withOpacity(
                          0.5,
                        ),
                        offset: const Offset(5, 5),
                        blurRadius: 20,
                        inset: false,
                      ),
                      BoxShadow(
                        color: AppColors.customContinerColorDown,
                        offset: const Offset(-5, -5),
                        blurRadius: 20,
                        inset: false,
                      ),
                    ],
                  ),
                  child: Icon(Icons.arrow_forward_ios, size: context.sh(16)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
