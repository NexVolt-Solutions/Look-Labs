import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/Widget/normal_text.dart';
import 'package:looklabs/Core/Widget/plan_container.dart';

class ButtonCard extends StatelessWidget {
  final String? title;
  const ButtonCard({super.key, required this.listData, this.title});

  final List<String> listData;

  @override
  Widget build(BuildContext context) {
    return PlanContainer(
      margin: context.padSym(v: 10),
      padding: context.padSym(h: 12, v: 12),
      isSelected: false,
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NormalText(
            crossAxisAlignment: CrossAxisAlignment.start,
            titleText: title,
            titleSize: context.text(14),
            titleWeight: FontWeight.w600,
            titleColor: AppColors.subHeadingColor,
          ),
          SizedBox(height: context.h(12)),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: listData.map((item) {
              return PlanContainer(
                margin: context.padSym(v: 0),
                radius: BorderRadius.circular(context.radius(10)),
                padding: context.padSym(v: 8, h: 24),
                isSelected: false,
                onTap: () {},
                child: NormalText(
                  titleText: item,
                  titleSize: context.text(10),
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
