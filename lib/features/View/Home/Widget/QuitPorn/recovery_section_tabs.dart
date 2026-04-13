import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';

class RecoverySectionTabs extends StatelessWidget {
  const RecoverySectionTabs({
    super.key,
    required this.selectedSection,
    required this.onSectionChanged,
  });

  final String selectedSection;
  final ValueChanged<String> onSectionChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: PlanContainer(
            margin: context.paddingSymmetricR(vertical: 0, horizontal: 6),
            padding: context.paddingSymmetricR(horizontal: 16, vertical: 10),
            radius: BorderRadius.circular(context.radiusR(10)),
            isSelected: selectedSection == 'Daily Plan',
            onTap: () => onSectionChanged('Daily Plan'),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AppAssets.ageIcon,
                  width: context.sw(20),
                  height: context.sh(20),
                  colorFilter: ColorFilter.mode(
                    selectedSection == 'Daily Plan'
                        ? AppColors.pimaryColor
                        : AppColors.iconColor,
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(width: context.sw(8)),
                NormalText(
                  titleText: 'Daily Plan',
                  titleSize: context.sp(14),
                  titleWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: PlanContainer(
            margin: context.paddingSymmetricR(vertical: 0, horizontal: 6),
            padding: context.paddingSymmetricR(horizontal: 16, vertical: 10),
            radius: BorderRadius.circular(context.radiusR(10)),
            isSelected: selectedSection == 'Exercise',
            onTap: () => onSectionChanged('Exercise'),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AppAssets.exersieIcon,
                  width: context.sw(24),
                  height: context.sh(24),
                  colorFilter: ColorFilter.mode(
                    selectedSection == 'Exercise'
                        ? AppColors.pimaryColor
                        : AppColors.iconColor,
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(width: context.sw(8)),
                NormalText(
                  titleText: 'Exercise',
                  titleSize: context.sp(14),
                  titleWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
