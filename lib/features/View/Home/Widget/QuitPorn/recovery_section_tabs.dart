import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:looklabs/Core/Constants/app_assets.dart';
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
                SvgPicture.asset(AppAssets.ageIcon),
                SizedBox(width: context.sw(6)),
                NormalText(titleText: 'Daily Plan'),
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
                SvgPicture.asset(AppAssets.exersieIcon),
                SizedBox(width: context.sw(6)),
                NormalText(titleText: 'Exercise'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
