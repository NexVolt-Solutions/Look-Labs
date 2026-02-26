import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';

class CameraWidget extends StatefulWidget {
  final VoidCallback onTapFun;
  final bool isSelected;
  const CameraWidget({
    super.key,
    required this.onTapFun,
    required this.isSelected,
  });

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PlanContainer(
          padding: context.paddingSymmetricR(horizontal: 28, vertical: 24),
          margin: context.paddingSymmetricR(horizontal: 0, vertical: 0),
          radius: BorderRadius.circular(context.radiusR(10)),
          isSelected: widget.isSelected,
          onTap: widget.onTapFun,
          // padding: context.paddingSymmetricR(horizontal: 28, vertical: 24),
          // margin: context.paddingSymmetricR(horizontal: 0, vertical: 0),
          // radius: BorderRadius.circular(context.radiusR(10)),
          // isSelected: isSelected,
          // onTap: () {
          //   setState(() {
          //     isSelected = !isSelected;
          //   });
          // },
          child: Column(
            children: [
              Container(
                padding: context.paddingSymmetricR(horizontal: 10.72, vertical: 12.92),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.backGroundColor,
                    width: context.sw(2),
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
                  height: context.sh(18.05),
                  width: context.sw(22.56),
                  color: isSelected
                      ? AppColors.pimaryColor
                      : AppColors.notSelectedColor,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: context.sh(4)),
              Text(
                'Tap to Capture',
                style: TextStyle(
                  fontSize: context.sp(12),
                  color: isSelected
                      ? AppColors.pimaryColor
                      : AppColors.notSelectedColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: context.sh(8)),
        NormalText(
          crossAxisAlignment: CrossAxisAlignment.center,
          titleText: 'Right View',
          titleColor: AppColors.subHeadingColor,
          titleSize: context.sp(14),
          titleWeight: FontWeight.w600,
          subText: 'Right View',
          subColor: AppColors.notSelectedColor,
          subSize: context.sp(10),
          subWeight: FontWeight.w500,
        ),
      ],
    );
  }
}
