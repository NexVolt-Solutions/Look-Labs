import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class GridData extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final String? image;

  const GridData({super.key, this.title, this.subTitle, this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: context.padSym(h: 12, v: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.radius(16)),
        color: AppColors.backGroundColor,
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
      child: Row(
        children: [
          Container(
            padding: context.padSym(h: 4, v: 4),
            // height: context.h(44),
            // width: context.w(44),
            decoration: BoxDecoration(
              color: AppColors.backGroundColor,
              borderRadius: BorderRadius.circular(context.radius(10)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.customContainerColorUp.withOpacity(0.4),
                  offset: const Offset(3, 3),
                  blurRadius: 4,
                ),
                BoxShadow(
                  color: AppColors.customContinerColorDown.withOpacity(0.4),
                  offset: const Offset(-3, -3),
                  blurRadius: 4,
                ),
              ],
            ),
            child: SvgPicture.asset(
              image ?? AppAssets.heightIcon,
              fit: BoxFit.scaleDown,
            ),
          ),

          SizedBox(width: context.w(6)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title ?? '',
                style: TextStyle(
                  fontSize: context.text(14),
                  fontWeight: FontWeight.w600,
                  color: AppColors.subHeadingColor,
                ),
              ),
              SizedBox(height: context.h(8)),
              Text(
                subTitle ?? '',
                style: TextStyle(
                  fontSize: context.text(12),
                  fontWeight: FontWeight.w400,
                  color: AppColors.notSelectedColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
