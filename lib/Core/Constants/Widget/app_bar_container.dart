import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:looklabs/Core/Constants/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class AppBarContainer extends StatelessWidget {
  final String? title;
  const AppBarContainer({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.only(
        left: context.w(3),
        top: context.h(7.11),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.only(left: context.w(8)),
              height: context.h(40),
              width: context.w(40),
              decoration: BoxDecoration(
                color: AppColors.backGroundColor,
                borderRadius: BorderRadius.circular(context.radius(16)),
                border: Border.all(
                  color: AppColors.white.withOpacity(0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.arrowBlurColor,
                    offset: const Offset(5, 5),
                    blurRadius: 5,
                  ),
                  BoxShadow(
                    color: AppColors.customContinerColorDown,
                    offset: const Offset(-5, -5),
                    blurRadius: 30,
                  ),
                ],
              ),

              child: Center(child: Icon(Icons.arrow_back_ios, size: 20)),
            ),
          ),
          SizedBox(width: context.w(86)),
          NormalText(
            crossAxisAlignment: CrossAxisAlignment.center,
            titleText: title!,
            titleSize: context.text(20),
            titleWeight: FontWeight.w600,
            titleColor: AppColors.headingColor,
          ),
        ],
      ),
    );
  }
}
