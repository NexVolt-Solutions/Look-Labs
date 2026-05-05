import 'package:flutter/material.dart';
import 'package:looklabs/Features/Widget/goal_activity_graph.dart';
import 'package:looklabs/Features/Widget/height_indicator.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/ViewModel/height_view_model.dart';
import 'package:provider/provider.dart';

class HeightQuestion extends StatelessWidget {
  final int index;
  const HeightQuestion({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HeightViewModel>(context);
    final data = vm.heightQuestions[index];

    final bool isLastScreen = index == vm.heightQuestions.length - 1;
    final bool shouldHideQuestionText = vm.shouldHideQuestionText(index);

    return ListView(
      padding: context.paddingSymmetricR(horizontal: 20),
      children: [
        if (!isLastScreen || !shouldHideQuestionText) ...[
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
        if (isLastScreen) ...[
          NormalText(
            crossAxisAlignment: CrossAxisAlignment.start,
            titleText: 'Your Height Goals',
            titleSize: context.sp(16),
            titleWeight: FontWeight.w600,
            titleColor: AppColors.subHeadingColor,
            sizeBoxheight: context.sh(4),
            subText: 'Set your current and desired height',
            subSize: context.sp(14),
            subWeight: FontWeight.w400,
            subColor: AppColors.subHeadingColor,
          ),

          SizedBox(height: context.sh(18)),

          GoalActivityGraph(
            title1: 'Current',
            title2: 'Goal',
            currentHeight: vm.currentHeightCm,
            desiredHeight: vm.desiredHeightCm,
          ),

          SizedBox(height: context.sh(18)),
          HeightIndicater(
            title: 'Current Height',
            initialValue: HeightViewModel.cmToSlider(vm.currentHeightCm),
            valueFormatter: vm.formatCm,
            onChanged: vm.setCurrentHeightFromSlider,
          ),
          SizedBox(height: context.sh(18)),
          HeightIndicater(
            title: 'Desired Height',
            initialValue: HeightViewModel.cmToSlider(vm.desiredHeightCm),
            valueFormatter: vm.formatCm,
            onChanged: vm.setDesiredHeightFromSlider,
          ),
        ],
      ],
    );
  }
}
