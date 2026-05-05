import 'package:flutter/material.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/ViewModel/facial_view_model.dart';
import 'package:provider/provider.dart';

class FacialQuestion extends StatelessWidget {
  final int index;
  const FacialQuestion({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<FacialViewModel>(context);
    final data = vm.facialQuestions[index];

    return ListView(
      padding: context.paddingSymmetricR(horizontal: 20),
      children: [
        NormalText(
          titleText: data['question'],
          titleSize: context.sp(18),
          titleWeight: FontWeight.w600,
          titleColor: AppColors.headingColor,
        ),
        SizedBox(height: context.sh(8)),
        ...List.generate(data['options'].length, (oIndex) {
          return PlanContainer(
            margin: context.paddingSymmetricR(vertical: 10),
            isSelected: vm.selectedOptions[index] == oIndex,
            onTap: () => vm.selectOption(index, oIndex),
            padding: context.paddingSymmetricR(horizontal: 22, vertical: 14),
            child: Text(
              data['options'][oIndex],
              style: TextStyle(
                fontSize: context.sp(14),
                color: AppColors.subHeadingColor,
              ),
            ),
          );
        }),
      ],
    );
  }
}
