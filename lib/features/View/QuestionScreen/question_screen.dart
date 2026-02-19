import 'package:flutter/material.dart';
import 'package:looklabs/Core/Constants/size_extension.dart';
import 'package:looklabs/Features/Widget/app_bar_container.dart';
import 'package:looklabs/Features/Widget/custom_button.dart';
import 'package:looklabs/Core/Constants/app_colors.dart';
import 'package:looklabs/Features/Widget/custom_stepper.dart';
import 'package:looklabs/Features/Widget/normal_text.dart';
import 'package:looklabs/Core/Routes/routes_name.dart';
import 'package:looklabs/Features/View/QuestionScreen/question_page.dart';
import 'package:looklabs/features/ViewModel/question_answer_view_model.dart';
import 'package:provider/provider.dart';

class QuestionScreen extends StatelessWidget {
  const QuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<QuestionAnswerViewModel>(context);
    final bool isLastStep = vm.currentStep == vm.questionData.length - 1;

    return Scaffold(
      backgroundColor: AppColors.backGroundColor,
      bottomNavigationBar: Padding(
        padding: context.padSym(h: 20, v: 30),
        child: CustomButton(
          text: vm.currentStep == 4 ? 'Complete' : 'Next',
          color: AppColors.pimaryColor,
          isEnabled: true,
          onTap: () {
            if (isLastStep) {
              Navigator.pushNamed(context, RoutesName.GaolScreen);
            } else {
              vm.next();
            }
          },
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: context.h(12)),
            if (vm.currentStep != 0)
              Padding(
                padding: context.padSym(h: 20),
                child: AppBarContainer(
                  title: vm.questionData[vm.currentStep]['title'],
                  onTap: vm.back,
                ),
              )
            else
              NormalText(
                crossAxisAlignment: CrossAxisAlignment.center,
                titleText: vm.questionData[vm.currentStep]['title'],
                titleSize: context.text(20),
                titleWeight: FontWeight.w600,
                titleColor: AppColors.headingColor,
              ),
            SizedBox(height: context.h(20)),
            Padding(
              padding: context.padSym(h: 20),
              child: CustomStepper(
                currentStep: vm.currentStep,
                steps: const [
                  'Profile',
                  'LifeStyle',
                  'Goals',
                  'Motivations',
                  'Planning',
                ],
              ),
            ),

            SizedBox(height: context.h(20)),

            /// 🔹 PAGE VIEW (EXPANDABLE CONTENT)
            Expanded(
              child: PageView.builder(
                controller: vm.pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: vm.questionData.length,
                itemBuilder: (_, index) => QuestionPage(index: index),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
