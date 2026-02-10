import 'package:flutter/material.dart';
import 'package:looklabs/Core/Widget/normal_text.dart';
import 'package:looklabs/Core/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/ViewModel/diet_view_model.dart';
import 'package:provider/provider.dart';

class DietQuestion extends StatelessWidget {
  final int index;
  const DietQuestion({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DietViewModel>(context);
    final data = vm.dietQuestions[index];

    return ListView(
      padding: context.padSym(h: 20),
      children: [
        NormalText(
          titleText: data['question'],
          titleSize: context.text(18),
          titleWeight: FontWeight.w600,
          titleColor: AppColors.headingColor,
        ),
        SizedBox(height: context.h(8)),
        ...List.generate(data['options'].length, (oIndex) {
          return PlanContainer(
            isSelected: vm.selectedOptions[index] == oIndex,
            onTap: () => vm.selectOption(index, oIndex),
            padding: context.padSym(h: 22, v: 14),
            child: Text(
              data['options'][oIndex],
              style: TextStyle(
                fontSize: context.text(14),
                color: AppColors.subHeadingColor,
              ),
            ),
          );
        }),
      ],
    );
  }
}
