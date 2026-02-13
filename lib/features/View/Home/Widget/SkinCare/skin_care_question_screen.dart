import 'package:flutter/material.dart';
import 'package:looklabs/features/Widget/normal_text.dart';
import 'package:looklabs/features/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/features/ViewModel/skin_care_view_model.dart';
import 'package:provider/provider.dart';

class SkinCareQuestionPage extends StatelessWidget {
  final int index;
  const SkinCareQuestionPage({required this.index});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SkinCareViewModel>(context);
    final data = vm.skinCareQuestions[index];

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
            margin: context.padSym(v: 10),

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
