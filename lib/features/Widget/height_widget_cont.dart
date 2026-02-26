import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class HeightWidgetCont extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final String? imgPath;
  final EdgeInsets? padding;

  const HeightWidgetCont({
    super.key,
    this.title,
    this.subTitle,
    this.imgPath,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: context.sh(120),
        width: context.sw(150),

        margin: EdgeInsetsGeometry.only(right: context.sh(18)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(context.radiusR(16)),
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
        child: Padding(
          padding: EdgeInsetsGeometry.only(top: context.sh(13)),
          child: Column(
            children: [
              Container(
                height: context.sh(44),
                width: context.sw(44),
                decoration: BoxDecoration(
                  color: AppColors.backGroundColor,
                  borderRadius: BorderRadius.circular(context.radiusR(10)),
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
                child: Center(
                  child: SizedBox(
                    height: context.sh(20),
                    width: context.sw(20),
                    child: SvgPicture.asset(
                      imgPath ?? AppAssets.heightIcon,
                      fit: BoxFit.scaleDown,
                      color: AppColors.pimaryColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: context.sh(9)),
              NormalText(
                crossAxisAlignment: CrossAxisAlignment.center,
                titleText: title ?? 'title',
                titleSize: context.sp(14),
                titleWeight: FontWeight.w600,
                titleColor: AppColors.subHeadingColor,
                sizeBoxheight: context.sh(3),
                subText: subTitle ?? 'subTitle',
                subSize: context.sp(12),
                subWeight: FontWeight.w400,
                subColor: AppColors.iconColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
