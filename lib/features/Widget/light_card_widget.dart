import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';

class LightCardWidget extends StatelessWidget {
  final String? text;
  const LightCardWidget({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    return PlanContainer(
      margin: context.paddingSymmetricR(vertical: 0),
      padding: context.paddingSymmetricR(horizontal: 12, vertical: 12),
      isSelected: false,
      onTap: () {},
      child: Row(
        children: [
          Container(
            height: context.sh(28),
            width: context.sw(28),
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
                height: context.sh(32),
                width: context.sw(32),
                child: SvgPicture.asset(
                  AppAssets.lightBulbIcon,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
          ),
          SizedBox(width: context.sw(11)),
          Expanded(
            child: NormalText(
              subText: text,
              subSize: context.sp(12),
              subWeight: FontWeight.w600,
              subColor: AppColors.iconColor,
            ),
          ),
        ],
      ),
    );
  }
}
