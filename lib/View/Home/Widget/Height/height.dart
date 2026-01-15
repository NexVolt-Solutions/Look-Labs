import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/Widget/custom_button.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Core/utils/Routes/routes_name.dart';
import 'package:looklabs/View/Home/Widget/Height/height_question_screen.dart';
import 'package:looklabs/ViewModel/height_view_model.dart';
import 'package:provider/provider.dart';

class Height extends StatefulWidget {
  const Height({super.key});

  @override
  State<Height> createState() => _HeightState();
}

class _HeightState extends State<Height> {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HeightViewModel>(context);
    final isLast = vm.currentStep == vm.heightQuestions.length - 1;

    return Scaffold(
      backgroundColor: AppColors.backGroundColor,

      bottomNavigationBar: CustomButton(
        text: isLast ? 'Complete' : 'Next',
        color: AppColors.pimaryColor,
        isEnabled: true,
        onTap: () {
          if (isLast) {
            Navigator.pushNamed(context, RoutesName.DailyHeightRoutineScreen);
          } else {
            vm.next();
          }
        },
        padding: context.padSym(h: 145, v: 17),
      ),

      body: SafeArea(
        child: PageView.builder(
          controller: vm.pageController,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: vm.heightQuestions.length,
          itemBuilder: (_, index) {
            return HeightQuestion(index: index);
          },
        ),
      ),
    );
  }
}
