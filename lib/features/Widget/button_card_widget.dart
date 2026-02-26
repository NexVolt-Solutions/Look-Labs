import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';

class ButtonCard extends StatelessWidget {
  final String? title;
  const ButtonCard({super.key, required this.listData, this.title});

  final List<String> listData;

  @override
  Widget build(BuildContext context) {
    return PlanContainer(
      margin: context.paddingSymmetricR(vertical: 10),
      padding: context.paddingSymmetricR(horizontal: 12, vertical: 12),
      isSelected: false,
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NormalText(
            crossAxisAlignment: CrossAxisAlignment.start,
            titleText: title,
            titleSize: context.sp(14),
            titleWeight: FontWeight.w600,
            titleColor: AppColors.subHeadingColor,
          ),
          SizedBox(height: context.sh(12)),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: listData.map((item) {
              return PlanContainer(
                margin: context.paddingSymmetricR(vertical: 0),
                radius: BorderRadius.circular(context.radiusR(10)),
                padding: context.paddingSymmetricR(vertical: 8, horizontal: 24),
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
