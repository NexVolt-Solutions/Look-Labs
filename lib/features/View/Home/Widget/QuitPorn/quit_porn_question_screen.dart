import 'package:flutter/material.dart';
import 'package:looklabs/Features/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/ViewModel/quit_porn_view_model.dart';
import 'package:provider/provider.dart';

class QuitPornQuestion extends StatelessWidget {
  final int index;
  const QuitPornQuestion({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<QuitPornViewModel>(context);
    final data = vm.quitPornQuestions[index];

    return ListView(
      padding: context.paddingSymmetricR(horizontal: 20),
      children: [
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
