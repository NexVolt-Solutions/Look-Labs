import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';

class StyleChipCardSection extends StatelessWidget {
  const StyleChipCardSection({
    super.key,
    required this.title,
    required this.chips,
    required this.leading,
  });

  final String title;
  final List<String> chips;
  final Widget leading;

  @override
  Widget build(BuildContext context) {
    return PlanContainer(
      margin: context.paddingSymmetricR(vertical: 0),
      padding: context.paddingSymmetricR(horizontal: 12, vertical: 12),
      isSelected: false,
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              leading,
              SizedBox(width: context.sw(11)),
              NormalText(
                crossAxisAlignment: CrossAxisAlignment.start,
                titleText: title,
                titleSize: context.sp(14),
                titleWeight: FontWeight.w600,
                titleColor: AppColors.subHeadingColor,
              ),
            ],
          ),
          SizedBox(height: context.sh(12)),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: chips.map((item) {
              return PlanContainer(
                margin: context.paddingSymmetricR(vertical: 0),
                radius: BorderRadius.circular(context.radiusR(10)),
                padding: context.paddingSymmetricR(vertical: 8, horizontal: 12),
                isSelected: false,
                onTap: () {},
                child: NormalText(
                  titleText: item,
                  titleSize: context.sp(10),
                  titleWeight: FontWeight.w600,
                  titleColor: AppColors.subHeadingColor,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
