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
    required this.tabs,
    required this.selectedSection,
    required this.onSectionChanged,
  });

  final List<String> tabs;
  final String selectedSection;
  final ValueChanged<String> onSectionChanged;

  @override
  Widget build(BuildContext context) {
    final labels = tabs.isEmpty
        ? const ['Daily Plan', 'Exercise']
        : (tabs.length >= 2 ? tabs.take(2).toList() : [tabs.first, 'Exercise']);
    final firstLabel = labels[0];
    final secondLabel = labels[1];

    return Row(
      children: [
        Expanded(
          child: PlanContainer(
            margin: context.paddingSymmetricR(vertical: 0, horizontal: 6),
            padding: context.paddingSymmetricR(horizontal: 16, vertical: 10),
            radius: BorderRadius.circular(context.radiusR(10)),
            isSelected: selectedSection == firstLabel,
            onTap: () => onSectionChanged(firstLabel),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  _isExerciseLabel(firstLabel)
                      ? AppAssets.exersieIcon
                      : AppAssets.ageIcon,
                  width: context.sw(20),
                  height: context.sh(20),
                  colorFilter: ColorFilter.mode(
                    selectedSection == firstLabel
                        ? AppColors.pimaryColor
                        : AppColors.iconColor,
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(width: context.sw(8)),
                NormalText(
                  titleText: firstLabel,
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
            isSelected: selectedSection == secondLabel,
            onTap: () => onSectionChanged(secondLabel),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  _isExerciseLabel(secondLabel)
                      ? AppAssets.exersieIcon
                      : AppAssets.ageIcon,
                  width: context.sw(24),
                  height: context.sh(24),
                  colorFilter: ColorFilter.mode(
                    selectedSection == secondLabel
                        ? AppColors.pimaryColor
                        : AppColors.iconColor,
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(width: context.sw(8)),
                NormalText(
                  titleText: secondLabel,
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

  bool _isExerciseLabel(String value) {
    final k = value.trim().toLowerCase();
    return k == 'exercise' ||
        k == 'exercises' ||
        k == 'exercise_plan' ||
        k == 'exercise plan';
  }
}
