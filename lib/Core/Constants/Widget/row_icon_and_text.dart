import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:looklabs/Core/Constants/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class RowIconAndText extends StatelessWidget {
  final String? titleText;
  final String? subText;
  final String? image;

  final VoidCallback? onTap;
  final bool isEnabled;

  const RowIconAndText({
    super.key,
    this.titleText,
    this.subText,
    this.onTap,
    required this.isEnabled,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,

      child: Padding(
        padding: context.padSym(h: 3, v: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: context.h(40),
              width: context.w(40),
              decoration: BoxDecoration(
                color: AppColors.backGroundColor,
                borderRadius: BorderRadius.circular(context.radius(16)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.customContainerColorUp.withOpacity(0.4),
                    offset: const Offset(5, 5),
                    blurRadius: 5,
                    inset: false,
                  ),
                  BoxShadow(
                    color: AppColors.customContinerColorDown,
                    offset: const Offset(-5, -5),
                    blurRadius: 9,
                    inset: false,
                  ),
                ],
              ),

              child: Center(child: Image.asset(image!)),
            ),
            SizedBox(width: context.w(10)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titleText!,
                    style: TextStyle(
                      fontSize: context.text(14),
                      fontWeight: FontWeight.w600,
                      color: AppColors.headingColor,
                    ),
                  ),
                  SizedBox(height: context.h(9)),
                  Text(
                    subText!,
                    style: TextStyle(
                      fontSize: context.text(12),
                      fontWeight: FontWeight.w400,
                      color: AppColors.headingColor,
                    ),
                  ),
                  // NormalText(
                  //   titleText: titleText!,
                  //   titleSize: context.text(14),
                  //   titleWeight: FontWeight.w600,
                  //   titleColor: AppColors.headingColor,
                  //   subText: subText!,
                  //   subSize: context.text(12),
                  //   subWeight: FontWeight.w400,
                  //   subColor: AppColors.seconderyColor,
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
