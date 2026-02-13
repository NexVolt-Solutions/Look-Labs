import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/features/Widget/normal_text.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/features/Widget/plan_container.dart';

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
          padding: context.padSym(h: 28, v: 24),
          margin: context.padSym(h: 0, v: 0),
          radius: BorderRadius.circular(context.radius(10)),
          isSelected: widget.isSelected,
          onTap: widget.onTapFun,
          // padding: context.padSym(h: 28, v: 24),
          // margin: context.padSym(h: 0, v: 0),
          // radius: BorderRadius.circular(context.radius(10)),
          // isSelected: isSelected,
          // onTap: () {
          //   setState(() {
          //     isSelected = !isSelected;
          //   });
          // },
          child: Column(
            children: [
              Container(
                padding: context.padSym(h: 10.72, v: 12.92),
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
                  color: isSelected
                      ? AppColors.pimaryColor
                      : AppColors.notSelectedColor,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: context.h(4)),
              Text(
                'Tap to Capture',
                style: TextStyle(
                  fontSize: context.text(12),
                  color: isSelected
                      ? AppColors.pimaryColor
                      : AppColors.notSelectedColor,
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
