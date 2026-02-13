import 'package:flutter/material.dart';
import 'package:looklabs/features/Widget/goal_activity_graph.dart';
import 'package:looklabs/features/Widget/height_indicator.dart';
import 'package:looklabs/features/Widget/normal_text.dart';
import 'package:looklabs/features/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/features/ViewModel/height_view_model.dart';
import 'package:provider/provider.dart';

class HeightQuestion extends StatelessWidget {
  final int index;
  const HeightQuestion({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HeightViewModel>(context);
    final data = vm.heightQuestions[index];

    final bool isLastScreen = index == vm.heightQuestions.length - 1;

    return ListView(
      padding: context.padSym(h: 20),
      children: [
        if (!isLastScreen) ...[
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
        if (isLastScreen) ...[
          NormalText(
            crossAxisAlignment: CrossAxisAlignment.start,
            titleText: 'Your Height Goals',
            titleSize: context.text(16),
            titleWeight: FontWeight.w600,
            titleColor: AppColors.subHeadingColor,
            sizeBoxheight: context.h(4),
            subText: 'Set your current and desired height',
            subSize: context.text(14),
            subWeight: FontWeight.w400,
            subColor: AppColors.subHeadingColor,
          ),

          SizedBox(height: context.h(18)),

          GoalActivityGraph(
            title1: 'Current',
            title2: 'Goal',
            currentHeight: 149,
            desiredHeight: 150,
          ),

          SizedBox(height: context.h(18)),
          HeightIndicater(
            title: 'Current Height',
            initialValue: 0.6,
            onChanged: (value) {
              debugPrint('Current value: ${(value * 100).round()}%');
            },
          ),
          SizedBox(height: context.h(18)),
          HeightIndicater(
            title: 'Desired Height',
            initialValue: 0.6,
            onChanged: (value) {
              debugPrint('Current value: ${(value * 100).round()}%');
            },
          ),
        ],
      ],
    );
  }
}
