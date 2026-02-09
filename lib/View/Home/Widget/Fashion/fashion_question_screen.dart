import 'package:flutter/material.dart';
import 'package:looklabs/Core/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/ViewModel/fashion_view_model.dart';
import 'package:provider/provider.dart';

class FashionQuestion extends StatelessWidget {
  final int index;
  const FashionQuestion({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<FashionViewModel>(context);
    final data = vm.fashionQuestions[index];

    return ListView(
      padding: context.padSym(h: 20),
      children: [
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
