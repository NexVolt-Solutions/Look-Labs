import 'package:flutter/material.dart';
import 'package:looklabs/Core/Widget/app_bar_container.dart';
import 'package:looklabs/Core/Widget/custom_drop_down_field.dart';
import 'package:looklabs/Core/Widget/neu_text_fied.dart';
import 'package:looklabs/Core/Widget/normal_text.dart';
import 'package:looklabs/Core/Widget/plan_container.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/ViewModel/profile_view_model.dart';
import 'package:provider/provider.dart';

class QuestionPage extends StatelessWidget {
  final int index;
  const QuestionPage({required this.index});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ProfileViewModel>(context);
    final data = vm.questionData[index];

    return ListView(
      padding: context.padSym(h: 20),
      children: [
        if (index != 0) AppBarContainer(title: data['title'], onTap: vm.back),
        if (index == 0)
          NormalText(
            crossAxisAlignment: CrossAxisAlignment.center,
            titleText: data['title'],
            titleSize: context.text(20),
            titleWeight: FontWeight.w600,
            titleColor: AppColors.headingColor,
          ),
        SizedBox(height: context.h(20)),
        if (index == 0) ...[
          NeuTextField(
            label: 'What is your name?',
            hintText: 'Enter Name',
            keyboard: TextInputType.name,
            validatorType: '',
          ),
          SizedBox(height: context.h(18)),
          CustomDropdownField(
            label: "What is your age?",
            hintText: "Select Age",
            items: List.generate(100, (i) => "${i + 1} years"),
            onSelected: (String p1) {},
          ),
          SizedBox(height: context.h(18)),
          CustomDropdownField(
            label: "What is your Weight (lb)?",
            hintText: "Select Weight",
            items: List.generate(301, (i) => "${i + 50} lb"),
            onSelected: (String p1) {},
          ),
          SizedBox(height: context.h(18)),
          CustomDropdownField(
            label: "What is your Height (cm)?",
            hintText: "Select Height",
            items: List.generate(121, (i) => "${i + 100} cm"),
            onSelected: (String p1) {},
          ),
          SizedBox(height: context.h(18)),
        ],
        ...List.generate(data['questions'].length, (qIndex) {
          final q = data['questions'][qIndex];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: context.h(18)),
              NormalText(
                titleText: q['question'],
                titleSize: context.text(14),
                titleWeight: FontWeight.w600,
                titleColor: AppColors.subHeadingColor,
              ),
              SizedBox(height: context.h(18)),
              ...List.generate(q['options'].length, (oIndex) {
                return SizedBox(
                  width: double.infinity,
                  child: PlanContainer(
                    isSelected: vm.isSelected(index, qIndex, oIndex),
                    onTap: () => vm.selectOption(index, qIndex, oIndex),
                    padding: context.padSym(h: 22, v: 14),
                    child: Text(
                      q['options'][oIndex],
                      style: TextStyle(
                        color: AppColors.subHeadingColor,
                        fontSize: context.text(14),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                );
              }),
            ],
          );
        }),
      ],
    );
  }
}
