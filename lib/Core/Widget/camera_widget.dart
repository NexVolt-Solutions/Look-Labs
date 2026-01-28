import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Core/Widget/custom_container.dart';
import 'package:looklabs/Core/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';

class CameraWidget extends StatelessWidget {
  const CameraWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomContainer(
          // onTap: () => ageDetailsViewModel.selectItem(index),
          radius: context.radius(10),
          padding: context.padSym(h: 44, v: 28),
          // margin: context.padSym(v: 12),
          color:
              //  isSelected
              //     ? AppColors.buttonColor.withOpacity(0.11)
              //     :
              AppColors.backGroundColor,
          border:
              //  isSelected
              //     ?
              //     Border.all(color: AppColors.pimaryColor, width: 1.5)
              //     :
              null,
          child: Column(
            children: [
              Container(
                padding: context.padSym(h: 10.72, v: 12.92),
                // margin: context.padSym(v: 14),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.backGroundColor,
                    width: context.w(2),
                  ),
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
                child: SvgPicture.asset(
                  AppAssets.cameraIcon,
                  height: context.h(18.05),
                  width: context.w(22.56),
                  color: AppColors.notSelectedColor,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: context.h(4)),
              Text(
                'Tap to Capture',
                style: TextStyle(
                  fontSize: context.text(12),
                  color: AppColors.notSelectedColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: context.h(8)),
        NormalText(
          crossAxisAlignment: CrossAxisAlignment.center,
          titleText: 'Right View',
          titleColor: AppColors.subHeadingColor,
          titleSize: context.text(14),
          titleWeight: FontWeight.w600,
          subText: 'Right View',
          subColor: AppColors.notSelectedColor,
          subSize: context.text(10),
          subWeight: FontWeight.w500,
        ),
      ],
    );
  }
}
