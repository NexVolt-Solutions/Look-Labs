import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/Widget/custom_button.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/utils/Routes/routes_name.dart';
import 'package:looklabs/View/Home/Widget/WorkOut/work_out_question_screen.dart';
import 'package:looklabs/ViewModel/work_out_view_model.dart';
import 'package:provider/provider.dart';

class WorkOut extends StatefulWidget {
  const WorkOut({super.key});

  @override
  State<WorkOut> createState() => _WorkOutState();
}

class _WorkOutState extends State<WorkOut> {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<WorkoutViewModel>(context);
    final isLast = vm.currentStep == vm.workoutQuestions.length - 1;

    return Scaffold(
      backgroundColor: AppColors.backGroundColor,

      bottomNavigationBar: CustomButton(
        text: isLast ? 'Start Analysis' : 'Next',
        color: AppColors.pimaryColor,
        isEnabled: true,
        onTap: () {
          if (isLast) {
            Navigator.pushNamed(context, RoutesName.WorkOutResultScreen);
          } else {
            vm.next();
          }
        },
        padding: context.padSym(v: 17),
      ),

      body: SafeArea(
        child: PageView.builder(
          controller: vm.pageController,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: vm.workoutQuestions.length,
          itemBuilder: (_, index) {
            return WorkOutQuestion(index: index);
          },
        ),
      ),
    );
  }
}
